//
//  SLWifiGetPalceCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiGetPalceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlb_time;
@property (weak, nonatomic) IBOutlet UILabel *mlb_ad;
@property (weak, nonatomic) IBOutlet UILabel *mLb_name;
-(void)loadCellInfoWthDic:(NSDictionary *)dic;
@end
