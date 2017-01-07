//
//  SLHomeFourCollectionViewCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLHomeFourCollectionViewCell.h"

@implementation SLHomeFourCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onclickHCPBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeFourCollectionViewCellDelegate:onclickHCPBtn:)]) {
        [_delegate SLHomeFourCollectionViewCellDelegate:self onclickHCPBtn:sender];
    }
}
- (IBAction)onclickQCPBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeFourCollectionViewCellDelegate:onclickQCPBtn:)]) {
        [_delegate SLHomeFourCollectionViewCellDelegate:self onclickQCPBtn:sender];
    }
}

@end
