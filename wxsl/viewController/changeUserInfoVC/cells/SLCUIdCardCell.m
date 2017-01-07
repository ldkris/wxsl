//
//  SLCUIdCardCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCUIdCardCell.h"

@implementation SLCUIdCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)loadCellInfoWithModel:(NSDictionary *)dic{
    
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if (dic== nil || [dic allKeys].count == 0) {
        return;
    }

    NSString *type = dic[@"type"];
    if(type && type.length>0){
        self.mLB_CardType.text =type;
    }else{
        self.mLB_CardType.text = dic[@"IDname"];
    }
    self.mLB_IdCardNum.text = dic[@"no"];
    
    NSString *tempStarTime = dic[@"startTime"];
    NSString *tempENDTime = dic[@"endTime"];
    if (tempENDTime && tempENDTime.length>0 && tempStarTime && tempStarTime.length>0) {
        self.mLB_Time.text = [NSString stringWithFormat:@"%@ 至 %@",tempStarTime,tempENDTime];
    }else{
//        self.markTime.hidden = YES;
         self.mLB_Time.text = @"无";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
