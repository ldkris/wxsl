//
//  SLTTFilterView.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLTTFilterViewDelegate ;
typedef enum {
    ENUM_TT_ActionTypeTime=0,//起飞时间
    ENUM_TT_ActionTypeAirport,//机场
    ENUM_TT_ActionTypeFlyType,//机型
    ENUM_TT_ActionTypeRBD,//舱位
    ENUM_TT_ActionTypeAirline,//航空公司
    
} ENUM_tt_ActionType;
@interface SLTTFilterView : UIView
@property(nonatomic,assign)ENUM_tt_ActionType ENUM_ActionType;
@property(nonatomic,assign)id<SLTTFilterViewDelegate>delegate;
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
@protocol SLTTFilterViewDelegate <NSObject>

-(void)SLTTFilterView:(SLTTFilterView *)view currentActionType:(ENUM_tt_ActionType)type selctInfo:(NSString *)info selectIndex:(NSIndexPath*)index;

-(void)SLTTFilterView:(SLTTFilterView *)view onclickStopsBtn:(UIButton *)sender;

-(void)SLTTFilterView:(SLTTFilterView *)view onclickHideFightBtn:(UIButton *)sender;

@end
