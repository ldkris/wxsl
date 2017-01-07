//
//  SLCheckFlightCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCheckFlightCell.h"
@interface SLCheckFlightCell()
@property (weak, nonatomic) IBOutlet UIView *mContentView;
/**
 *  起飞时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_fromTime;
/**
 *  到达时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_arriveTime;
/**
 *  起飞机场
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_formAirport;
/**
 *  到达机场
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_arrvieAirport;
/**
 *  航空公司LOGO
 */
@property (weak, nonatomic) IBOutlet UIImageView *mImg_airlineLogo;
/**
 *  航空公司名字
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_airlineName;
/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_price;
/**
 *  用时
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_useTime;
/**
 *  是否经停
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_JT;

@end
@implementation SLCheckFlightCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    // Initialization code
    [self.mContentView.layer setMasksToBounds:YES];
    [self.mContentView.layer setCornerRadius:5.0f];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark public
-(void)loadCellInfoWithDic:(SLCheckFightModel *)model{
    self.mLB_fromTime.text = [self stringWithDateStr:model.mFormTime];
    self.mLB_arriveTime.text = [self stringWithDateStr:model.mArriveTime];
    
    self.mLB_formAirport.text = [model.mFormAirport stringByAppendingString:model.mformTerm];;
    self.mLB_arrvieAirport.text = [model.mArriveAirport stringByAppendingString:model.marrTerm];
    
      self.mLB_useTime.text = [NSString stringWithFormat:@"%d个小时%d分",[model.mUseTime  intValue]/60/60,[model.mUseTime  intValue]/60%60];
  
    self.mLB_price.text = [NSString stringWithFormat:@"￥%@",model.mPrice ];
    
    self.mLB_airlineName.text = [NSString stringWithFormat:@"%@%@%@",model.mAirlineName,model.mAirCode,model.mFlightno];
   
    NSString *path = [[NSBundle mainBundle] pathForResource:[model.mAirCode lowercaseString] ofType:@"png"];
    self.mImg_airlineLogo.image = [UIImage imageWithContentsOfFile:path];
    
    if ([model.mStop boolValue]) {
        self.mLB_JT.text = @"经停";
    }else{
        self.mLB_JT.text = @"直接";
    }
}

#pragma mark private
-(NSString *)stringWithDateStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:timeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
@end
