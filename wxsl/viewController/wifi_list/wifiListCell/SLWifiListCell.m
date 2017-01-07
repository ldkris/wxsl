//
//  SLWifiListCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiListCell.h"

@implementation SLWifiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mlb_NetWokring.layer.masksToBounds = YES;
    self.mlb_NetWokring.layer.cornerRadius = 2.0f;
    
    self.mlb_NetWokring.layer.borderWidth = 0.5f;
    self.mlb_NetWokring.layer.borderColor = self.mlb_NetWokring.textColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoWithModel:(SLWifiListModel *)model{
    if (model == nil) {
        return;
    }
    self.lab_city.text = [model.mName stringByAppendingString:@"wifi租赁"];
    self.lab_price.text = [model.mPrice stringValue];
    self.lab_getStyle.text = model.mObtainType;
    self.mlb_NetWokring.text = model.mNetwork;
    self.lab_days.text = [model.mInday stringValue];
    self.lab_wifiScope.text = [NSString stringWithFormat:@"wifi覆盖范围：%@",model.mRange];//model.mRange;
    self.lab_days.text = [NSString stringWithFormat:@"最短租赁天数：%@天",[model.mInday stringValue]];

}
@end
