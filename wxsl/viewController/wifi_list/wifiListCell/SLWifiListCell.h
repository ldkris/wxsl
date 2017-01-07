//
//  SLWifiListCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiListCell : UITableViewCell
/**
 wifi类型
 */
@property (weak, nonatomic) IBOutlet UILabel *mlb_NetWokring;

/**
 获取方式
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_getStyle;

/**
 国家
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_city;

/**
 最早可预订时间
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_earTime;

/**
 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_price;

/**
 WIFI范围
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_wifiScope;

/**
 最短租赁天数
 */
@property (weak, nonatomic) IBOutlet UILabel *lab_days;

-(void)loadCellInfoWithModel:(SLWifiListModel *)model;
@end
