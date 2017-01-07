//
//  SLsdFightInfoCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLsdFightInfoCell : UITableViewCell
/**
 *  舱位
 */
@property (weak, nonatomic) IBOutlet UILabel *mLb_RBD;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mLb_price;
/**
 *  机建
 */
@property (weak, nonatomic) IBOutlet UILabel *mLb_jj;
/**
 *  总金额
 */
@property (weak, nonatomic) IBOutlet UILabel *mLb_amountb;

-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model;

@end
