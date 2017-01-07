//
//  SLWifiNumCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiNumCell.h"

@implementation SLWifiNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)block_Jia:(void (^)())block{
    self.onclickJiaBlock = block;
}
-(void)block_Jian:(void (^)())block{
    self.onclickJianBlock = block;
}
- (IBAction)onclickJianBtn:(id)sender {
    
    int num = [self.lab_num.text intValue];
    num--;
    if ([self.lab_num.text integerValue]<=1) {
        ShowMSG(@"至少预定一台 ！！");
        
        return;
    }
    
    self.lab_num.text = [NSString stringWithFormat:@"%d",num];
    self.onclickJianBlock();
}
- (IBAction)onclickJiaBtn:(id)sender {
    int num = [self.lab_num.text intValue];
    num++;
    self.lab_num.text = [NSString stringWithFormat:@"%d",num];
    self.onclickJiaBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
