//
//  SLCheckResultCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCheckResultCell.h"
@interface SLCheckResultCell()
@property (weak, nonatomic) IBOutlet UIButton *mBtn_reserve;
/**
 *  舱位名字
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_RBDName;
/**
 *  折扣
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_discount;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_Price;
/**
 *  剩余座位数
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_seat;
@end
@implementation SLCheckResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mBtn_reserve.layer setMasksToBounds:YES];
    [self.mBtn_reserve.layer setCornerRadius:5];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
#pragma mark public
-(void)loadCellInfo:(SLRBDModel *)model{
    self.mLB_RBDName.text  = [model.mRBDName stringByAppendingString:@" "];;
    if ([model.mRBDDiscount floatValue]==10) {
        self.mLB_discount.text = @"全价";
    }else if([model.mRBDDiscount floatValue]<10){
        self.mLB_RBDName.text  = [model.mRBDName stringByAppendingString:@"/"];
        self.mLB_discount.text = [NSString stringWithFormat:@"%0.1f折",[model.mRBDDiscount floatValue]] ;
    }
    self.mLB_Price.text = [@"￥" stringByAppendingString:[model.mRBDSalePrice stringValue]];
    if ([model.mSeat integerValue]<9) {
        self.mLB_seat.text = [NSString stringWithFormat:@"剩余%@",model.mSeat];
    }
}
#pragma mark event response
- (IBAction)onclickReserveBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLCheckResultCell:onclickReserveBtn:)]) {
        [_delegate SLCheckResultCell:self onclickReserveBtn:sender];
    }
}
- (IBAction)onclickTGQBtn:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLCheckResultCell:onclickTGQBtn:)]) {
        [_delegate SLCheckResultCell:self onclickTGQBtn:sender];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
