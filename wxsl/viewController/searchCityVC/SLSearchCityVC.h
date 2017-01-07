//
//  SLSearchCityVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
#import "SLSelectCityVC.h"

@interface SLSearchCityVC : BaseViewController
@property(nonatomic,retain)NSArray *mALLDataArray;

@property(nonatomic,assign)ENUM_SLSearchCityVC_Type Type;

@property(nonatomic,copy)void (^BackInfo)(NSDictionary *cityInfo);
-(void)bakcInfoBlock:(void (^)(NSDictionary *cityInfo))block;
@end
