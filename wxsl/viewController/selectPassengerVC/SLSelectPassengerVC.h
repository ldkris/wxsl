//
//  SLSelectPassengerVC.h
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, PassengerType) {
    //以下是枚举成员
    common = 0,//常用
    yuangong = 1,//员工
};
@interface SLSelectPassengerVC : BaseViewController
@property(nonatomic,retain)NSMutableDictionary *mFlightInfoDIC;
@property(nonatomic,retain)SLCheckFightModel *fightMode;
@property(nonatomic,retain) SLRBDModel *mSelectRBDModel;

@property(nonatomic,retain)NSMutableDictionary *mBackFlightInfoDIC;
@property(nonatomic,retain) SLRBDModel *mQSelectRBDModel;

@property(nonatomic,assign) PassengerType PassengerType;

/**
 *  本人 / 他人
 */
@property(nonatomic,assign)SLPassengerTicketType QTicketType;
/**
 *  因共 / 因私
 */
@property(nonatomic,assign)SLPassengerReasonType QReasonType;
@end
