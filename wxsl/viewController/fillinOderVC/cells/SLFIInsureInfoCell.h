//
//  SLFIInsureInfoCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLFIInsureInfoCellDeleagte;
@interface SLFIInsureInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mLB_Num;
@property (weak, nonatomic) IBOutlet UILabel *mLB_title;
@property(nonatomic,assign)id<SLFIInsureInfoCellDeleagte>delegate;

@end
@protocol SLFIInsureInfoCellDeleagte <NSObject>

-(void)SLFIInsureInfoCell:(SLFIInsureInfoCell *)cell onclickJianBnt:(id)sender;

-(void)SLFIInsureInfoCell:(SLFIInsureInfoCell *)cell onclickJiaBnt:(id)sender;
@end