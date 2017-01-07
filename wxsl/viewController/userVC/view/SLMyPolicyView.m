//
//  SLMyPolicyView.m
//  wxsl
//
//  Created by 刘冬 on 16/7/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLMyPolicyView.h"

@implementation SLMyPolicyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5.0f;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];

}
@end
