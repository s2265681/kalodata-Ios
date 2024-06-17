//
//  StyleViewController.m
//  kalodata3
//
//  Created by mac on 2024/6/16.
//

#import "StyleViewController.h"

@interface StyleViewController ()

@end

@implementation StyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建UIImageView
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yourImageName"]];
      imageView.contentMode = UIViewContentModeScaleAspectFit;
      imageView.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:imageView];
      
      // 创建UILabel
      UILabel *label = [[UILabel alloc] init];
      label.text = @"123";
      label.textAlignment = NSTextAlignmentCenter;
      label.translatesAutoresizingMaskIntoConstraints = NO;
      [self.view addSubview:label];
      
      // 设置Auto Layout约束
      [NSLayoutConstraint activateConstraints:@[
          // 将imageView水平居中
          [imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
          // 将imageView垂直居中
          [imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-20], // 向上偏移，为label留出空间
          // 设置imageView的宽度和高度
          [imageView.widthAnchor constraintEqualToConstant:100],
          [imageView.heightAnchor constraintEqualToConstant:100],
          
          // 将label水平居中
          [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
          // 将label放置在imageView的下方
          [label.topAnchor constraintEqualToAnchor:imageView.bottomAnchor constant:20],
          // 设置label的宽度
          [label.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
          // 设置label的高度
          [label.heightAnchor constraintEqualToConstant:20]
      ]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
