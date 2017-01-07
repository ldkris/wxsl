//
//  SLAddressCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddressCell.h"
@interface SLAddressCell ()
/**
 *  电话
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_phone;
/**
 *  店址
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_address;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_name;
@end
@implementation SLAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark piblic
-(void)loadCellInfoWithModel:(SLAddressModel *)model{
    
    if (model == nil) {
        return;
    }
    self.mLB_name.text = model.mName;
    self.mLB_phone.text = model.mMobile;
    self.mLB_address.text = model.mAddress;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
