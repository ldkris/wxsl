//
//  SLWifiGetPalceCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiGetPalceCell.h"

@implementation SLWifiGetPalceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCellInfoWthDic:(NSDictionary *)dic{
    if (dic == nil || [dic allKeys].count == 0) {
        return;
    }
    
    self.mLb_name.text = dic[@"name"];
    self.mlb_ad.text = dic[@"address"];
    self.mlb_time.text = [NSString stringWithFormat:@"营业时间：%@",dic[@"worktime"]];
}
@end
