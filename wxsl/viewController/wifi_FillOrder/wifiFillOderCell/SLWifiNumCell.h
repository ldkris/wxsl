//
//  SLWifiNumCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_num;
@property(nonatomic,copy)void(^onclickJianBlock)();
@property(nonatomic,copy)void(^onclickJiaBlock)();
-(void)block_Jia:(void (^)())block;
-(void)block_Jian:(void (^)())block;
@end
