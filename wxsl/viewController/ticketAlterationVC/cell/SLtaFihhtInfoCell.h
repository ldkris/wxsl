//
//  SLtaFihhtInfoCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLtaFihhtInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_flightLogo;
@property (weak, nonatomic) IBOutlet UILabel *mLb_fightInfo;
@property (weak, nonatomic) IBOutlet UILabel *mlb_formTime;
@property (weak, nonatomic) IBOutlet UILabel *mlb_toTime;
@property (weak, nonatomic) IBOutlet UILabel *mlb_contentTime;
@property (weak, nonatomic) IBOutlet UILabel *mlb_goStyle;
@property (weak, nonatomic) IBOutlet UILabel *mlb_numOfPople;
@property (weak, nonatomic) IBOutlet UILabel *mLB_FormAirPort;
@property (weak, nonatomic) IBOutlet UILabel *mLB_ArrAirPort;

@property (weak, nonatomic) IBOutlet UILabel *mlb_price;

-(void)loadCellInfoWithModel:(SLOrderModel *)order withDetalModel:(SLOrderDetialModel *)DetialModel;
@end
