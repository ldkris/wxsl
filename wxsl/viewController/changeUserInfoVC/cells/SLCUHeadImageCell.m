//
//  SLCUHeadImageCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCUHeadImageCell.h"

@implementation SLCUHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
