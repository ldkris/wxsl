//
//  SLDatePickerView.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLDatePickerViewDelegate;
@interface SLDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *mPicker;
@property (weak, nonatomic) IBOutlet UILabel *mLB_title;
@property(assign,nonatomic)id<SLDatePickerViewDelegate>delegate;
@end
@protocol SLDatePickerViewDelegate <NSObject>

-(void)SLDatePickerView:(SLDatePickerView*)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str;
-(void)SLDatePickerView:(SLDatePickerView*)view onclickCompleBtn:(UIButton *)sender SelectedTimeStr:(NSString *)str;
@end