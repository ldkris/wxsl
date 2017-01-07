//
//  SLHomeThreeCollectionViewCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLHomeThreeCollectionViewCell.h"

@implementation SLHomeThreeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onclickQZBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeThreeCollectionViewCellDelegate:onclickQZBtn:)]) {
        [_delegate SLHomeThreeCollectionViewCellDelegate:self onclickQZBtn:sender];
    }
}
- (IBAction)onclickJDBtn:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeThreeCollectionViewCellDelegate:onclickJDBtn:)]) {
        [_delegate SLHomeThreeCollectionViewCellDelegate:self onclickJDBtn:sender];
    }
}

@end
