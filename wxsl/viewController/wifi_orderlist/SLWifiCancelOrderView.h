//
//  SLWifiCancelOrderView.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiCancelOrderView : UIView
@property(nonatomic,retain)NSString *num;

@property(copy,nonatomic)void(^onclickJiaBtnBlock)(UIButton *sender);
@property(copy,nonatomic)void(^onclickJianBtnBlock)(UIButton *sender);
@property(copy,nonatomic)void(^onclickComfirBtnBlock)(UIButton *sender);
-(void)onclickJiaBtnBlock:(void (^)(UIButton *sender))block;
-(void)onclickJianBtnBlock:(void (^)(UIButton *sender))block;
-(void)onclickComfirBtnBlock:(void (^)(UIButton *sender))block;
@end
