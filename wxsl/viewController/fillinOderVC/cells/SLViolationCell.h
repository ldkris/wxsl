//
//  SLViolationCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLViolationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLB_reason;
-(void)loadCellInfoWithModel:(NSDictionary *)lsit;
@end
