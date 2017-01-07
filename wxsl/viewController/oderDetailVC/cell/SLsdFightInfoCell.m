//
//  SLsdFightInfoCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdFightInfoCell.h"

@implementation SLsdFightInfoCell

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
    if(model == nil){
        return;
    }
    
    self.mLb_jj.text = [NSString stringWithFormat:@"￥%@",[model.mMcCost stringValue]];
    self.mLb_RBD.text = [model.mCabin stringByAppendingString:@"/"];
    self.mLb_price.text = [NSString stringWithFormat:@"￥%d",[model.mTicketPrice intValue] - [model.mMcCost intValue]];
    self.mLb_amountb.text = [NSString stringWithFormat:@"￥%d",[model.mTicketPrice intValue]];
}
@end
