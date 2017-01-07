//
//  SLWifiHomeHeaderView.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLWifiHomeHeaderViewDelegate;
@interface SLWifiHomeHeaderView : UICollectionReusableView
@property(nonatomic,assign)id<SLWifiHomeHeaderViewDelegate>delegate;
-(void)setImagePlayViews:(NSArray *)imageArray;
-(void)deallocImageView;
@end
@protocol SLWifiHomeHeaderViewDelegate <NSObject>
-(void)SLWifiHomeHeaderView:( SLWifiHomeHeaderView *)view onclickHelperBtn:(UIButton *)sender;
-(void)SLWifiHomeHeaderView:( SLWifiHomeHeaderView *)view onclickHotBtn:(UIButton *)sender;
@end
