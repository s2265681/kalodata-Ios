//
//  SplashView.m
//  kalodata3
//
//  Created by mac on 2024/6/17.
//

#import "SplashView.h"

@interface SplashView()

@property(nonatomic, strong, readwrite)UIButton *button;

@end

@implementation SplashView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.image = [UIImage imageNamed:@"icon.bundle/splash.png"];
//        [self addSubview:({
//            _button = [[UIButton alloc] initWithFrame:CGRectMake(300,100, 60, 60)];
//            _button.backgroundColor = [UIColor lightGrayColor];
//            [_button setTitle:@"跳过" forState:UIControlStateNormal];
//            [_button addTarget:self action:@selector(_removeSplashView) forControlEvents: UIControlEventTouchUpInside];
//            _button;
//        })];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark -
-(void)_removeSplashView{
    [self removeFromSuperview];
}

@end
