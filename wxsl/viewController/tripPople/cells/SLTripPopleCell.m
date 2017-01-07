//
//  SLTripPopleCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTripPopleCell.h"
@interface SLTripPopleCell ()
@property (weak, nonatomic) IBOutlet UILabel *mLB_name;
@property (weak, nonatomic) IBOutlet UILabel *mLB_phoneNum;

@end
@implementation SLTripPopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.mBtn_status.hidden = YES;
}

#pragma mark public
-(void)loadCellInfoWithModel:(id)model{
    if (model == nil) {
        return;
    }
    
    if (![model isKindOfClass:[SLContactModel class]]) {
        SLUserInfoModel *tempModel = model;
        self.mLB_name.text = tempModel.mChineseName;
        self.mLB_phoneNum.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];;
        
    }else{
        SLContactModel *tempModel = model;
        self.mLB_name.text = tempModel.mName;
        self.mLB_phoneNum.text = tempModel.mMobile;
        
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
