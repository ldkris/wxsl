//
//  SLNoticeCell.h
//  wxsl
//
//  Created by 刘冬 on 16/8/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLNoticeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLB_title;
@property (weak, nonatomic) IBOutlet UILabel *mLB_subTitle;

-(void)loadNotceInfo:(NSDictionary *)info;
@end
