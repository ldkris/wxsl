//
//  SLtaFihhtInfoCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLtaFihhtInfoCell.h"

@implementation SLtaFihhtInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)loadCellInfoWithModel:(SLOrderModel *)order withDetalModel:(SLOrderDetialModel *)DetialModel{
    if (order == nil || DetialModel == nil) {
        return;
    }
    self.mlb_price.text = [NSString stringWithFormat:@"￥%d",[DetialModel.mTicketPrice intValue]+ [DetialModel.mMcCost intValue]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[order.mAirline lowercaseString] ofType:@"png"];
    [self.img_flightLogo setImage:[UIImage imageWithContentsOfFile:path]];
    
    
    self.mLb_fightInfo.text = [NSString stringWithFormat:@"%@ %@%@ %@",order.mAirline,order.mAirlineNo,order.mFlight,order.mFlightDate];
    self.mlb_formTime.text = [order.mDepTime substringToIndex:5];
    self.mlb_toTime.text = [order.mArrTime substringToIndex:5];
    
    if(order.mDepTerm == nil){
        self.mLB_FormAirPort.text = order.mDepAirport;
    }else{
        self.mLB_FormAirPort.text = [order.mDepAirport stringByAppendingString:order.mDepTerm];
    }
    
    if(order.mArrTerm == nil){
        self.mLB_ArrAirPort.text = order.mArrAirport;
    }else{
        self.mLB_ArrAirPort.text = [order.mArrAirport stringByAppendingString:order.mArrTerm];
    }

    self.mlb_contentTime.text = [NSString stringWithFormat:@"%d个小时%d分",[order.mFlightTime  intValue]/60/60,[order.mFlightTime  intValue]/60%60];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
