//
//  SLSelectPopleCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSelectPopleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mBtn_mark;

-(void)loadCellInfoWithModel:(id )model;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_name;
/**
 *  部门 及是否面审
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_subTitle;
/**
 *  职级和差旅政策
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_IDname;

@property (weak, nonatomic) IBOutlet UILabel *mLB_IDnum;
@property(nonatomic,assign)BOOL isSelect;
@end
