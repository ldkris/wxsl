//
//  SLWifiOderDetailOneCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiOderDetailOneCell.h"

@implementation SLWifiOderDetailOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoData:(SLWifiOderDetial *)model withInde:(NSIndexPath *)index{
    if (model == nil) {
        return;
    }
//    self.mlab_subTitle.text= @"无";
    if (index.section == 1) {
        if (index.row == 0) {
            self.mlab_subTitle.text = [NSString stringWithFormat:@"%@ 至 %@",model.mUseDate,model.mUseEndDate];
        }
        if (index.row == 1) {
            self.mlab_subTitle.text = [NSString stringWithFormat:@"%@/台（%@)",model.mDeposit,model.mDepositMode];
        }
        if (index.row == 2) {
            self.mlab_subTitle.text = [NSString stringWithFormat:@"¥%@/天x%@台",model.mPrice,model.mCount];
        }
    }
    
    if (index.section == 2) {
        if (index.row == 0) {
            self.mlab_subTitle.text = [model.mTakeAddress stringByAppendingString:model.mWorktime];
        }
        if (index.row == 1) {
            self.mlab_subTitle.text = [model.mTakeAddress stringByAppendingString:model.mWorktime];
        }
    }
    
    
    if (index.section == 3) {
        if (index.row == 0) {
            self.mlab_subTitle.text = model.mDepositMode;
        }
        if (index.row == 1) {
            self.mlab_subTitle.text = @"无";
        }
    }
    
    if (index.section == 4) {
        if (index.row == 0) {
            self.mlab_subTitle.text =model.mContactName;
        }
        if (index.row == 1) {
            if (model.mContactMobile1 == nil ) {
                self.mlab_subTitle.text = @" ";
                return;
            }
            self.mlab_subTitle.text = model.mContactMobile1;
        }
    }

    if (index.section == 5) {
        if (index.row == 0) {
            self.mlab_subTitle.text =model.mReserveDate;
        }
        if (index.row == 1) {
            self.mlab_subTitle.text = model.mPayType;
        }
        if (index.row == 2) {
            if (model.mPayTime == nil ) {
                self.mlab_subTitle.text = @"未付款";
                return;
            }
            
            self.mlab_subTitle.text = model.mPayTime;
        }
    }
    
    if (index.section == 6) {
        if (index.row == 0) {
            self.mlab_subTitle.text =[model.mCancelCount stringValue];
        }
        if (index.row == 1) {
            self.mlab_subTitle.text = model.mCancelAmount;
        }
        if (index.row == 2) {
            self.mlab_subTitle.text = model.mCancelTime;
        }
        if (index.row == 2) {
            self.mlab_subTitle.text = model.mCharge;
        }
    }
    
}
@end
