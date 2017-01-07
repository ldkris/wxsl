//
//  SLsdTGQCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLsdTGQCell : UITableViewCell
/**
 *  退改签
 *
 *  @param model
 */
-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model;
/**
 *  退票或者改签原因
 *
 *  @param model 
 */
-(void)loadTPCellInfoWithModel:(NSArray *)model;

-(void)loadwgCellInfoWithModel:(NSArray *)model;

@property (weak, nonatomic) IBOutlet UILabel *mLb_title;
@end
