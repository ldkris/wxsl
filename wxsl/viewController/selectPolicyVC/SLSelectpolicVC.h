//
//  SLSelectpolicVC.h
//  wxsl
//
//  Created by 刘冬 on 16/7/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
#import "SLSelectPassengerVC.h"
@interface SLSelectpolicVC : BaseViewController

//已选择的乘客
@property(nonatomic,retain)NSMutableArray *mSelectedPassengers;



@property(nonatomic,retain)SLPassengerModel *mSeleledPolic;

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
/**
 *  违规列表
 */
@property(nonatomic,retain)NSArray *illegalReasonLists;
@end
