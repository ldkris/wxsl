//
//  SLWifiOrderListCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiOrderListCell.h"

@implementation SLWifiOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mlab_reason.layer.masksToBounds = YES;
    self.mlab_reason.layer.cornerRadius = 2.0f;
    
    self.mbtn_btn.layer.borderColor =  self.mbtn_btn.titleLabel.textColor.CGColor;
    self.mbtn_btn.layer.borderWidth = 0.5f;
    
    self.mbtn_deleOder.layer.borderColor =  self.mbtn_deleOder.titleLabel.textColor.CGColor;
    self.mbtn_deleOder.layer.borderWidth = 0.5f;
    
    [self.mContentView.layer setMasksToBounds:YES];
    [self.mContentView.layer setCornerRadius:5.0f];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)onclikCancelBlock:(void (^)(UIButton *sender ))block{
    self.onclikCancelBlock = block;
}
- (IBAction)oncickCancelBtn:(id)sender {
    if (self.onclikCancelBlock) {
        self.onclikCancelBlock(sender);
    }
}
-(void)loadCellInfoWithModel:(SLWifiOderListModel *)model{
    if (model == nil) {
        return;
    }
    
//    if([model.mStatus integerValue] ==3){
//        self.mbtn_btn.hidden =NO;
//    }else{
//        self.mbtn_btn.hidden =YES;
//    }
    
    self.mlab_name.text = [model.mName stringByAppendingString:@"WIFI租赁"];
    self.mlab_pirce.text = [@"￥" stringByAppendingString:[model.mPrice stringValue]];
    self.mlab_time.text = model.mUseDate;
    self.mlab_staus.text = model.mStatusDesc;
    self.mlab_reason.text = [model.mTripTypeDesc substringToIndex:2];
    

}
@end
