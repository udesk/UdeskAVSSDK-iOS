//
//  CommonViewController.m
//  selfVide
//
//  Created by zhangshuangyi on 2020/5/18.
//  Copyright © 2020 wkb. All rights reserved.
//

#import "CommonViewController.h"
#import <WebKit/WebKit.h>

// main screen's width (portrait)
#ifndef kScreenWidth
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#endif

// main screen's height (portrait)
#ifndef kScreenHeight
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

@interface CommonViewController ()<UITextFieldDelegate,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)WKWebView *webView;

@property (nonatomic, strong) UIProgressView *vProgressView;

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    self.webView.scrollView.delegate = self;
    
    
    self.vProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.vProgressView.backgroundColor = [UIColor blueColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.vProgressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.vProgressView];
    
    [self initNavTitle];

    NSString *url = self.url;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)initNavTitle{
    
    [self setBackBtn];
    self.title = @"浏览器";
    
}

- (UIButton *)setRightBarButtonItem:(NSString *)title color:(UIColor *)color{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return button;
}

- (void)rightClick
{
    [self.webView reload];
}
-(void)setBackBtn
{
    
        UIButton *closbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        closbtn.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
        [closbtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [closbtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc] initWithCustomView:closbtn];
        
        self.navigationItem.leftBarButtonItem = leftBtn;
        
     
}



- (void)closeView
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}




#pragma mark - WKUIDelegate,WKNavigationDelegate

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}


 //开始加载
 - (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
     
     NSLog(@"开始加载网页");
     //开始加载网页时展示出progressView
     self.vProgressView.hidden = NO;
     //开始加载网页的时候将progressView的Height恢复为1.5倍
     self.vProgressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
     //防止progressView被网页挡住
     [self.view bringSubviewToFront:self.vProgressView];
 }
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
  
    
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.vProgressView.hidden = YES;
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"加载失败2");
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macos(10.11), ios(9.0))
{
    NSLog(@"重新加载");
    [self.webView reload];
}



- (WKWebView *)webView
{
    if(!_webView){
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback=true;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight - 88) configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return  _webView;
    
}


#pragma -mark 在监听方法中获取网页加载的进度 并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.vProgressView.progress = self.webView.estimatedProgress;
        if (self.vProgressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.vProgressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.vProgressView.hidden = YES;
                
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self cleanCacheAndCookie];
}

#pragma -mark 清除缓存和cookie
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    
    //清除cookies
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[sharedHTTPCookieStorage cookies]];
    for (id obj in cookieArray) {
        [sharedHTTPCookieStorage deleteCookie:obj];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


@end
