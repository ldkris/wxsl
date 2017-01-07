//
//  SLCUIdCardCell.h
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCUIdCardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *markTime;
@property (weak, nonatomic) IBOutlet UILabel *mLB_IdCardNum;
@property (weak, nonatomic) IBOutlet UILabel *mLB_Time;
@property (weak, nonatomic) IBOutlet UILabel *mLB_CardType;
-(void)loadCellInfoWithModel:(NSDictionary *)dic;
@end
