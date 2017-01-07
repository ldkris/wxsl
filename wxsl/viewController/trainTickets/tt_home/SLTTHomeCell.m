//
//  SLTTHomeCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/25.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTTHomeCell.h"

@implementation SLTTHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSString *DateStr = [MyFounctions getCurrentDateWithDateFormatter:@"MM月dd日"];
    [self.btn_formTime setTitle:DateStr forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark public
-(void)loadCityInfo:(NSDictionary *)formCity toCity:(NSDictionary *)toCity{
    if (formCity && [[formCity allKeys]count]>0 ) {
        [self.btn_formCity setTitle:formCity[@"city"] forState:UIControlStateNormal];
    }
    
    if (toCity && [[toCity allKeys] count]>0 ) {
        [self.btn_toCity setTitle:toCity[@"city"] forState:UIControlStateNormal];
    }
}

#pragma mark delegate
- (IBAction)onclickLookUpBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLTTHomeCell:onclickLookUpBtn:)]) {
        [_delegate SLTTHomeCell:self onclickLookUpBtn:sender];
    }
}
- (IBAction)onclikFromCityBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLTTHomeCell:onclikFromCityBtn:)]) {
        [_delegate SLTTHomeCell:self onclikFromCityBtn:sender];
    }
}
- (IBAction)onclicktoCityBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLTTHomeCell:onclicktoCityBtn:)]) {
        [_delegate SLTTHomeCell:self onclicktoCityBtn:sender];
    }
}
- (IBAction)onclickfromTimeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLTTHomeCell:onclickfromTimeBtn:)]) {
        [_delegate SLTTHomeCell:self onclickfromTimeBtn:sender];
    }
}

- (IBAction)onclickChangeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLTTHomeCell:onclickChangeBtn:)]) {
        [_delegate SLTTHomeCell:self onclickChangeBtn:sender];
    }
}
@end
