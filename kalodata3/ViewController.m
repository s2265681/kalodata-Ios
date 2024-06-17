//
//  ViewController.m
//  kalodata2
//
//  Created by mac on 2024/6/12.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()<WKNavigationDelegate>
@property(nonatomic,strong,readwrite) WKWebView *webView;

@property(nonatomic,strong,readwrite) NSString *mycookies;

// 新增UIprogressview
@property(nonatomic,strong,readwrite) UIProgressView *progressView;
@end

@implementation ViewController


// 移除监听
- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    

    [self.view addSubview:({
        // 导航代理
        self.webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级
        self.webView.allowsBackForwardNavigationGestures = YES;
        
        // 创建 webview 的 config      // 设置偏好设置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // web内容处理池，由于没有属性可以设置，也没有方法可以调用，不用手动创建
        config.processPool = [[WKProcessPool alloc] init];
        
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
        // 我们可以在WKScriptMessageHandler代理中接收到
        [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
         
        WKUserContentController *userCC = config.userContentController;
        // 原生调用 JS 方法
        // [webView evaluateJavaScript:@"showAlert('一个弹框')" completionHandler:^(id item, NSError * _Nullable error) { }];
        // 注入 JS 方法
//        NSString *jsString = @"function addIosWebviewTag() { window.__iosApp__ = true;} ";
//        NSString *jsString = @"window.__iosApp__ = true;window.mycookie =11";
        
        NSString *jsString = [NSString stringWithFormat:@"window.__iosApp__ = true; window.__iosCookie__ = %@", self.mycookies];
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        // 将自定义JS加入到配置里
        [userCC addUserScript:noneSelectScript];

        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//         WeakWebViewScriptMessageDelegate *delegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
//        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
//        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
//        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
//        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
//        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
         config.requiresUserActionForMediaPlayback = YES;
//        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
//        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        
        //#创建WKWebView
        // 通过唯一的默认构造器来创建对象
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
        
        // NEW
        [self.view addSubview:self.webView];
//        //#加载H5页面
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
//        // 导航代理
        self.webView.navigationDelegate = self;
//        // 与webview UI交互代理
        self.webView.UIDelegate = self;
        // 添加KVO监听
        [self.webView addObserver:self
                     forKeyPath:@"loading"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        //添加监测网页标题title的观察者
        [self.webView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        //添加监测网页加载进度的观察者
        [self.webView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        
        
        // 添加手势识别器
        [self addSwipeGestureToWebView];
        
        self.webView;
    })];

    // 加载url
    // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.kalodata.com"]]
//       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.31.133:5500/kalodata2/index.html"]]
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.kalodata.com/"]]
//       [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.31.133:10086"]]
       
    ];
    
 
    // 进度条 UI 展示
//        [self.view addSubview:({
//            self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 5)];
//            self.progressView;
//        })];
}

// 手势识别
- (void)addSwipeGestureToWebView {
    UIScreenEdgePanGestureRecognizer *swipeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    swipeGesture.edges = UIRectEdgeLeft;
    [self.webView addGestureRecognizer:swipeGesture];
}

// 左滑webview 返回
- (void)handleSwipeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"完成加载");
    
    // 读取数据
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *sessionValue = [defaults objectForKey:@"sessionKey"];
//    NSLog(@"sessionValue: %@", sessionValue);
    
    //调用 JS 函数 NaturalKeyQuery()
    // 每次页面完成都弹出来，大家可以在测试时再打开
//      NSString *js = @"haveDone()"; // 调用js的方法，注入 window.__app__ = true
//        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//          NSLog(@"response: %@ error: %@", response, error);
//          NSLog(@"call js alert by native");
//        }];
};

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
};

// 监听进度
- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    NSLog(@"");
    // 监听进度
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
            //网页加载进度
            //把值设置到进度条上
      
            self.progressView.progress = self.webView.estimatedProgress;
            if (self.webView.estimatedProgress >= 1.0f) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.progressView removeFromSuperview];
                    self.progressView = nil;
                });
             }
        }else if([keyPath isEqualToString:@"title"] && object == self.webView){
            self.navigationItem.title = self.webView.title;
        }
}


#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
  if ([message.name isEqualToString:@"AppModel"]) {
    // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
    // NSDictionary, and NSNull类型
    NSLog(@"%@", message.body);
//      self.mycookies = message.body;
      // 永久存储数据
//      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//      [defaults setObject:@"sessionValue" forKey:@"sessionKey"];
//      [defaults synchronize];
  }
}

 
// 在JS端调用alert函数时，会触发此代理方法。
// JS端调用alert时所传的数据可以通过message拿到
// 在原生得到结果后，需要回调JS，是通过completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
  NSLog(@"%s", __FUNCTION__);
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    completionHandler();
  }]];
  
  [self presentViewController:alert animated:YES completion:NULL];
  NSLog(@"%@", message);
}


#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
     NSLog(@"%s", __FUNCTION__);
}
 
// JS端调用confirm函数时，会触发此方法
// 通过message可以拿到JS端所传的数据
// 在iOS端显示原生alert得到YES/NO后
// 通过completionHandler回调给JS端
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//  NSLog(@"%s", __FUNCTION__);
//  
//  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
//  [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    completionHandler(YES);
//  }]];
//  [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//    completionHandler(NO);
//  }]];
//  [self presentViewController:alert animated:YES completion:NULL];
//  
//  NSLog(@"%@", message);
//}
 
// JS端调用prompt函数时，会触发此方法
// 要求输入一段文本
// 在原生输入得到文本内容后，通过completionHandler回调给JS
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
//  NSLog(@"%s", __FUNCTION__);
//  
//  NSLog(@"%@", prompt);
//  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
//  [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//    textField.textColor = [UIColor redColor];
//  }];
//  
//  [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    completionHandler([[alert.textFields lastObject] text]);
//  }]];
//  [self presentViewController:alert animated:YES completion:NULL];
//}

@end

