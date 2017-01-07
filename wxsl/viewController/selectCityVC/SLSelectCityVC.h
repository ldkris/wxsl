//
//  SLSelectCityVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    SLSearchCityVC_Form=0,//出发
    SLSearchCityVC_TO,//到达
}ENUM_SLSearchCityVC_Type;

@interface SLSelectCityVC : BaseViewController
@property(nonatomic,assign)ENUM_SLSearchCityVC_Type Type;

@property(nonatomic,copy)void (^BackInfo)(NSDictionary *cityInfo);
-(void)bakcInfoBlock:(void (^)(NSDictionary *cityInfo))block;
@end
