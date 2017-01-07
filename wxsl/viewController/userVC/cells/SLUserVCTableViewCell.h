//
//  SLUserVCTableViewCell.h
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLUserVCTableViewCellDelegate;
@interface SLUserVCTableViewCell : UITableViewCell
@property(nonatomic,assign)id <SLUserVCTableViewCellDelegate> delegate;
@end

@protocol SLUserVCTableViewCellDelegate <NSObject>

-(void)SLUserVCTableViewCell:(SLUserVCTableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end