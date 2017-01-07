//
//  SLFlightTrackVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    SLFlightTrackVC_SingleTrip=0,//单程
    SLFlightTrackVC_RoundTrip,//往返
} ENUM_ViewController_TripType;

@interface SLFlightTrackVC : BaseViewController
/**
 单程 / 往返
 */
@property(nonatomic,assign)ENUM_ViewController_TripType TripType;
/**
 *  选择出发城市
 */
@property(nonatomic,retain)NSDictionary *mSelectFormCityDIC;
/**
 *  到达城市
 */
@property(nonatomic,retain)NSDictionary *mSelectToCityDIC;


@end
