//
//  ViewController2.m
//  kalodata3
//
//  Created by mac on 2024/6/17.
//

#import "ViewController2.h"
#import "ViewController.h"


@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:({
        UILabel *label = [[UILabel alloc] init];
        label.text = @"hello world";
        [label sizeToFit];
        label.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        [label addGestureRecognizer:tapGesture];
        label.userInteractionEnabled = YES;
        label;
    })];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)labelTapped {
    NSLog(@"Label 被点击了！");
   ViewController *mainVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
   UIWindow *window = UIApplication.sharedApplication.delegate.window;
   window.rootViewController = mainVC;
   [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    // 在这里添加你点击 Label 后想要执行的代码
}
//
//
//- (IBAction)_removeSplashView:(id)sender {
//    ViewController *mainVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    UIWindow *window = UIApplication.sharedApplication.delegate.window;
//    window.rootViewController = mainVC;
//    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
//}

@end
