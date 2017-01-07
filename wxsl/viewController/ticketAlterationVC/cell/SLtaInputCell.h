//
//  SLtaInputCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/15.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
@interface SLtaInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (nonatomic, strong) PlaceholderTextView * textView;
@end
