//
//  SLsdPopleInfoCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdPopleInfoCell.h"

@implementation SLsdPopleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoWithModel:(NSDictionary *)model{
    
    if (model  == nil|| [model allKeys].count == 0) {
        return;
    }
    self.mLb_name.text = model[@"name"];
    self.mLb_phoneNum.text = [@"证件号： " stringByAppendingString:model[@"no"]];
}

-(void)loadLianCellInfoWithModel:(SLOrderDetialModel *)model{
    if (model == nil) {
        return;
    }
    self.mLb_name.text = model.mContacts;
    self.mLb_phoneNum.text = model.mMobile;
}
@end
