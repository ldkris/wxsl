//
//  SLWifiDtailCell_three.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiDtailCell_three : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_content;
-(void)loadCellInfoWithModel:(SLHotWifiDetial *)model;
-(void)loadCellAirInfoWithModel:(NSArray *)model;
-(void)loadCellFYInfoWithModel;
-(void)loadCellTGQInfoWithModel;
@end
