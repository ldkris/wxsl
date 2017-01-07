//
//  BaseViewController.m
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+Awesome.h"

@interface BaseViewController ()
@property(nonatomic,retain)UIButton *mBackNaviBtn;
@end

@implementation BaseViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.tabBarController.tabBar.hidden = YES;
  
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    //设置成绿色
    statusBarView.backgroundColor = SL_BULE;
    // 添加到 navigationBar 上
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    [self.navigationController.navigationBar setBackgroundColor:SL_BULE];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBarTintColor:SL_BULE];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:18], NSFontAttributeName, nil]];
    
    UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allTFResignFirstResponder)];
    mTap.delegate = (id)self;
    [self.view addGestureRecognizer:mTap];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    UIBarButtonItem *mLifeBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickLifeBtn:)];
    self.navigationItem.leftBarButtonItem = mLifeBtn;
    
    if (self.navigationController.viewControllers.count == 1) {
        return;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event response
-(void)onclickLifeBtn:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark private

#pragma mark public
/**
 *  收起所有键盘
 */
-(void)allTFResignFirstResponder{
    LDLOG(@"收起所有的键盘");
    for (id temp in self.view.subviews) {
        if ([temp isKindOfClass:[UITextField class]]) {
            UITextField *tempTF = (UITextField *)temp;
            [tempTF resignFirstResponder];
        }else{
            if([temp isKindOfClass:[UIView class]]){
                UIView *tempView = (UIView *)temp;
                if (tempView.subviews.count>0) {
                    for (id temp1 in tempView.subviews) {
                        if ([temp1 isKindOfClass:[UITextField class]]) {
                            UITextField *tempTF = (UITextField *)temp1;
                            [tempTF resignFirstResponder];
                        }
                    }
                }
            }
        }
    }
}
-(void)setNavBackBtnImageStr:(NSString *)imageStr{
   [self.mBackNaviBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.mBackNaviBtn];
}
#pragma mark
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
   // LDLOG(@"%@",NSStringFromClass([touch.view class]));
    if(touch.view  != self.view){
        return NO;
    }
    return YES;
}

#pragma mark  getter
-(UIButton *)mBackNaviBtn{
    if (_mBackNaviBtn == nil) {
        _mBackNaviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _mBackNaviBtn.frame=CGRectMake(0, 0, 44, 44);
        [_mBackNaviBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 32)];
        _mBackNaviBtn.backgroundColor=[UIColor clearColor];
    }
    return _mBackNaviBtn;
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
