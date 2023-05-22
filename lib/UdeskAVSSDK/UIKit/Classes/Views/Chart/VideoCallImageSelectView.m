//
//  VideoCallImageSelectView.m
//  UdeskApp
//
//  Created by 陈历 on 2020/4/6.
//  Copyright © 2020 xushichen. All rights reserved.
//

#import "VideoCallImageSelectView.h"
#import <Photos/Photos.h>
#import "UIView+UdeskAVS.h"
#import "UdeskAVSMacroHeader.h"
#import "UIColor+UdeskAVS.h"

#import "UdeskProjectHeader.h"


static char assetKey = 'a';

static NSInteger imageTag = 100;
static NSInteger selectImageTag = 101;

@interface VideoCallImageSelectView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation VideoCallImageSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    UIView *topView = [self creatTopView];
    [self addSubview:topView];
    
    [self addSubview:self.collectionView];
}

- (NSMutableArray *)photoArray{
    if (!_photoArray) {
        _photoArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArray;
}

- (void)getThumbnailImages{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO array:tmpArray];
        }
        // 获得相机胶卷
        PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
        [self enumerateAssetsInAssetCollection:cameraRoll original:NO array:tmpArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoArray = tmpArray;
            [self.collectionView reloadData];
        });
        
    });
}

- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original array:(NSMutableArray *)array
{
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        //NSLog(@"aaaa");
        // 是否要原图
        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(150, 150);
        
        // 从asset中获得图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if (result) {
                //NSLog(@"%@",asset);
                [result setAssociateValue:asset withKey:&assetKey];
                [array addObject:result];
            }
        }];
    }
}

- (void)show:(BOOL)value{
    self.selectedIndex = -1;
    
    if (value) {
        [self getThumbnailImages];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (value) {
            self.bottom = UD_SCREEN_HEIGHT;
        }
        else{
            self.top = UD_SCREEN_HEIGHT;
        }
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!value) {
                [self.photoArray removeAllObjects];
                [self.collectionView reloadData];
            }
        });
    }];
}

- (UIView *)creatTopView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UD_SCREEN_WIDTH, 47)];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 0, 100 , 47)];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setTitle:getUDAVSLocalizedString(@"uavs_common_cancel") forState:UIControlStateNormal];
    [leftButton setTitleColor:UIColorHex(#ADADADFF) forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftButton];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(UD_SCREEN_WIDTH - 100 - 16, 0, 100 , 47)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:getUDAVSLocalizedString(@"uavs_common_send") forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColorHex(#1A52A4FF) forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:rightButton];
    
    return view;
}

- (void)leftButtonPressed{
    
    [self show:NO];
}

- (void)rightButtonPressed{
    if (self.selectedIndex < 0 || self.selectedIndex > self.photoArray.count) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectImage:)]) {
        UIImage *image = [self.photoArray objectAtIndex:self.selectedIndex];
        PHAsset *asset = [image getAssociatedValueForKey:&assetKey];
        if (!assetKey) {
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeFast;
            // 同步获得图片, 只会返回1张图片
            options.synchronous = YES;
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                if (result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.delegate didSelectImage:result];
                    });
                }
            }];
        });
        
        ;
    }
    [self show:NO];
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
    
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
        
        _collectionView = collectionView;
        _collectionView.frame = CGRectMake(0, 47, UD_SCREEN_WIDTH, self.height - 47);
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (UD_SCREEN_WIDTH - 3)/4.0;
    w = floor(w);
    return CGSizeMake(w, w);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] init];
    }
    
    UIImageView *iv =  [cell viewWithTag:imageTag];
    if (!iv) {
        iv = [[UIImageView alloc] initWithFrame:CGRectZero];
        iv.tag = imageTag;
        [cell addSubview:iv];
        iv.frame = cell.bounds;
        iv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    UIImage *image = [self.photoArray objectAtIndex:indexPath.row];
    iv.image = image;
    
    UIImageView *selectImageView = [cell viewWithTag:selectImageTag];
    if (!selectImageView) {
        selectImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        selectImageView.image = [UIImage udavs_imageNamed:@"udSelected"];
        selectImageView.tag = selectImageTag;
        selectImageView.hidden = YES;
        selectImageView.contentMode = UIViewContentModeScaleAspectFit;
        selectImageView.size = CGSizeMake(22, 22);
        selectImageView.right = cell.width - 4;
        selectImageView.bottom = cell.height -4;
        selectImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [cell addSubview:selectImageView];
    }
    selectImageView.hidden = (indexPath.row != self.selectedIndex);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedIndex == indexPath.row) {
        return;
    }
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
}

- (BOOL)isShowing{
    return self.bottom == UD_SCREEN_HEIGHT;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
