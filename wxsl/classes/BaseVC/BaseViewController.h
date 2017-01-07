//
//  BaseViewController.h
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Awesome.h"

typedef NS_ENUM(NSInteger, SLPassengerTicketType) {
    //以下是枚举成员
    principal = 0,//本人
    Others = 1,
};
typedef NS_ENUM(NSInteger, SLPassengerReasonType) {
    //以下是枚举成员
    company = 0,//因为公司
    personal = 1,
};

@interface BaseViewController : UIViewController
/**
 *  设置返回键
 *
 *  @param imageStr 返回键图片
 */
-(void)setNavBackBtnImageStr:(NSString *)imageStr;

/**
 *  收起键盘
 */
-(void)allTFResignFirstResponder;
@end
