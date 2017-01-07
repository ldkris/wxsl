//
//  SLFIInsureInfoCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFIInsureInfoCell.h"

@implementation SLFIInsureInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)onclickJianBnt:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLFIInsureInfoCell:onclickJianBnt:)]) {
        [_delegate SLFIInsureInfoCell:self onclickJianBnt:sender];
    }
}
- (IBAction)onclickjiaBtn:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFIInsureInfoCell:onclickJiaBnt:)]) {
        [_delegate SLFIInsureInfoCell:self onclickJiaBnt:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
