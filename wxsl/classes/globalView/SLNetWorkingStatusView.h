//
//  SLNetWorkingStatusView.h
//  wxsl
//
//  Created by 刘冬 on 16/8/24.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLNetWorkingStatusView : UIView
+ (instancetype)shareSheet;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contView;
@property (nonatomic, strong) UILabel *contLable;
@property (nonatomic, strong) UIImageView *contImgView;

@property (nonatomic, strong) UIWindow *sheetWindow;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

+(void)show;
+(void)dismiss;
@end
