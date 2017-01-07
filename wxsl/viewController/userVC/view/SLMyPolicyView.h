//
//  SLMyPolicyView.h
//  wxsl
//
//  Created by 刘冬 on 16/7/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLMyPolicyView : UIView
/**
 *  级别
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_jb;
/**
 *  审批类型
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_sp;
/**
 *  飞机
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_fj;
/**
 *  酒店
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_jd;
/**
 *  火车
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_hc;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
