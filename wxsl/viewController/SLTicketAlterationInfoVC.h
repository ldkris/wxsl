//
//  SLTicketAlterationInfoVC.h
//  wxsl
//
//  Created by 刘冬 on 16/8/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLTicketAlterationInfoVC : BaseViewController
-(void)backInfo:(void(^)(NSDictionary *info))block;
@property(nonatomic,copy)void (^backInfoBlock)(NSDictionary *info);
@end
