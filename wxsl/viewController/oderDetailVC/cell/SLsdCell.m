//
//  SLsdCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdCell.h"

@implementation SLsdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
