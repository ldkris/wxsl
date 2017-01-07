//
//  CCActionSheet.h
//  CCActionSheet
//
//  Created by maxmoo on 16/1/29.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCActionSheetDelegate <NSObject>

@optional
- (void)cc_actionSheetDidSelectedIndex:(NSInteger)index SelectBtn:(UIButton *)sender;

@end



@interface CCActionSheet : UIView

@property (strong, nonatomic) id<CCActionSheetDelegate> delegate;

+ (instancetype)shareSheet;
/**
 区分取消和选择,使用array
 回调使用协议
 */
- (void)cc_actionSheetWithSelectArray:(NSArray *)array deltalArray:(NSArray *)detailArr cancelTitle:(NSString *)cancel delegate:(id<CCActionSheetDelegate>)delegate titile:(NSString *)titile;

-(void)cc_showTuiGaiQianView:(NSString *)title contentStr:(NSString *)contentStr cancelTitle:(NSString *)cancel delegate:(id<CCActionSheetDelegate>)delegate;

@end
