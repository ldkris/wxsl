//
//  SLWifiGetPalceVC.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLWifiGetPalceVC : BaseViewController
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)void(^backData)(NSDictionary *selectAirPort);
-(void)backDataBlock:(void (^)(NSDictionary *selectDic))block;
@end
