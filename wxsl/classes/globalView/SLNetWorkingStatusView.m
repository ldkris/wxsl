//
//  SLNetWorkingStatusView.m
//  wxsl
//
//  Created by 刘冬 on 16/8/24.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLNetWorkingStatusView.h"

#define CC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CC_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation SLNetWorkingStatusView
+ (instancetype)shareSheet{
    static id shareSheet;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSheet = [[[self class] alloc] init];
        
    });
    return shareSheet;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self initSheetWindow];
    }
    return self;
}
#pragma mark init
- (void)initSheetWindow{
    _sheetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CC_SCREEN_WIDTH, CC_SCREEN_HEIGHT)];
    _sheetWindow.windowLevel = UIWindowLevelStatusBar;
    _sheetWindow.backgroundColor = [UIColor clearColor];
    
    _sheetWindow.hidden = NO;
    
    //zhezhao
    _backView = [[UIView alloc] initWithFrame:_sheetWindow.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.5;
    [_sheetWindow addSubview:_backView];
    
    _contView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, CC_SCREEN_WIDTH -80, 80)];
    [_contView setCenter:_backView.center];
    [_contView.layer setMasksToBounds:YES];
    [_contView.layer setCornerRadius:5.0];
    _contView.backgroundColor = [UIColor whiteColor];
    _contView.alpha = 1.0f;
    [_sheetWindow addSubview:_contView];
    
    _contImgView = [[UIImageView alloc]init];
    [_contImgView setFrame:CGRectMake(0, 20, 20, 20)];
    [_contImgView.layer addAnimation:[self moveX:1.5f X:[NSNumber numberWithFloat:CC_SCREEN_WIDTH - 100]] forKey:nil];
    [_contImgView setImage:[UIImage imageNamed:@"air_icon1"]];
    _contImgView.alpha = 1.0f;
    [_contView addSubview:_contImgView];
    
    _contLable = [[UILabel alloc]init];
    [_contLable setFrame:CGRectMake((CC_SCREEN_WIDTH -80) /2 - 40, 45, 200, 20)];
    [_contLable setText:@"加载中......"];
    [_contLable setTextColor:[UIColor blackColor]];
    [_contView addSubview:_contLable];
    
    
}
#pragma mark =====横向、纵向移动===========
-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
     [self tempDismiss];
}
-(void)tempshow{
    if (_sheetWindow == nil) {
        [self initSheetWindow];
    }
    _sheetWindow.hidden = NO;
    _backView.alpha = 0.5;
    _contView.alpha = 1.0;
}
-(void)tempDismiss{
    _sheetWindow.hidden = YES;
    _sheetWindow = nil;
    _backView.alpha = 0.0;
    _contView.alpha = 0.0;
}
+(void)show{
    [[self shareSheet] tempshow];
}
+(void)dismiss{
    [[self shareSheet] tempDismiss];
}
@end
