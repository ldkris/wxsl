//
//  SLWifiOderDetailCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiOderDetailCell.h"

@implementation SLWifiOderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mlab_reson.layer.masksToBounds = YES;
    self.mlab_reson.layer.cornerRadius = 2.0f;
    
    self.btn_yd.layer.borderWidth = 1.0f;
    self.btn_yd.layer.borderColor = SL_GRAY.CGColor;
    
    self.btn_cancel.layer.borderWidth = 1.0f;
    self.btn_cancel.layer.borderColor = SL_GRAY.CGColor;
}
- (IBAction)onclickcancelOderBtn:(UIButton *)sender {
    if (self.onclikCancelBlock) {
        self.onclikCancelBlock(sender);
    }
}
-(void)onclikCancelBlock:(void (^)(UIButton *sender ))block{
    self.onclikCancelBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoWithInfo:(SLWifiOderDetial *)model andListModel:(SLWifiOderListModel *)listModel{
    if (model ==nil || listModel == nil) {
        return;
    }
    if([model.mStatus integerValue] ==3){
        self.btn_yd.hidden =NO;
    }else{
        self.btn_yd.hidden =YES;
    }
    self.mlab_oderNo.text = listModel.mOrderNo;
    self.mlab_price.text = model.mAmount;
    self.mlab_reson.text = [listModel.mTripTypeDesc substringToIndex:2];
    self.mlab_status.text = listModel.mStatusDesc;
}
@end
