//
//  SLDatePickerView.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLDatePickerView.h"
@interface SLDatePickerView ()
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property(nonatomic,retain)NSString *mSelectTime;
@property (weak, nonatomic) IBOutlet UIButton *mCompleBtn;
@end
@implementation SLDatePickerView
-(void)awakeFromNib{
    //[self.mPicker setMinimumDate:[NSDate date]];
    [self showDialogView:self.mContentView];
    
    [self.mCompleBtn addTarget:self action:@selector(onclickCompleBtn:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark private
-(void)showDialogView:(UIView *) view
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:260.0f];;
    animation.toValue=[NSNumber numberWithFloat:0.0f];;
    animation.duration=0.2;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
}
-(void)dismissDialogView:(UIView *)view
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];;
    animation.toValue=[NSNumber numberWithFloat:260.0f];;
    animation.duration=0.2;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissDialogView:self.mContentView];
}
#pragma mark event response
- (IBAction)onclickCompleBtn:(UIButton *)sender {
    
    [self dismissDialogView:self.mContentView];
    
    if (self.mSelectTime == nil) {
         self.mSelectTime = [MyFounctions stringFromDate:[NSDate date]];
    }
    self.mSelectTime = [MyFounctions stringFromDate:self.mPicker.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:MM"];
    NSString *destDateString = [dateFormatter stringFromDate:self.mPicker.date];
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLDatePickerView:onclickCompleBtn:SelectedStr:)]) {
        [_delegate SLDatePickerView:self onclickCompleBtn:sender SelectedStr:self.mSelectTime];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLDatePickerView:onclickCompleBtn:SelectedTimeStr:)]) {
        [_delegate SLDatePickerView:self onclickCompleBtn:sender SelectedTimeStr:destDateString];
    }
}

@end
