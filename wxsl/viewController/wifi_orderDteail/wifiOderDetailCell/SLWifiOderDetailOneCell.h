//
//  SLWifiOderDetailOneCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiOderDetailOneCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_title;
@property (weak, nonatomic) IBOutlet UILabel *mlab_subTitle;
-(void)loadCellInfoData:(SLWifiOderDetial *)model withInde:(NSIndexPath *)index;
@end
