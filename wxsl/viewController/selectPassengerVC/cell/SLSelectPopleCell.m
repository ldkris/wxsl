//
//  SLSelectPopleCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectPopleCell.h"
@interface SLSelectPopleCell ()



@end

@implementation SLSelectPopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mBtn_mark.hidden = YES;
}
#pragma mark public
-(void)loadCellInfoWithModel:(id )model{
    
    self.mBtn_mark.hidden = !self.isSelect;
    
    if (model == nil) {
        return;
    }
    [self.mBtn_mark setImage:[UIImage imageNamed:@"hotel_icon_fan"]];
    if (![model isKindOfClass:[SLPassengerModel class]]) {
        SLUserInfoModel *tempModel = model;
        self.mLB_name.text = tempModel.mChineseName;
        self.mLB_subTitle.text = tempModel.mDName;
        if (tempModel.mDocTypes.count >0) {
            self.mLB_IDname.text = tempModel.mDocTypes[0][@"name"];
            self.mLB_IDnum.text = tempModel.mDocTypes[0][@"no"];
        }
    }else{
        SLPassengerModel *tempModel = model;
        self.mLB_name.text = tempModel.mName;
        self.mLB_subTitle.text = tempModel.mDname;
        self.mLB_IDname.text = tempModel.mIDType;
        self.mLB_IDnum.text = tempModel.mIdcard;
    }

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
