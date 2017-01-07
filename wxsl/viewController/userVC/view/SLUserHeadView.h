//
//  SLUserHeadView.h
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLUserHeadViewDelegate;
@interface SLUserHeadView : UIView
@property(nonatomic,retain)UIImageView *mImg_backGround;
@property(nonatomic,retain)UIImageView *mImg_head;
@property(nonatomic,retain)UILabel *mLB_userName;
@property(nonatomic,retain)UILabel *mLB_commanyName;

@property(nonatomic,retain)UIButton *mBtn_back;
@property(nonatomic,assign)id<SLUserHeadViewDelegate>delegate;
@end

@protocol SLUserHeadViewDelegate <NSObject>

-(void)SLUserHeadView:(SLUserHeadView *)view onclickBackBtn:(UIButton *)sender;

@end