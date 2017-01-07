//
//  SLScrollerImagesView.h
//  wxsl
//
//  Created by 刘冬 on 16/7/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFlightTrackVC.h"
@interface SLScrollerImagesView : UIView
-(void)addImgaeViews:(NSArray *)imageViews;
@property(nonatomic,assign)SLFlightTrackVC *delegate;
@property(nonatomic,retain)UIButton *mbackBtn;
@end
