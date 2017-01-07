//
//  SLCheckFlightResultVC.h
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLCheckFlightResultVC : BaseViewController

@property(nonatomic,retain)SLPassengerModel *mSeleledPolic;
@property(nonatomic,retain)NSMutableDictionary *mFlightInfoDIC;
@property(nonatomic,retain)SLCheckFightModel *fightMode;

@property(nonatomic,retain)NSMutableDictionary *mBackFlightInfoDIC;
@property(nonatomic,retain)SLCheckFightModel *mBackFightMode;

@property(nonatomic,retain) SLRBDModel *mQSelectRBDModel;

/**
 *  本人 / 他人
 */
@property(nonatomic,assign)SLPassengerTicketType QTicketType;
/**
 *  因共 / 因私
 */
@property(nonatomic,assign)SLPassengerReasonType QReasonType;

/**
 *  是否违规
 */
@property(nonatomic,assign)BOOL isViolation;
//已选择的乘客
@property(nonatomic,retain)NSMutableArray *mSelectedPassengers;

@property(nonatomic,retain)NSArray *illegalReasonLists;
@end
