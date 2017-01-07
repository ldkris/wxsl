//
//  SLAddTripPopleVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLAddTripPopleVC : BaseViewController
@property(nonatomic,retain)SLPassengerModel *mPassenger;
@property(nonatomic,retain) SLUserInfoModel *mUsermodel;
@property(nonatomic,copy)void (^backBlocl)(SLPassengerModel *mPassenger,SLPassengerModel *mNewPassenger);

-(void)backInfoBlock:(void (^)(SLPassengerModel *mPassenger,SLPassengerModel *mNewPassenger))block;
@end
