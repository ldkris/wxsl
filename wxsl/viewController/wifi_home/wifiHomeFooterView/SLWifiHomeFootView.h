//
//  SLWifiHomeFootView.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiHomeFootView : UICollectionReusableView
@property(copy,nonatomic)void(^onclickMoreBtn)(UIButton *sender);
-(void)SLWifiHomeFootViewOnclickMoreBtnBlock:(void(^)(UIButton *sender))block;
@end
