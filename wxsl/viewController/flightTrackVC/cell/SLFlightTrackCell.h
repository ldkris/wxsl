//
//  SLFlightTrackCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLFlightTrackCellDelegate;
@interface SLFlightTrackCell : UITableViewCell
@property(nonatomic,assign)id<SLFlightTrackCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *btn_backTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_formTime;

@property (weak, nonatomic) IBOutlet UIButton *btn_formCity;
@property (weak, nonatomic) IBOutlet UIButton *btn_toCity;

-(void)loadCityInfo:(NSDictionary *)formCity toCity:(NSDictionary *)toCity;
@end
@protocol SLFlightTrackCellDelegate <NSObject>

-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickLookUpBtn:(UIButton *)sender;
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclikFromCityBtn:(UIButton *)sender;
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclicktoCityBtn:(UIButton *)sender;
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickfromTimeBtn:(UIButton *)sender;
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickToTimeBtn:(UIButton *)sender;
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickChangeBtn:(UIButton *)sender;

@end