//
//  SLCommonPassengerVC.h
//  wxsl
//
//  Created by 刘冬 on 16/7/20.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLCommonPassengerVC : BaseViewController
@property(nonatomic,retain)NSArray *mOderDataSoure;
@property(nonatomic,copy)void(^ backInfo)(NSDictionary *info);
-(void)backInfoBlock:(void(^)(NSDictionary *info))block;
@end
