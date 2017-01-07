//
//  SLSelectAdressVC.h
//  wxsl
//
//  Created by 刘冬 on 16/7/23.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLSelectAdressVC : BaseViewController
@property(nonatomic,copy)void(^bloclk)(NSString *style,SLAddressModel *model);
-(void)backInfoBlock:(void (^)(NSString *style,SLAddressModel *model))block;
@end
