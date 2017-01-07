//
//  SLChangeDataVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"

@interface SLChangeDataVC : BaseViewController
@property(nonatomic,copy)void(^changeBlock)(NSString *changeStr);

-(void)changeDataBlock:(void(^)(NSString *))block;
@end
