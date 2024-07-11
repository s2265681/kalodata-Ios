//
//  SceneDelegate.m
//  kalodata2
//
//  Created by mac on 2024/6/12.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import "SplashView.h"
#import "GTRecommendController.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    ViewController *launchVC = [[ViewController alloc] init];
    
    self.window.rootViewController    = launchVC;
    self.window.backgroundColor       = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 添加一个闪屏页面
    [self.window addSubview:({
        SplashView *splashView = [[SplashView alloc] initWithFrame: self.window.bounds];
        
        // 3秒后关闭这个页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 从父视图中移除闪屏页面
            [splashView removeFromSuperview];
        });
        
        splashView;
    })];
    
   
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    NSLog(@"场景已经断开连接");
// （注意，以后它可能被重新连接）
}
- (void)sceneDidBecomeActive:(UIScene *)scene {
    NSLog(@"已经从后台进入前台 ");
//（例如从应用切换器中选择场景）
}
- (void)sceneWillResignActive:(UIScene *)scene {
    NSLog(@"即将从前台进入后台");
//（例如通过切换器切换到另一个场景）
}
- (void)sceneWillEnterForeground:(UIScene *)scene {
    NSLog(@"即将从后台进入前台");
}
- (void)sceneDidEnterBackground:(UIScene *)scene {
    NSLog(@"已经从前台进入后台");
}

@end
