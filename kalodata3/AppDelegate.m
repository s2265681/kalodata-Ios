////
////  AppDelegate.m
////  kalodata2
////
////  Created by mac on 2024/6/12.
////
//
//#import "AppDelegate.h"
//#import "ViewController.h"
//
//@interface AppDelegate ()
//
//@end
//
//@implementation AppDelegate
//
//
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  
//    // 延迟加载主界面，模拟启动页显示时间延长
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//      // 加载主界面
//      // 这里可以跳转到您的应用主界面
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        UIStoryboard *launchScreenStoryboard = [UIStoryboard storyboardWithName:@"Launch Screen" bundle:nil];
//        UIViewController *initialViewController = [launchScreenStoryboard instantiateInitialViewController];
//        self.window.rootViewController = initialViewController;
//        [self.window makeKeyAndVisible];
//    });
//    return YES;
//}
//
//
//#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}
//
//
//- (void)viewDidLoad {
//    ViewController *controller = [[ViewController alloc] init];
//}
//
//
//@end




//#import "AppDelegate.h"
//#import "ViewController.h"
//#import "StyleViewController.h"
//
//@interface AppDelegate ()
//
///**  */
//@property (nonatomic, strong) UIWindow *styleWindow;
//
//@end
//
//@implementation AppDelegate
//
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    
//    // 创建主window
//    [self styleOne];
//    
//    // 创建引导页window
//    [self styleTwo];
//  
//    return YES;
//}
//
//
///**
// 主window
// */
//- (void)styleOne{
//    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = [[ViewController alloc] init];
//    [self.window makeKeyAndVisible];
//}
//
//
///**
// 引导页window
// */
//- (void)styleTwo{
//    
//    // 创建第二个window，遮挡住第一个window
//    // 引导页的操作到StyleViewController控制器里面做
//    self.styleWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.styleWindow.backgroundColor = [UIColor whiteColor];
//    self.styleWindow.rootViewController = [[StyleViewController alloc] init];
//    [self.styleWindow makeKeyAndVisible];
//
//    // 定时销毁
//    [self performSelector:@selector(cancelStyleWindow) withObject:nil afterDelay:5];
//}
//
//
///**
// 销毁引导页Window
// */
//- (void)cancelStyleWindow{
//    
//    [self.styleWindow resignKeyWindow];
//    self.styleWindow = nil;
//}
//
//
//@end

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

@end
