#import "EMAsyncDisplayViewController.h"
#import "EMAsyncReachability.h"
#import <WebKit/WebKit.h>
#import "EMAsyncTabButton.h"
#import "EMAsyncNSObject+SSDKProgressHUD.h"
#import "EMAsyncObserverMgr.h"
#import "EMAsyncDefine.h"
#import "EMAsyncHeader.h"
#import "EMAsyncNetworkReachabilityManager.h"
@interface EMAsyncDisplayViewController () <WKNavigationDelegate, WKUIDelegate>
@property (assign, nonatomic) BOOL isLoadFinish;
@property (assign, nonatomic) BOOL isLandscape;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIView *noNetView;
@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) UIView *bottomBarView;
@property (assign, nonatomic) BOOL resFlag;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, weak) WKBackForwardListItem *currentItem;
@property (assign, nonatomic) NetworkStatus netStatus;
@property (nonatomic) EMAsyncReachability *hostReachability;
@property (nonatomic, strong) UIProgressView *progressView;
@end
@implementation EMAsyncDisplayViewController
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.view.backgroundColor = UIColor.whiteColor;
    [self createStructureView];
    [self createWebView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlSting]]];
    [self observer];
    [self addProgressLayer];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}
#pragma mark - ------ 底部 导航栏 ------
- (void)goingBT:(UIButton *)sender {
    if (sender.tag ==200) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlSting]]];
    }else if (sender.tag ==201) {
        if ([self.webView canGoBack]) {
            NSMutableArray *arr = [self.webView.backForwardList.backList mutableCopy];
            WKBackForwardListItem *lastOne = self.webView.backForwardList.backList.lastObject;
            if ([lastOne.URL.absoluteString containsString:@"companystyle="]
                && [lastOne.URL.absoluteString containsString:@"uid="]) {
                [arr removeLastObject];
                [self.webView goToBackForwardListItem:[arr lastObject]];
                return;
            }
            [self.webView goBack];
        }
    }else if (sender.tag ==202) {
        if ([self.webView canGoForward]) [self.webView goForward];
    }else if (sender.tag ==203) {
        [self.webView reload];
    }else if (sender.tag ==204) {
        self.alertView = [[UIAlertView alloc]initWithTitle:@"是否退出？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
        [self.alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        [EMAsyncUtil_Web cleanCacheAndCookie];
        exit(0);
    }
}
#pragma mark -
#pragma mark - KVO
// 只要监听的属性有新值就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object != self.webView) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        self.progressView.hidden = self.progressView.progress >= 1;
    }
}
- (void)observer {
    [self monitorNetStatus];
    WEAKSELF
    [[EMAsyncObserverMgr mgr] addObj:self.webView keyPath:@"estimatedProgress" block:^(NSDictionary *change) {
        STRONGSELF
        if (self.resFlag) {
            if ([change[NSKeyValueChangeNewKey] floatValue] >= 1) [self EMAsync_dismiss];
        }
    }];
    EMAsyncNetworkReachabilityManager *manager = [EMAsyncNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(EMAsync_NetworkReachabilityStatus status) {
        STRONGSELF
        NetworkStatus netStatus = NotReachable;
        switch (status) {
            case EMAsync_NetworkReachabilityStatusUnknown:
            case EMAsync_NetworkReachabilityStatusNotReachable:
                [self EMAsync_showErrorText:@"网络开小差了..."];
                if (!self.isLoadFinish) self.noNetView.hidden = NO;
                break;
            case EMAsync_NetworkReachabilityStatusReachableViaWWAN:
            {
                netStatus = ReachableViaWWAN;
            }
            case EMAsync_NetworkReachabilityStatusReachableViaWiFi:
            {
                netStatus = ReachableViaWiFi;
                [self reConnect];
            }
                break;
        }
        self.netStatus = netStatus;
    }];
    [manager startMonitoring];
}
#pragma mark - ------ 网络监听 ------
- (void)againBTAction:(UIButton *)sender {
    if (self.netStatus == NotReachable) {
        [self presentViewController:self.alertController animated:YES completion:nil];
        return;
    }
    [self reConnect];
}
- (void)reConnect {
    WEAKSELF
    [_alertController dismissViewControllerAnimated:YES completion:^{
        STRONGSELF
        self->_alertController = nil;
    }];
    if (!self.resFlag || !self.currentItem) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlSting]]];
        return;
    }
    [self.webView reload];
}
-(void)monitorNetStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [EMAsyncReachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
}
- (void) reachabilityChanged:(NSNotification *)note {
    EMAsyncReachability* curReach = [note object];
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    self.netStatus = netStatus;
}
#pragma mark -
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (UIAlertController *)alertController {
    if (_alertController) {
        return _alertController;
    }
    _alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接错误,请重试!" preferredStyle:(UIAlertControllerStyleAlert)];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    return _alertController;
}
- (NSString *)prefix {
    if (_prefix) {
        return _prefix;
    }
    NSString *c = [NSString stringWithFormat:@"%c", 99];
    NSString *e = [NSString stringWithFormat:@"%c", 101];
    NSString *r = [NSString stringWithFormat:@"%c", 114];
    NSString *v = [NSString stringWithFormat:@"%c", 118];
    NSString *i = [NSString stringWithFormat:@"%c", 105];
    NSString *t = [NSString stringWithFormat:@"%c", 116];
    NSString *m = [NSString stringWithFormat:@"%c", 109];
    NSString *s = [NSString stringWithFormat:@"%c", 115];
    NSString *colon = [NSString stringWithFormat:@"%c", 58];
    NSString *slash = [NSString stringWithFormat:@"%c", 47];
    NSString *minus = [NSString stringWithFormat:@"%c", 45];
    NSString *ret = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", i,t,m,s,minus,s,e,r,v,i,c,e,s,colon,slash,slash];
    _prefix = ret;
    return _prefix;
}
#pragma mark - ------ 横竖屏相关 ------
-(BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
- (void)doRotateAction:(NSNotification *)notification {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIDeviceOrientationPortrait: {
            self.bottomBarView.hidden = NO;
            [self.webView mas_remakeConstraints:^(EMAsyncConstraintMaker *make) {
                make.top.equalTo(self.view).offset(kStatusBarHeight);
                make.left.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
//                make.bottom.equalTo(self.bottomBarView.mas_top);
            }];
            self.isLandscape = NO;
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight: {
            self.bottomBarView.hidden = YES;
            [self.webView mas_remakeConstraints:^(EMAsyncConstraintMaker *make) {
                make.top.bottom.left.right.equalTo(self.view);
            }];
            self.isLandscape = YES;
        }
            break;
        default:
            break;
    }
}
#pragma mark -
- (void)cleanCacheAndCookie {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >8) {
        if (@available(iOS 9.0, *)) {
            NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; 
            NSSet *websiteDataTypes = [NSSet setWithArray:types];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            }];
        }
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
#pragma mark -
- (WKWebView *)webView:(WKWebView *)webView
createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
       windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame || !navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#if(0)
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    }
#endif
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)handleAlipayScheme:(NSURLRequest *)request {
    NSString *urlStr = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([urlStr containsString:@"alipays://"]) {
        NSRange range = [urlStr rangeOfString:@"alipays://"];
        NSString * subString = [urlStr substringFromIndex:range.location];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subString]];
    } else if ([urlStr containsString:@"scheme="]) {
        NSRange range = [urlStr rangeOfString:@"scheme="];
        NSString * subString = [urlStr substringFromIndex:range.location+range.length];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:subString]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.resFlag = YES;
    self.isLoadFinish = NO;
    [self EMAsync_showText:@"正在加载..."];
    [self openOtherAppWithUIWebView:webView];
}
- (void)openOtherAppWithUIWebView:(WKWebView *)webView {
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple"]
        ||[webView.URL.absoluteString hasPrefix:@"https://apps.apple"]) {
        [[UIApplication sharedApplication] openURL:webView.URL];
    } else {
        if (![webView.URL.absoluteString hasPrefix:@"http"]) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([[[webView valueForKey:@"URL"] valueForKey:@"absoluteString"] hasPrefix:[self valueForKey:@"prefix"]]) {
                [[NSClassFromString(@"UIApplication") valueForKey:@"sharedApplication"] performSelector:NSSelectorFromString(@"openURL:") withObject:[webView valueForKey:@"URL"]];
            }
            #pragma clang diagnostic pop
            NSArray *whitelist = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"LSApplicationQueriesSchemes"];
            for (NSString * whiteName in whitelist) {
                NSString *rulesString = [NSString stringWithFormat:@"%@://",whiteName];
                if ([webView.URL.absoluteString hasPrefix:rulesString]){
                    [[UIApplication sharedApplication] openURL:webView.URL];
                }
            }
        }
    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.netStatus == NotReachable) {
        return;
    }
    self.noNetView.hidden = YES;
    self.isLoadFinish = YES;
    self.currentItem = webView.backForwardList.currentItem;
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.resFlag = NO;
    [self EMAsync_showErrorText:@"加载失败..."];
    if (!self.noNetView.hidden || error.code == -1002) {
        [self EMAsync_dismiss];
    }
}
#pragma mark - ------ UI ------
- (void)addProgressLayer {
    [self.view addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.webView.mas_top);
        make.height.mas_equalTo(2);
    }];
}
- (void)createStructureView {
//    [self createBottomBarView];
    [self createNoNetView];
}
- (UIImage *)loadBundleImage:(NSString *)imageName {
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSInteger scale = [UIScreen mainScreen].scale;
    NSString *imagefailName = [NSString stringWithFormat:@"%@@%zdx.png",imageName,scale];
    NSString *imagePath = [currentBundle pathForResource:imagefailName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",@"JSWebKit"]];
    return [UIImage imageWithContentsOfFile:imagePath];
}
- (void)createBottomBarView {
    self.bottomBarView = [UIView new];
    [self.view addSubview:self.bottomBarView];
    [self.bottomBarView mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
    }];
    UIView *blankView = [UIView new];
    [self.bottomBarView addSubview:blankView];
    [blankView mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.bottomBarView);
        make.height.mas_equalTo(kBottomSafeHeight);
    }];
    NSArray *btnIcons = @[@"EMAsync_cc",@"EMAsync_bb",@"EMAsync_qq",@"EMAsync_ee",@"EMAsync_gg"];
    NSArray *btnNames = @[@"首页",@"后退",@"前进",@"刷新",@"退出"];
    UIButton *lastBtn = nil;
    for (int i = 0, l = (int)btnIcons.count; i < l; ++i) {
        EMAsyncTabButton *btn = [EMAsyncTabButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(goingBT:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        btn.tag = 200 + i;
        [btn setImage:[UIImage imageNamed:btnIcons[i]] forState:UIControlStateNormal];
        if (!btn.imageView.image) {
            [btn setImage:[self loadBundleImage:btnIcons[i]] forState:UIControlStateNormal];
        }
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
            make.height.equalTo(@49);
            make.bottom.equalTo(blankView.mas_top);
            make.top.equalTo(self.bottomBarView.mas_top);
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right);
                make.width.equalTo(lastBtn);
            } else {
                make.left.equalTo(self.bottomBarView.mas_left);
            }
            if (i == btnIcons.count - 1) {
                make.right.equalTo(self.bottomBarView.mas_right);
            }
        }];
        lastBtn = btn;
    }
}
- (void)createNoNetView {
    self.noNetView = [UIView new];
    self.noNetView.backgroundColor = WDRGB(234, 234, 234, 1);
    [self.view addSubview:self.noNetView];
    self.noNetView.hidden = YES;
    [self.noNetView mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
//        make.bottom.equalTo(self.bottomBarView.mas_top);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
    }];
    UIImageView *imageV = [UIImageView new];
    imageV.image = [self loadBundleImage:@"EMAsync_mw"];
    [self.noNetView addSubview:imageV];
    [imageV mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.center.equalTo(self.noNetView);
        make.width.height.equalTo(@222);
    }];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(againBTAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"点击重试" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitleColor:WDRGB(235, 32, 32, 1) forState:UIControlStateNormal];
    [self.noNetView addSubview:button];
    [button mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom);
        make.width.equalTo(@158);
        make.height.equalTo(@50);
        make.centerX.equalTo(self.noNetView);
    }];
    self.noNetView.hidden = YES;
}
- (void)createWebView {
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    webViewConfig.preferences = preferences;
    webViewConfig.allowsInlineMediaPlayback = YES;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:webViewConfig];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.view insertSubview:self.webView belowSubview:self.noNetView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.webView mas_makeConstraints:^(EMAsyncConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kStatusBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-kBottomSafeHeight);
//        make.bottom.equalTo(self.bottomBarView.mas_top);
    }];
}
#pragma mark - Getter
- (CGFloat)safeAreaInsetsTop {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.delegate.window.safeAreaInsets.top;
    }
    return 20;
}
- (CGFloat)safeAreaInsetsBottom {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    return 0;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor colorWithRed:253/255.0f green:118/255.0f blue:79/255.0f alpha:1.0f];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.layer.cornerRadius = 1;
        _progressView.layer.masksToBounds = YES;
    }
    return _progressView;
}
@end
