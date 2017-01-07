//
//  SLCheckTrainCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLCheckTrainCell : UITableViewCell
-(void)loadCellInfoWithDic:(SLTTListModel *)model;
-(void)setSeats:(SLTTListModel *)model;
@end
