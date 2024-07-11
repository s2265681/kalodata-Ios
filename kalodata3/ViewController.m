//
//  ViewController.m
//  kalodata2
//
//  Created by mac on 2024/6/12.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "IAPManager.h"

@interface ViewController ()<WKNavigationDelegate, WKScriptMessageHandler>
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
        
        // 禁用边缘滑动手势
        self.webView.allowsBackForwardNavigationGestures = NO;
        
        // 创建 webview 的 config      // 设置偏好设置
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        // 1、 注入JS对象名称AppModel，当JS通过AppModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
        [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
        
        WKUserContentController *userCC = config.userContentController;
        
        
        NSString *jsString = [NSString stringWithFormat:@"window.__iosApp__ = true; window.__iosCookie__ = %@", self.mycookies];
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        // 将自定义JS加入到配置里
        [userCC addUserScript:noneSelectScript];
        
        
        // 创建设置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
        preference.minimumFontSize = 0;
        //设置是否支持javaScript 默认是支持的
        preference.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
        preference.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preference;
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        config.allowsInlineMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        
        // 导航代理
        self.webView.navigationDelegate = self;
        
        //#创建WKWebView
        // 通过唯一的默认构造器来创建对象
        self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
        
        // NEW
        [self.view addSubview:self.webView];
        
        // 加载一个网页
        NSURL *url = [NSURL URLWithString:@"https://m.kalodata.com"];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        
        
        self.webView;
    })];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"完成加载");
};

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
};

// 3、实现WKScriptMessageHandler协议方法  实现 h5 发送消息调用 native 的方法
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        // 假设message.body是一个字符串，首先将其转换为NSDictionary
          NSDictionary *messageData = [NSJSONSerialization JSONObjectWithData:[((NSString *)message.body) dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
       
        // 现在你可以访问param1和param2了
           NSString *message = messageData[@"message"];
         
        // h5 调用native 购买的方法
        if ([message isKindOfClass:[NSString class]] && [message isEqualToString:@"handleBuy"]) {
                NSString *productId = messageData[@"productId"];
                NSLog(@"Buy");
                [self buyClickWithProductID:productId];
        }
        
        NSLog(@"message: %@",message);
    }
}

// native 调用 h5 的方法
- (void)channelMessage:(NSString *)event {
    NSString *jsCode = [NSString stringWithFormat:@"channelMessage('%@')", event];
    [self.webView evaluateJavaScript: jsCode completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error calling JavaScript: %@", error.localizedDescription);
        } else {
            if ([response isEqualToString:@"sucess"]) {
                NSLog(@"方法执行成功");
            }
        }
    }];
};


// h5发起购买
- (void)buyClickWithProductID:(NSString *)productID {
    [[IAPManager shareIAPManager] startPurchaseWithID:productID completeHandle:^(IAPPurchType type, NSData * _Nullable data) {
        switch (type) {
            case IAPPurchSuccess:
                NSLog(@"购买成功");
                // 处理购买成功的逻辑
//                [self handlePageDone];
                [self channelMessage:@"buysuccess"];
                break;
            case IAPPurchFailed:
                NSLog(@"购买失败");
                // 处理购买失败的逻辑
                break;
            case IAPPurchCancel:
                NSLog(@"取消购买");
                // 处理取消购买的逻辑
                break;
            case IAPPurchVerFailed:
                NSLog(@"订单校验失败");
                // 处理订单校验失败的逻辑
                break;
            case IAPPurchVerSuccess:
                NSLog(@"订单校验成功");
                // 处理订单校验成功的逻辑
                break;
            case IAPPurchNotArrow:
                NSLog(@"不允许内购");
                // 处理不允许内购的逻辑
                break;
            default:
                break;
        }
    }];
}


@end

