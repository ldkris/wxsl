//
//  SLsdSendCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdSendCell.h"

@implementation SLsdSendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model{
    if (model == nil) {
        return;
    }
    
    if ((model.mDname == nil || model.mDname.length == 0)&& (model.mDmobile == nil || model.mDmobile.length == 0) && (model.mDistribution == nil || model.mDistribution.length == 0)) {
        self.mLb_status.text = @"不需要";
        self.mLB_name.text = @"";
        self.mLB_phoneNum.text = @"";
        self.mLB_AD.text = @"";
        return;
    }
    
    self.mLB_name.text = model.mDname;
    self.mLB_phoneNum.text =  model.mDmobile;;
    self.mLB_AD.text =  model.mDistribution;
}
@end
