//
//  SLTripPipleVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLTripPipleVC : BaseViewController
@property(nonatomic,copy) void(^backBlock)(NSMutableArray *info);
@property(nonatomic,assign)BOOL isSelect;
-(void)backPopleInfo:(void(^)(NSMutableArray *infoDic))block;
@end
