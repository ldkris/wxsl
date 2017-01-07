//
//  SLUserHeadView.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLUserHeadView.h"

@implementation SLUserHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    
    [self addSubview:self.mImg_backGround];
    [self.mImg_backGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.mas_equalTo(0);
    }];
    
    [self addSubview:self.mImg_head];
    [self.mImg_head mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(13);
        make.height.width.mas_equalTo(60);
    }];
    
    [self addSubview:self.mLB_userName];
    [self.mLB_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mImg_head.mas_top).with.offset(0);
        make.left.equalTo(self.mImg_head.mas_right).with.offset(13);
    }];
    
    [self addSubview:self.mLB_commanyName];
    [self.mLB_commanyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mLB_userName.mas_bottom).with.offset(5);
        make.left.equalTo(self.mImg_head.mas_right).with.offset(13);
    }];
    
//    [self addSubview:self.mBtn_back];
//    [self.mBtn_back mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(32);
//        make.left.mas_equalTo(13);
//    }];
}
#pragma mark event response
-(void)onclickBackBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(SLUserHeadView:onclickBackBtn:)]) {
        [_delegate SLUserHeadView:self onclickBackBtn:sender];
    }
}
#pragma mark getter
-(UIImageView *)mImg_head{
    if (_mImg_head == nil) {
        _mImg_head = [[UIImageView alloc]init];
        _mImg_head.layer.masksToBounds = YES;
        _mImg_head.layer.cornerRadius = 30.0f;
        [_mImg_head setBackgroundColor:SL_BULE];
    }
    
    return _mImg_head;
}
-(UIImageView *)mImg_backGround{
    if (_mImg_backGround == nil) {
        _mImg_backGround = [[UIImageView alloc]init];
        [_mImg_backGround setBackgroundColor:SL_BULE];
//        [_mImg_backGround setImage:[UIImage imageNamed:@"user_logo_bg"]];
    }
    return _mImg_backGround;
}
-(UILabel *)mLB_userName{
    if (_mLB_userName == nil) {
        _mLB_userName = [[UILabel alloc]init];
        [_mLB_userName setText:@"哈哈"];
        [_mLB_userName setFont:DEFAULT_BOLD_FONT(18)];
        [_mLB_userName setTextColor:[UIColor whiteColor]];
    }
    return _mLB_userName;
}
-(UILabel *)mLB_commanyName{
    if (_mLB_commanyName == nil) {
        _mLB_commanyName = [[UILabel alloc]init];
        [_mLB_commanyName setFont:DEFAULT_BOLD_FONT(13)];
        [_mLB_commanyName setTextColor:[UIColor whiteColor]];
        [_mLB_commanyName setText:@"重庆优车车"];
    }
    return _mLB_commanyName;
}
-(UIButton *)mBtn_back{
    if (_mBtn_back == nil) {
        _mBtn_back = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_mBtn_back setTitle:@"返回" forState:UIControlStateNormal];
        [_mBtn_back setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_mBtn_back addTarget:self action:@selector(onclickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mBtn_back;
}
@end
