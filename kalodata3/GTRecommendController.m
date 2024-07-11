
#import "GTRecommendController.h"
#import "IAPManager.h"

@interface GTRecommendController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation GTRecommendController

- (instancetype) init{
    self = [super init];
    if(self){
        self.tabBarItem.title = @"推荐";
        self.tabBarItem.image = [UIImage imageNamed:@"expore"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"expore-active"];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * 5, self.view.bounds.size.height);
    
    NSArray *colorArray = @[[UIColor redColor], [UIColor blueColor],[UIColor yellowColor],[UIColor lightGrayColor],[UIColor grayColor]];
    
    for (int i =0; i < 5; i++) {
        [scrollView addSubview:({
             UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(scrollView.bounds.size.width * i, 0, scrollView.bounds.size.width,scrollView.bounds.size.height)];
 
            
            // 创建一个新的 view 添加手势demo
            [view addSubview:({
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
                view.backgroundColor = [UIColor yellowColor];
                // 创建手势
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
                
                // 将手势的 delegate 设置为self
                tapGesture.delegate = self;
                
                // 添加到view
                [view addGestureRecognizer:tapGesture];
                view;
            })];
            
            
            view.backgroundColor = [colorArray objectAtIndex:i];
            view;
        })
       ];
    }
    // 是否有翻页效果
    scrollView.pagingEnabled = YES;
    // delegate
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 手势是否需要识别
    return YES;
};

- (void)viewClick{
    NSLog(@"点击view");
    [[IAPManager shareIAPManager] startPurchaseWithID:@"65036049110" completeHandle:^(IAPPurchType type, NSData * _Nullable data) {
        switch (type) {
            case IAPPurchSuccess:
                NSLog(@"购买成功");
                // 处理购买成功的逻辑
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

//// 假设这是一个按钮点击事件处理器
//- (IBAction)purchaseButtonTapped:(id)sender {
//   
//}

// 开始滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll - %@",@(scrollView.contentOffset.x));
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"开始拖拽");
};

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"结束拖拽");
};

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"开始滚动");
};

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"结束滚动");
};

@end
