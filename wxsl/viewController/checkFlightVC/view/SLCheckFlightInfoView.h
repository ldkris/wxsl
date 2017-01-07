//
//  SLCheckFlightInfoView.h
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ENUM_ActionTypeTime=0,//起飞时间
    ENUM_ActionTypeAirport,//机场
    ENUM_ActionTypeFlyType,//机型
    ENUM_ActionTypeRBD,//舱位
    ENUM_ActionTypeAirline,//航空公司
   
} ENUM_ActionType;

@protocol SLCheckFlightInfoViewDelegate;
@interface SLCheckFlightInfoView : UIView
@property(nonatomic,assign)ENUM_ActionType ENUM_ActionType;
@property(nonatomic,assign)id<SLCheckFlightInfoViewDelegate>delegate;
-(void)dismissDialogView:(UIView *)view;


/**
 *  航司列表
 */
@property (nonatomic,copy   ) NSArray                  * mAirlines;
/**
 *  机场列表
 */
@property (nonatomic,copy   ) NSArray                  * mAirports;

-(void)show;
@end

@protocol SLCheckFlightInfoViewDelegate <NSObject>

-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view currentActionType:(ENUM_ActionType)type selctInfo:(NSString *)info selectIndex:(NSIndexPath*)index;

-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view onclickStopsBtn:(UIButton *)sender;

-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view onclickHideFightBtn:(UIButton *)sender;

@end