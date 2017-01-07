//
//  SLsdSendCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLsdSendCell : UITableViewCell
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_name;
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_phoneNum;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_AD;
@property (weak, nonatomic) IBOutlet UILabel *mLb_status;
-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model;
@end
