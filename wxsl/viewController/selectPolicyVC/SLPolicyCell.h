//
//  SLPolicyCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLPolicyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mImg_mark;
-(void)loadCellInfoWithModel:(SLPassengerModel * )model;
@end
