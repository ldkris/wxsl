//
//  SLOdersCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLOdersCell.h"

#define SZ_GRAY    RGBACOLOR(159, 159, 159, 1)

@interface SLOdersCell ()
@property(nonatomic,retain)IBOutlet UIImageView *mLogoImgView;
/**
 *  航班信息
 */
@property(nonatomic,retain)IBOutlet UILabel *mFightInfoLable;

/**
 *  起飞时间
 */
@property(nonatomic,retain)IBOutlet UILabel *mformLable;
/**
 *  起飞机场
 */
@property(nonatomic,retain)IBOutlet UILabel *mformFightLable;

@property(nonatomic,retain)IBOutlet UILabel *mPassMangerLable;
/**
 *  价格
 */
@property(nonatomic,retain)IBOutlet UILabel *mPriceLable;
/**
 *  到达时间
 */
@property(nonatomic,retain)IBOutlet UILabel *mtomLable;
/**
 *  到达机场
 */
@property(nonatomic,retain)IBOutlet UILabel *mtomFightLable;
/**
 *  订单状态
 */
@property(nonatomic,retain)IBOutlet UILabel *mStatusLable;
/**
 *  飞行时间
 */
@property(nonatomic,retain)IBOutlet UILabel *museTimeLable;

/**
 *  预定时间
 */
@property(nonatomic,retain)IBOutlet UILabel *mYDTimeLable;
/**
 *  是否经停
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_JT;

@end

@implementation SLOdersCell{

   NSDictionary *_bookStatusDic;
}
-(void)awakeFromNib{
   _bookStatusDic = @{@"10":@"待审核",@"11":@"审核被拒",@"101":@"待支付",@"201":@"待出票",@"202":@"出票中",@"203":@"已出票",@"204":@"出票失败",@"301":@"待取消",@"302":@"取消中",@"303":@"已取消",@"304":@"取消失败",@"401":@"待退票",@"402":@"退票中",@"404":@"退票失败",@"501":@"待改签",@"502":@"改签中",@"503":@"已改签",@"504":@"改签失败"};
}
-(void)loadCellInfoWithModel:(SLOrderModel *)model{
    if(model == nil){
        return;
    }
    
    if ([model.mStop boolValue]) {
        self.mLB_JT.text = @"经停";
    }else{
        self.mLB_JT.text = @"直接";
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[model.mAirline lowercaseString] ofType:@"png"];
    [self.mLogoImgView setImage:[UIImage imageWithContentsOfFile:path]];

    
    self.mFightInfoLable.text = [NSString stringWithFormat:@"%@ %@%@ %@",model.mAirline,model.mAirlineNo,model.mFlight,model.mFlightDate];
    self.mformLable.text = [model.mDepTime substringToIndex:5];
    self.mPriceLable.text = [@"￥"stringByAppendingString:[model.mTicketPrice stringValue]];
    self.mtomLable.text = [model.mArrTime substringToIndex:5];
    
    if(model.mDepTerm == nil){
        self.mformFightLable.text = model.mDepAirport;
    }else{
        self.mformFightLable.text = [model.mDepAirport stringByAppendingString:model.mDepTerm];
    }
    
    if(model.mArrTerm == nil){
        self.mtomFightLable.text = model.mArrAirport;
    }else{
        self.mtomFightLable.text = [model.mArrAirport stringByAppendingString:model.mArrTerm];
    }
        
    self.mStatusLable.text  = _bookStatusDic[model.mBookStatus] ;
    self.museTimeLable.text = [NSString stringWithFormat:@"%d个小时%d分",[model.mFlightTime  intValue]/60/60,[model.mFlightTime  intValue]/60%60];
    self.mYDTimeLable.text = [model.mBookTime stringByAppendingString:@"预定"];
    
    NSMutableString *str = [NSMutableString string];
    for (NSDictionary *dic in model.passengers) {
        [str appendString:dic[@"name"]];
    }
    self.mPassMangerLable.text = str;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
