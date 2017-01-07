//
//  SLDJRTableViewCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLDJRTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLB_name;
@property (weak, nonatomic) IBOutlet UILabel *mLB_Policy;
@property (weak, nonatomic) IBOutlet UILabel *mLB_IdNum;

-(void)loadCellInfoWithModel:(SLPassengerModel *)model;
@end
