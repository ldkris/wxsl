//
//  SLSelectHeaderView.h
//  wxsl
//
//  Created by 刘冬 on 16/6/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLSelectHeaderViewDelegate;
@interface SLSelectHeaderView : UIView
@property(nonatomic,assign)id <SLSelectHeaderViewDelegate>delegate;

@property(nonatomic,retain)NSArray *mHotCitys;
@end
@protocol SLSelectHeaderViewDelegate <NSObject>
-(void)SLSelectHeaderView:(SLSelectHeaderView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath WithSelectDic:(NSDictionary *)info;
@end