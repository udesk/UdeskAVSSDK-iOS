//
//  YYWebImageOperation.m
//  YYWebImage <https://github.com/ibireme/YYWebImage>
//
//  Created by ibireme on 15/2/15.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "UAVS_YYWebImageOperation.h"
#import "UIImage+UAVS_YYWebImage.h"
#import <ImageIO/ImageIO.h>
#import <libkern/OSAtomic.h>
#import "UAVS_YYImage.h"


#define MIN_PROGRESSIVE_TIME_INTERVAL 0.2
#define MIN_PROGRESSIVE_BLUR_TIME_INTERVAL 0.4


/// Returns nil in App Extension.
static UIApplication *_UavsYYSharedApplication() {
    static BOOL isAppExtension = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIApplication");
        if(!cls || ![cls respondsToSelector:@selector(sharedApplication)]) isAppExtension = YES;
        if ([[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]) isAppExtension = YES;
    });
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return isAppExtension ? nil : [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
}

/// Returns YES if the right-bottom pixel is filled.
static BOOL UavsYYCGImageLastPixelFilled(CGImageRef image) {
    if (!image) return NO;
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    if (width == 0 || height == 0) return NO;
    CGContextRef ctx = CGBitmapContextCreate(NULL, 1, 1, 8, 0, UAVS_YYCGColorSpaceGetDeviceRGB(), kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrderDefault);
    if (!ctx) return NO;
    CGContextDrawImage(ctx, CGRectMake( -(int)width + 1, 0, width, height), image);
    uint8_t *bytes = CGBitmapContextGetData(ctx);
    BOOL isAlpha = bytes && bytes[0] == 0;
    CFRelease(ctx);
    return !isAlpha;
}

/// Returns JPEG SOS (Start Of Scan) Marker
static NSData *UavsJPEGSOSMarker() {
    // "Start Of Scan" Marker
    static NSData *marker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uint8_t bytes[2] = {0xFF, 0xDA};
        marker = [NSData dataWithBytes:bytes length:2];
    });
    return marker;
}


static NSMutableSet *UavsURLBlacklist;
static dispatch_semaphore_t UavsURLBlacklistLock;

static void UavsURLBlacklistInit() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UavsURLBlacklist = [NSMutableSet new];
        UavsURLBlacklistLock = dispatch_semaphore_create(1);
    });
}

static BOOL UavsURLBlackListContains(NSURL *url) {
    if (!url || url == (id)[NSNull null]) return NO;
    UavsURLBlacklistInit();
    dispatch_semaphore_wait(UavsURLBlacklistLock, DISPATCH_TIME_FOREVER);
    BOOL contains = [UavsURLBlacklist containsObject:url];
    dispatch_semaphore_signal(UavsURLBlacklistLock);
    return contains;
}

static void UavsURLInBlackListAdd(NSURL *url) {
    if (!url || url == (id)[NSNull null]) return;
    UavsURLBlacklistInit();
    dispatch_semaphore_wait(UavsURLBlacklistLock, DISPATCH_TIME_FOREVER);
    [UavsURLBlacklist addObject:url];
    dispatch_semaphore_signal(UavsURLBlacklistLock);
}


/// A proxy used to hold a weak object.
@interface UAVS_YYWebImageWeakProxy : NSProxy
@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end

@implementation UAVS_YYWebImageWeakProxy
- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[UAVS_YYWebImageWeakProxy alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}
- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}
- (NSUInteger)hash {
    return [_target hash];
}
- (Class)superclass {
    return [_target superclass];
}
- (Class)class {
    return [_target class];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}
- (BOOL)isProxy {
    return YES;
}
- (NSString *)description {
    return [_target description];
}
- (NSString *)debugDescription {
    return [_target debugDescription];
}
@end


@interface UAVS_YYWebImageOperation() <NSURLConnectionDelegate>
@property (readwrite, getter=isExecuting) BOOL executing;
@property (readwrite, getter=isFinished) BOOL finished;
@property (readwrite, getter=isCancelled) BOOL cancelled;
@property (readwrite, getter=isStarted) BOOL started;
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, assign) UIBackgroundTaskIdentifier taskID;

@property (nonatomic, assign) NSTimeInterval lastProgressiveDecodeTimestamp;
@property (nonatomic, strong) UAVS_YYImageDecoder *progressiveDecoder;
@property (nonatomic, assign) BOOL progressiveIgnored;
@property (nonatomic, assign) BOOL progressiveDetected;
@property (nonatomic, assign) NSUInteger progressiveScanedLength;
@property (nonatomic, assign) NSUInteger progressiveDisplayCount;

@property (nonatomic, copy) UAVS_YYWebImageProgressBlock progress;
@property (nonatomic, copy) UAVS_YYWebImageTransformBlock transform;
@property (nonatomic, copy) UAVS_YYWebImageCompletionBlock completion;
@end


@implementation UAVS_YYWebImageOperation
@synthesize executing = _executing;
@synthesize finished = _finished;
@synthesize cancelled = _cancelled;

/// Network thread entry point.
+ (void)_networkThreadMain:(id)object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.ibireme.webimage.request"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

/// Global image request network thread, used by NSURLConnection delegate.
+ (NSThread *)_networkThread {
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(_networkThreadMain:) object:nil];
        if ([thread respondsToSelector:@selector(setQualityOfService:)]) {
            thread.qualityOfService = NSQualityOfServiceBackground;
        }
        [thread start];
    });
    return thread;
}

/// Global image queue, used for image reading and decoding.
+ (dispatch_queue_t)_imageQueue {
    #define MAX_QUEUE_COUNT 16
    static int queueCount;
    static dispatch_queue_t queues[MAX_QUEUE_COUNT];
    static dispatch_once_t onceToken;
    static int32_t counter = 0;
    dispatch_once(&onceToken, ^{
        queueCount = (int)[NSProcessInfo processInfo].activeProcessorCount;
        queueCount = queueCount < 1 ? 1 : queueCount > MAX_QUEUE_COUNT ? MAX_QUEUE_COUNT : queueCount;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            for (NSUInteger i = 0; i < queueCount; i++) {
                dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_UTILITY, 0);
                queues[i] = dispatch_queue_create("com.ibireme.image.decode", attr);
            }
        } else {
            for (NSUInteger i = 0; i < queueCount; i++) {
                queues[i] = dispatch_queue_create("com.ibireme.image.decode", DISPATCH_QUEUE_SERIAL);
                dispatch_set_target_queue(queues[i], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0));
            }
        }
    });
    int32_t cur = OSAtomicIncrement32(&counter);
    if (cur < 0) cur = -cur;
    return queues[(cur) % queueCount];
    #undef MAX_QUEUE_COUNT
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YYWebImageOperation init error" reason:@"YYWebImageOperation must be initialized with a request. Use the designated initializer to init." userInfo:nil];
    return [self initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]] options:0 cache:nil cacheKey:nil progress:nil transform:nil completion:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                        options:(UAVS_YYWebImageOptions)options
                          cache:(UAVS_YYImageCache *)cache
                       cacheKey:(NSString *)cacheKey
                       progress:(UAVS_YYWebImageProgressBlock)progress
                      transform:(UAVS_YYWebImageTransformBlock)transform
                     completion:(UAVS_YYWebImageCompletionBlock)completion {
    self = [super init];
    if (!self) return nil;
    if (!request) return nil;
    _request = request;
    _options = options;
    _cache = cache;
    _cacheKey = cacheKey ? cacheKey : request.URL.absoluteString;
    _shouldUseCredentialStorage = YES;
    _progress = progress;
    _transform = transform;
    _completion = completion;
    _executing = NO;
    _finished = NO;
    _cancelled = NO;
    _taskID = UIBackgroundTaskInvalid;
    _lock = [NSRecursiveLock new];
    return self;
}

- (void)dealloc {
    [_lock lock];
    if (_taskID != UIBackgroundTaskInvalid) {
        [_UavsYYSharedApplication() endBackgroundTask:_taskID];
        _taskID = UIBackgroundTaskInvalid;
    }
    if ([self isExecuting]) {
        self.cancelled = YES;
        self.finished = YES;
        if (_connection) {
            [_connection cancel];
            if (![_request.URL isFileURL] && (_options & UAVS_YYWebImageOptionShowNetworkActivity)) {
                [UAVS_YYWebImageManager decrementNetworkActivityCount];
            }
        }
        if (_completion) {
            @autoreleasepool {
                _completion(nil, _request.URL, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageCancelled, nil);
            }
        }
    }
    [_lock unlock];
}

- (void)_endBackgroundTask {
    [_lock lock];
    if (_taskID != UIBackgroundTaskInvalid) {
        [_UavsYYSharedApplication() endBackgroundTask:_taskID];
        _taskID = UIBackgroundTaskInvalid;
    }
    [_lock unlock];
}

#pragma mark - Runs in operation thread

- (void)_finish {
    self.executing = NO;
    self.finished = YES;
    [self _endBackgroundTask];
}

// runs on network thread
- (void)_startOperation {
    if ([self isCancelled]) return;
    @autoreleasepool {
        // get image from cache
        if (_cache &&
            !(_options & UAVS_YYWebImageOptionUseNSURLCache) &&
            !(_options & UAVS_YYWebImageOptionRefreshImageCache)) {
            UIImage *image = [_cache getImageForKey:_cacheKey withType:UAVS_YYImageCacheTypeMemory];
            if (image) {
                [_lock lock];
                if (![self isCancelled]) {
                    if (_completion) _completion(image, _request.URL, UAVS_YYWebImageFromMemoryCache, UAVS_YYWebImageStageFinished, nil);
                }
                [self _finish];
                [_lock unlock];
                return;
            }
            if (!(_options & UAVS_YYWebImageOptionIgnoreDiskCache)) {
                __weak typeof(self) _self = self;
                dispatch_async([self.class _imageQueue], ^{
                    __strong typeof(_self) self = _self;
                    if (!self || [self isCancelled]) return;
                    UIImage *image = [self.cache getImageForKey:self.cacheKey withType:UAVS_YYImageCacheTypeDisk];
                    if (image) {
                        [self.cache setImage:image imageData:nil forKey:self.cacheKey withType:UAVS_YYImageCacheTypeMemory];
                        [self performSelector:@selector(_didReceiveImageFromDiskCache:) onThread:[self.class _networkThread] withObject:image waitUntilDone:NO];
                    } else {
                        [self performSelector:@selector(_startRequest:) onThread:[self.class _networkThread] withObject:nil waitUntilDone:NO];
                    }
                });
                return;
            }
        }
    }
    [self performSelector:@selector(_startRequest:) onThread:[self.class _networkThread] withObject:nil waitUntilDone:NO];
}

// runs on network thread
- (void)_startRequest:(id)object {
    if ([self isCancelled]) return;
    @autoreleasepool {
        if ((_options & UAVS_YYWebImageOptionIgnoreFailedURL) && UavsURLBlackListContains(_request.URL)) {
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{ NSLocalizedDescriptionKey : @"Failed to load URL, blacklisted." }];
            [_lock lock];
            if (![self isCancelled]) {
                if (_completion) _completion(nil, _request.URL, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageFinished, error);
            }
            [self _finish];
            [_lock unlock];
            return;
        }
        
        if (_request.URL.isFileURL) {
            NSArray *keys = @[NSURLFileSizeKey];
            NSDictionary *attr = [_request.URL resourceValuesForKeys:keys error:nil];
            NSNumber *fileSize = attr[NSURLFileSizeKey];
            _expectedSize = fileSize ? fileSize.unsignedIntegerValue : -1;
        }
        
        // request image from web
        [_lock lock];
        if (![self isCancelled]) {
            _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:[UAVS_YYWebImageWeakProxy proxyWithTarget:self]];
            if (![_request.URL isFileURL] && (_options & UAVS_YYWebImageOptionShowNetworkActivity)) {
                [UAVS_YYWebImageManager incrementNetworkActivityCount];
            }
        }
        [_lock unlock];
    }
}

// runs on network thread, called from outer "cancel"
- (void)_cancelOperation {
    @autoreleasepool {
        if (_connection) {
            if (![_request.URL isFileURL] && (_options & UAVS_YYWebImageOptionShowNetworkActivity)) {
                [UAVS_YYWebImageManager decrementNetworkActivityCount];
            }
        }
        [_connection cancel];
        _connection = nil;
        if (_completion) _completion(nil, _request.URL, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageCancelled, nil);
        [self _endBackgroundTask];
    }
}


// runs on network thread
- (void)_didReceiveImageFromDiskCache:(UIImage *)image {
    @autoreleasepool {
        [_lock lock];
        if (![self isCancelled]) {
            if (image) {
                if (_completion) _completion(image, _request.URL, UAVS_YYWebImageFromDiskCache, UAVS_YYWebImageStageFinished, nil);
                [self _finish];
            } else {
                [self _startRequest:nil];
            }
        }
        [_lock unlock];
    }
}

- (void)_didReceiveImageFromWeb:(UIImage *)image {
    @autoreleasepool {
        [_lock lock];
        if (![self isCancelled]) {
            if (_cache) {
                if (image || (_options & UAVS_YYWebImageOptionRefreshImageCache)) {
                    NSData *data = _data;
                    dispatch_async([UAVS_YYWebImageOperation _imageQueue], ^{
                        [_cache setImage:image imageData:data forKey:_cacheKey withType:UAVS_YYImageCacheTypeAll];
                    });
                }
            }
            _data = nil;
            NSError *error = nil;
            if (!image) {
                error = [NSError errorWithDomain:@"com.ibireme.image" code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"Web image decode fail." }];
                if (_options & UAVS_YYWebImageOptionIgnoreFailedURL) {
                    if (UavsURLBlackListContains(_request.URL)) {
                        error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{ NSLocalizedDescriptionKey : @"Failed to load URL, blacklisted." }];
                    } else {
                        UavsURLInBlackListAdd(_request.URL);
                    }
                }
            }
            if (_completion) _completion(image, _request.URL, UAVS_YYWebImageFromRemote, UAVS_YYWebImageStageFinished, error);
            [self _finish];
        }
        [_lock unlock];
    }
}

#pragma mark - NSURLConnectionDelegate runs in operation thread

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return _shouldUseCredentialStorage;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    @autoreleasepool {
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if (!(NO) &&
                [challenge.sender respondsToSelector:@selector(performDefaultHandlingForAuthenticationChallenge:)]) {
                [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
            } else {
                NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            }
        } else {
            if ([challenge previousFailureCount] == 0) {
                if (_credential) {
                    [[challenge sender] useCredential:_credential forAuthenticationChallenge:challenge];
                } else {
                    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
                }
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    if (!cachedResponse) return cachedResponse;
    if (_options & UAVS_YYWebImageOptionUseNSURLCache) {
        return cachedResponse;
    } else {
        // ignore NSURLCache
        return nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    @autoreleasepool {
        NSError *error = nil;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (id) response;
            NSInteger statusCode = httpResponse.statusCode;
            if (statusCode >= 400 || statusCode == 304) {
                error = [NSError errorWithDomain:NSURLErrorDomain code:statusCode userInfo:nil];
            }
        }
        if (error) {
            [_connection cancel];
            [self connection:_connection didFailWithError:error];
        } else {
            if (response.expectedContentLength) {
                _expectedSize = (NSInteger)response.expectedContentLength;
                if (_expectedSize < 0) _expectedSize = -1;
            }
            _data = [NSMutableData dataWithCapacity:_expectedSize > 0 ? _expectedSize : 0];
            if (_progress) {
                [_lock lock];
                if (![self isCancelled]) _progress(0, _expectedSize);
                [_lock unlock];
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    @autoreleasepool {
        [_lock lock];
        BOOL canceled = [self isCancelled];
        [_lock unlock];
        if (canceled) return;
        
        if (data) [_data appendData:data];
        if (_progress) {
            [_lock lock];
            if (![self isCancelled]) {
                _progress(_data.length, _expectedSize);
            }
            [_lock unlock];
        }
        
        /*--------------------------- progressive ----------------------------*/
        BOOL progressive = (_options & UAVS_YYWebImageOptionProgressive) > 0;
        BOOL progressiveBlur = (_options & UAVS_YYWebImageOptionProgressiveBlur) > 0;
        if (!_completion || !(progressive || progressiveBlur)) return;
        if (data.length <= 16) return;
        if (_expectedSize > 0 && data.length >= _expectedSize * 0.99) return;
        if (_progressiveIgnored) return;
        
        NSTimeInterval min = progressiveBlur ? MIN_PROGRESSIVE_BLUR_TIME_INTERVAL : MIN_PROGRESSIVE_TIME_INTERVAL;
        NSTimeInterval now = CACurrentMediaTime();
        if (now - _lastProgressiveDecodeTimestamp < min) return;
        
        if (!_progressiveDecoder) {
            _progressiveDecoder = [[UAVS_YYImageDecoder alloc] initWithScale:[UIScreen mainScreen].scale];
        }
        [_progressiveDecoder updateData:_data final:NO];
        if ([self isCancelled]) return;
        
        if (_progressiveDecoder.type == UAVS_YYImageTypeUnknown ||
            _progressiveDecoder.type == UAVS_YYImageTypeWebP ||
            _progressiveDecoder.type == UAVS_YYImageTypeOther) {
            _progressiveDecoder = nil;
            _progressiveIgnored = YES;
            return;
        }
        if (progressiveBlur) { // only support progressive JPEG and interlaced PNG
            if (_progressiveDecoder.type != UAVS_YYImageTypeJPEG &&
                _progressiveDecoder.type != UAVS_YYImageTypePNG) {
                _progressiveDecoder = nil;
                _progressiveIgnored = YES;
                return;
            }
        }
        if (_progressiveDecoder.frameCount == 0) return;
        
        if (!progressiveBlur) {
            UAVS_YYImageFrame *frame = [_progressiveDecoder frameAtIndex:0 decodeForDisplay:YES];
            if (frame.image) {
                [_lock lock];
                if (![self isCancelled]) {
                    _completion(frame.image, _request.URL, UAVS_YYWebImageFromRemote, UAVS_YYWebImageStageProgress, nil);
                    _lastProgressiveDecodeTimestamp = now;
                }
                [_lock unlock];
            }
            return;
        } else {
            if (_progressiveDecoder.type == UAVS_YYImageTypeJPEG) {
                if (!_progressiveDetected) {
                    NSDictionary *dic = [_progressiveDecoder framePropertiesAtIndex:0];
                    NSDictionary *jpeg = dic[(id)kCGImagePropertyJFIFDictionary];
                    NSNumber *isProg = jpeg[(id)kCGImagePropertyJFIFIsProgressive];
                    if (!isProg.boolValue) {
                        _progressiveIgnored = YES;
                        _progressiveDecoder = nil;
                        return;
                    }
                    _progressiveDetected = YES;
                }
                
                NSInteger scanLength = (NSInteger)_data.length - (NSInteger)_progressiveScanedLength - 4;
                if (scanLength <= 2) return;
                NSRange scanRange = NSMakeRange(_progressiveScanedLength, scanLength);
                NSRange markerRange = [_data rangeOfData:UavsJPEGSOSMarker() options:kNilOptions range:scanRange];
                _progressiveScanedLength = _data.length;
                if (markerRange.location == NSNotFound) return;
                if ([self isCancelled]) return;
                
            } else if (_progressiveDecoder.type == UAVS_YYImageTypePNG) {
                if (!_progressiveDetected) {
                    NSDictionary *dic = [_progressiveDecoder framePropertiesAtIndex:0];
                    NSDictionary *png = dic[(id)kCGImagePropertyPNGDictionary];
                    NSNumber *isProg = png[(id)kCGImagePropertyPNGInterlaceType];
                    if (!isProg.boolValue) {
                        _progressiveIgnored = YES;
                        _progressiveDecoder = nil;
                        return;
                    }
                    _progressiveDetected = YES;
                }
            }
            
            UAVS_YYImageFrame *frame = [_progressiveDecoder frameAtIndex:0 decodeForDisplay:YES];
            UIImage *image = frame.image;
            if (!image) return;
            if ([self isCancelled]) return;
            
            if (!UavsYYCGImageLastPixelFilled(image.CGImage)) return;
            _progressiveDisplayCount++;
            
            CGFloat radius = 32;
            if (_expectedSize > 0) {
                radius *= 1.0 / (3 * _data.length / (CGFloat)_expectedSize + 0.6) - 0.25;
            } else {
                radius /= (_progressiveDisplayCount);
            }
            image = [image uavs_yy_imageByBlurRadius:radius tintColor:nil tintMode:0 saturation:1 maskImage:nil];
            
            if (image) {
                [_lock lock];
                if (![self isCancelled]) {
                    _completion(image, _request.URL, UAVS_YYWebImageFromRemote, UAVS_YYWebImageStageProgress, nil);
                    _lastProgressiveDecodeTimestamp = now;
                }
                [_lock unlock];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    @autoreleasepool {
        [_lock lock];
        _connection = nil;
        if (![self isCancelled]) {
            __weak typeof(self) _self = self;
            dispatch_async([self.class _imageQueue], ^{
                __strong typeof(_self) self = _self;
                if (!self) return;
                
                BOOL shouldDecode = (self.options & UAVS_YYWebImageOptionIgnoreImageDecoding) == 0;
                BOOL allowAnimation = (self.options & UAVS_YYWebImageOptionIgnoreAnimatedImage) == 0;
                UIImage *image;
                BOOL hasAnimation = NO;
                if (allowAnimation) {
                    image = [[UAVS_YYImage alloc] initWithData:self.data scale:[UIScreen mainScreen].scale];
                    if (shouldDecode) image = [image yy_imageByDecoded];
                    if ([((UAVS_YYImage *)image) animatedImageFrameCount] > 1) {
                        hasAnimation = YES;
                    }
                } else {
                    UAVS_YYImageDecoder *decoder = [UAVS_YYImageDecoder decoderWithData:self.data scale:[UIScreen mainScreen].scale];
                    image = [decoder frameAtIndex:0 decodeForDisplay:shouldDecode].image;
                }
                
                /*
                 If the image has animation, save the original image data to disk cache.
                 If the image is not PNG or JPEG, re-encode the image to PNG or JPEG for
                 better decoding performance.
                 */
                UAVS_YYImageType imageType = UAVS_YYImageDetectType((__bridge CFDataRef)self.data);
                switch (imageType) {
                    case UAVS_YYImageTypeJPEG:
                    case UAVS_YYImageTypeGIF:
                    case UAVS_YYImageTypePNG:
                    case UAVS_YYImageTypeWebP: { // save to disk cache
                        if (!hasAnimation) {
                            if (imageType == UAVS_YYImageTypeGIF ||
                                imageType == UAVS_YYImageTypeWebP) {
                                self.data = nil; // clear the data, re-encode for disk cache
                            }
                        }
                    } break;
                    default: {
                        self.data = nil; // clear the data, re-encode for disk cache
                    } break;
                }
                if ([self isCancelled]) return;
                
                if (self.transform && image) {
                    UIImage *newImage = self.transform(image, self.request.URL);
                    if (newImage != image) {
                        self.data = nil;
                    }
                    image = newImage;
                    if ([self isCancelled]) return;
                }
                
                [self performSelector:@selector(_didReceiveImageFromWeb:) onThread:[self.class _networkThread] withObject:image waitUntilDone:NO];
            });
            if (![self.request.URL isFileURL] && (self.options & UAVS_YYWebImageOptionShowNetworkActivity)) {
                [UAVS_YYWebImageManager decrementNetworkActivityCount];
            }
        }
        [_lock unlock];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    @autoreleasepool {
        [_lock lock];
        if (![self isCancelled]) {
            if (_completion) {
                _completion(nil, _request.URL, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageFinished, error);
            }
            _connection = nil;
            _data = nil;
            if (![_request.URL isFileURL] && (_options & UAVS_YYWebImageOptionShowNetworkActivity)) {
                [UAVS_YYWebImageManager decrementNetworkActivityCount];
            }
            [self _finish];
            
            if (_options & UAVS_YYWebImageOptionIgnoreFailedURL) {
                if (error.code != NSURLErrorNotConnectedToInternet &&
                    error.code != NSURLErrorCancelled &&
                    error.code != NSURLErrorTimedOut &&
                    error.code != NSURLErrorUserCancelledAuthentication) {
                    UavsURLInBlackListAdd(_request.URL);
                }
            }
        }
        [_lock unlock];
    }
}

#pragma mark - Override NSOperation

- (void)start {
    @autoreleasepool {
        [_lock lock];
        self.started = YES;
        if ([self isCancelled]) {
            [self performSelector:@selector(_cancelOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
            self.finished = YES;
        } else if ([self isReady] && ![self isFinished] && ![self isExecuting]) {
            if (!_request) {
                self.finished = YES;
                if (_completion) {
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:@{NSLocalizedDescriptionKey:@"request in nil"}];
                    _completion(nil, _request.URL, UAVS_YYWebImageFromNone, UAVS_YYWebImageStageFinished, error);
                }
            } else {
                self.executing = YES;
                [self performSelector:@selector(_startOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
                if ((_options & UAVS_YYWebImageOptionAllowBackgroundTask) && _UavsYYSharedApplication()) {
                    __weak __typeof__ (self) _self = self;
                    if (_taskID == UIBackgroundTaskInvalid) {
                        _taskID = [_UavsYYSharedApplication() beginBackgroundTaskWithExpirationHandler:^{
                            __strong __typeof (_self) self = _self;
                            if (self) {
                                [self cancel];
                                self.finished = YES;
                            }
                        }];
                    }
                }
            }
        }
        [_lock unlock];
    }
}

- (void)cancel {
    [_lock lock];
    if (![self isCancelled]) {
        [super cancel];
        self.cancelled = YES;
        if ([self isExecuting]) {
            self.executing = NO;
            [self performSelector:@selector(_cancelOperation) onThread:[[self class] _networkThread] withObject:nil waitUntilDone:NO modes:@[NSDefaultRunLoopMode]];
        }
        if (self.started) {
            self.finished = YES;
        }
    }
    [_lock unlock];
}

- (void)setExecuting:(BOOL)executing {
    [_lock lock];
    if (_executing != executing) {
        [self willChangeValueForKey:@"isExecuting"];
        _executing = executing;
        [self didChangeValueForKey:@"isExecuting"];
    }
    [_lock unlock];
}

- (BOOL)isExecuting {
    [_lock lock];
    BOOL executing = _executing;
    [_lock unlock];
    return executing;
}

- (void)setFinished:(BOOL)finished {
    [_lock lock];
    if (_finished != finished) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = finished;
        [self didChangeValueForKey:@"isFinished"];
    }
    [_lock unlock];
}

- (BOOL)isFinished {
    [_lock lock];
    BOOL finished = _finished;
    [_lock unlock];
    return finished;
}

- (void)setCancelled:(BOOL)cancelled {
    [_lock lock];
    if (_cancelled != cancelled) {
        [self willChangeValueForKey:@"isCancelled"];
        _cancelled = cancelled;
        [self didChangeValueForKey:@"isCancelled"];
    }
    [_lock unlock];
}

- (BOOL)isCancelled {
    [_lock lock];
    BOOL cancelled = _cancelled;
    [_lock unlock];
    return cancelled;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isAsynchronous {
    return YES;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([key isEqualToString:@"isExecuting"] ||
        [key isEqualToString:@"isFinished"] ||
        [key isEqualToString:@"isCancelled"]) {
        return NO;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@"<%@: %p ",self.class, self];
    [string appendFormat:@" executing:%@", [self isExecuting] ? @"YES" : @"NO"];
    [string appendFormat:@" finished:%@", [self isFinished] ? @"YES" : @"NO"];
    [string appendFormat:@" cancelled:%@", [self isCancelled] ? @"YES" : @"NO"];
    [string appendString:@">"];
    return string;
}

@end
