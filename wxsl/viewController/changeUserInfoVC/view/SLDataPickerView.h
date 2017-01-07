//
//  SLDataPickerView.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLDataPickerViewDelegate;
@interface SLDataPickerView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mLB_title;
@property(strong ,nonatomic)NSArray *mPickerDataSoure;
@property(nonatomic,assign)id<SLDataPickerViewDelegate>delegate;
@end

@protocol SLDataPickerViewDelegate <NSObject>

-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str;

@end