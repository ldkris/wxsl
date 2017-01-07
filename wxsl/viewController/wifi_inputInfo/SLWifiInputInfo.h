//
//  SLWifiInputInfo.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/13.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLWifiInputInfo : BaseViewController
@property(nonatomic,retain)void(^backData)(NSString *str);
-(void)backDataBlock:(void (^)(NSString *str))block;
@end
