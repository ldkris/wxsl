//
//  SLSimpleInterest.h
//  wxsl
//
//  Created by 刘冬 on 16/8/12.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SLFlightTrackVC_TicketTrip_Air=0,//机票
    SLFlightTrackVC_TicketTrip_train,//火车
} ENUM_ViewController_TicketType;


@interface SLSimpleInterest : NSObject
@property(nonatomic,retain)NSString *asdasd;

+(SLSimpleInterest *)shareNetWork;
/**
 *  0因公 1因私
 */
@property(nonatomic,assign)NSInteger mTrType;

/**
 机票 /火车
 */
@property(nonatomic,assign)ENUM_ViewController_TicketType TicketType;

@end
