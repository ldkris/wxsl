//
//  SLFIFightInfoCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFIFightInfoCell.h"
@interface SLFIFightInfoCell ()
/**
 *  舱位
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_freightSpace;
/**
 *  折扣
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_discount;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_price;
/**
 *  机健
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_JJ;
@property (weak, nonatomic) IBOutlet UIImageView *mImg_qu;


/**
 *  返回舱位
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_BackfreightSpace;
/**
 *  返回折扣
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_Backdiscount;
/**
 *  返回价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_Backprice;
/**
 *  返回机健
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_BackJJ;
@property (weak, nonatomic) IBOutlet UIImageView *mImage_fan;
@property (weak, nonatomic) IBOutlet UILabel *mark_jj;
@end
@implementation SLFIFightInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mLB_BackfreightSpace.text = @"";
    self.mLB_Backdiscount.text = @"";
    self.mLB_Backprice.text = @"";
    self.mLB_BackJJ.text = @"";
}
#pragma mark public
-(void)loadCellInfo:(SLRBDModel *)model withFightModel:(SLCheckFightModel *)FModel{
    if (model == nil || FModel == nil) {
        return;
    }
    self.mLB_freightSpace.text = [NSString stringWithFormat:@"%@/%@",model.mRBDName,model.mRBDCode];
    self.mLB_price.text = [@"￥" stringByAppendingString:[model.mRBDSalePrice stringValue]];
    self.mLB_discount.text = [NSString stringWithFormat:@"%0.1f折",[model.mRBDDiscount floatValue]];
    self.mLB_JJ.text = [@"￥" stringByAppendingString:[FModel.mAirrax stringValue]];
    [self.mImg_qu setImage:nil];
    [self.mImage_fan setImage:nil];
    self.mark_jj.hidden = YES;
}

-(void)loadCellInfo:(SLRBDModel *)model withFightModel:(SLCheckFightModel *)FModel WFinfo:(SLRBDModel *)wfmodel withWFFightModel:(SLCheckFightModel *)wFModel{
    if (model == nil || FModel == nil || wfmodel == nil || wFModel == nil) {
        return;
    }
    self.mLB_freightSpace.text = [NSString stringWithFormat:@"%@/%@",model.mRBDName,model.mRBDCode];
    self.mLB_price.text = [@"￥" stringByAppendingString:[model.mRBDSalePrice stringValue]];
    self.mLB_discount.text = [NSString stringWithFormat:@"%0.1f折",[model.mRBDDiscount floatValue]] ;
    self.mLB_JJ.text = [@"￥" stringByAppendingString:[FModel.mAirrax stringValue]];
    
    self.mLB_BackfreightSpace.text = [NSString stringWithFormat:@"%@/%@",wfmodel.mRBDName,wfmodel.mRBDCode];
    self.mLB_Backprice.text = [@"￥" stringByAppendingString:[wfmodel.mRBDSalePrice stringValue]];
    self.mLB_Backdiscount.text = [NSString stringWithFormat:@"%0.1f折",[model.mRBDDiscount floatValue]] ;
    self.mLB_BackJJ.text = [@"￥" stringByAppendingString:[wFModel.mAirrax stringValue]];
    self.mark_jj.hidden = NO;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
