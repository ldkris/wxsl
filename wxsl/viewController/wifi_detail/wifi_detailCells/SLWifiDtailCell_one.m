//
//  SLWifiDtailCell_one.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiDtailCell_one.h"

@implementation SLWifiDtailCell_one

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.mLab_oldPrice.text]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.mLab_oldPrice.attributedText = newPrice;
}

-(void)loadCellInfoWithModel:(SLHotWifiDetial *)model{
    if (model == nil) {
        return;
    }
    self.mlb_city.text = [model.mName stringByAppendingString:@"WIFI租赁"];
    self.mlb_price.text = [model.mPrice stringValue];
    self.mlb_deposit.text = [model.mDeposit stringValue];
    self.mlb_wifiScope.text = [NSString stringWithFormat:@"wifi覆盖范围：%@",model.mRange];//model.mRange;
    self.mlb_days.text = [NSString stringWithFormat:@"最短租赁天数：%@天",[model.mInday stringValue]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
