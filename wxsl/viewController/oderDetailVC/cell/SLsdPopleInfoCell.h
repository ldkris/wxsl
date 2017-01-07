//
//  SLsdPopleInfoCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLsdPopleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLb_name;
@property (weak, nonatomic) IBOutlet UILabel *mLb_phoneNum;
-(void)loadCellInfoWithModel:(NSDictionary *)model;


-(void)loadLianCellInfoWithModel:(SLOrderDetialModel *)model;
@end
