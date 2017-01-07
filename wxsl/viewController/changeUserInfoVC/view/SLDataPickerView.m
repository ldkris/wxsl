//
//  SLDataPickerView.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLDataPickerView.h"
@interface SLDataPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *mCompleBtn;
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UIPickerView *mInfoPicker;
@property(strong,nonatomic)NSString *mSelectedStr;
@end
@implementation SLDataPickerView
-(void)awakeFromNib{

    [self showDialogView:self.mContentView];
    
    [self.mCompleBtn addTarget:self action:@selector(onclickCompleBtn:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark getter
-(NSArray *)mPickerDataSoure{
    if (_mPickerDataSoure == nil) {
        _mPickerDataSoure = [NSArray array];
    }
    return _mPickerDataSoure;
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
#pragma mark event response
- (void)onclickCompleBtn:(UIButton *)sender {
   // LDLOG(@"完成");
    
    [self dismissDialogView:self.mContentView];
    
    if (self.mPickerDataSoure.count>0) {
        if (self.mSelectedStr == nil) {
            self.mSelectedStr = self.mPickerDataSoure[0];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(SLDataPickerView:onclickCompleBtn:SelectedStr:)]) {
            [_delegate SLDataPickerView:self onclickCompleBtn:sender SelectedStr:self.mSelectedStr];
        }
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissDialogView:self.mContentView];
}
#pragma mark UIPickerViewDelegate && UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;  // 返回1表明该控件只包含1列
}
// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.mPickerDataSoure.count;
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id temp = self.mPickerDataSoure[row];
    if ([temp isKindOfClass:[NSString class]]) {
        return temp;
    }else{
        return temp[@"name"];
    }
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.mSelectedStr = self.mPickerDataSoure[row];
}
@end
