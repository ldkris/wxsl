//
//  SLWifiDtailCell_one.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiDtailCell_one : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLab_oldPrice;
@property (weak, nonatomic) IBOutlet UILabel *mlb_city;
@property (weak, nonatomic) IBOutlet UILabel *mlb_price;
@property (weak, nonatomic) IBOutlet UILabel *mlb_deposit;
@property (weak, nonatomic) IBOutlet UILabel *mlb_wifiScope;
@property (weak, nonatomic) IBOutlet UILabel *mlb_days;
@property (weak, nonatomic) IBOutlet UIButton *mlb_needs;

-(void)loadCellInfoWithModel:(SLHotWifiDetial *)model;
@end
