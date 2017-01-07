//
//  SLCheckResultCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLCheckResultCellDelegate;
@interface SLCheckResultCell : UITableViewCell
@property(nonatomic,assign)id<SLCheckResultCellDelegate>delegate;
-(void)loadCellInfo:(SLRBDModel *)model;
@end
@protocol SLCheckResultCellDelegate <NSObject>

-(void)SLCheckResultCell:(SLCheckResultCell *)cell onclickReserveBtn:(UIButton *)sender;

-(void)SLCheckResultCell:(SLCheckResultCell *)cell onclickTGQBtn:(UIButton *)sender;
@end