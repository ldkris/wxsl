//
//  SLHomeReusableView.h
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLHomeReusableViewDelegate;
@interface SLHomeReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIButton *mNoticeBtn;
@property (weak, nonatomic) IBOutlet UILabel *mLB_title;
@property (weak, nonatomic) IBOutlet UILabel *mLB_subTitle;
@property(assign,nonatomic)id<SLHomeReusableViewDelegate>delegate;
-(void)setImagePlayViews:(NSArray *)imageArray;
-(void)loadNoticeInfo:(NSDictionary *)info;
@end


@protocol SLHomeReusableViewDelegate <NSObject>
-(void)SLHomeReusableView:(SLHomeReusableView *)view changeRasonBtn:(UIButton *)btn;
-(void)SLHomeReusableView:(SLHomeReusableView *)view onclickNoticeBtn:(UIButton *)btn;
-(void)SLHomeReusableView:(SLHomeReusableView *)view imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index;
@end