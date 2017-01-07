//
//  SLsdInsureCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdInsureCell.h"
@interface SLsdInsureCell ()
@property (weak, nonatomic) IBOutlet UILabel *mLb_Name;
@property (weak, nonatomic) IBOutlet UILabel *mLB_num;
@property (weak, nonatomic) IBOutlet UILabel *mLB_desc;

@property (weak, nonatomic) IBOutlet UILabel *mLB_price;
@end
@implementation SLsdInsureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model{
    if(model == nil || model.insurances.count == 0 || model.insurances == nil){
        return;
    }
    NSDictionary *temp = model.insurances[0];
    
    if (temp  == nil|| [temp allKeys].count == 0) {
        return;
    }
    
    self.mLB_price.text = [NSString stringWithFormat:@"￥%@/份",temp[@"fee"]];
    self.mLB_num.text = [@"x" stringByAppendingString: [temp[@"num"] stringValue]];
   // self.mLB_desc.text = temp[@"desc"];
    
}
@end
