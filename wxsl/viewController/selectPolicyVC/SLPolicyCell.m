//
//  SLPolicyCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLPolicyCell.h"
@interface SLPolicyCell()
@property (weak, nonatomic) IBOutlet UILabel *mLb_policy;


@end

@implementation SLPolicyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}
-(void)loadCellInfoWithModel:(SLPassengerModel * )model{
    if(model == nil){
        return;
    }
    if(model.mPolicyId ==nil || model.mPolicy.length ==0 || [model.mPolicy isEqual:[NSNull null]]){
        model.mPolicy = @"无商旅政策";
    }
    self.mLb_policy.text = [NSString stringWithFormat:@"%@(%@)",model.mPolicy,model.mName];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
