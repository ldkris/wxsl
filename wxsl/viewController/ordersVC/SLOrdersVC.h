//
//  SLOrdersVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, mOrderType) {
    M_UNUSEORDER = 0,//未出行订单
    M_ALLORDER,//所有订单
    M_SHENHE
};


@interface SLOrdersVC : BaseViewController
@property(nonatomic,assign)mOrderType mOrderType;

@end
