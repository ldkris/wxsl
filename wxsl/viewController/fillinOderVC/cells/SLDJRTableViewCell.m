//
//  SLDJRTableViewCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLDJRTableViewCell.h"

@implementation SLDJRTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark public
-(void)loadCellInfoWithModel:(id)model{
    if(model == nil){
        return;
    }
    if ([model isKindOfClass:[SLPassengerModel class]]) {
        SLPassengerModel *tempModel = model;
        self.mLB_name.text = tempModel.mName;
        self.mLB_Policy.text = tempModel.mPolicy;
    }else{
        SLUserInfoModel *tempModel = model;
        self.mLB_name.text = tempModel.mChineseName;
        self.mLB_Policy.text = tempModel.mDName;
//        if (tempModel.mDocTypes.count >0) {
//            self.mLB_IDname.text = tempModel.mDocTypes[0][@"name"];
//            self.mLB_IDnum.text = tempModel.mDocTypes[0][@"no"];
//        }

    }
    
   
}
    
    
@end
