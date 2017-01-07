//
//  SLHomeTwoCollectionViewCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLHomeTwoCollectionViewCell.h"

@implementation SLHomeTwoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)onclickWifiBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeTwoCollectionViewCell:onclickWifiBtn:)]) {
        [_delegate SLHomeTwoCollectionViewCell:self onclickWifiBtn:sender];
    }
}
- (IBAction)onclickYCbtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeTwoCollectionViewCell:onclickYCbtn:)]) {
        [_delegate SLHomeTwoCollectionViewCell:self onclickYCbtn:sender];
    }
}

@end
