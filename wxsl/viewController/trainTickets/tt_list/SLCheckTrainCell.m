//
//  SLCheckTrainCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCheckTrainCell.h"

@interface SLCheckTrainCell()

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
@property (weak, nonatomic) IBOutlet UIView *mSeatSView;

@end
@implementation SLCheckTrainCell

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
-(void)loadCellInfoWithDic:(SLTTListModel *)model{
    self.mLB_fromTime.text = model.mdepTime;//[self stringWithDateStr:model.mde];
    self.mLB_arriveTime.text = model.marrTime;//[self stringWithDateStr:model.marrTime];
    
    self.mLB_formAirport.text = model.mdepStation;//[model.mFormAirport stringByAppendingString:model.mformTerm];;
    self.mLB_arrvieAirport.text = model.marrStation;//[model.mArriveAi	rport stringByAppendingString:model.marrTerm];
    
    self.mLB_useTime.text = model.mtrainCode;//[NSString stringWithFormat:@"%d个小时%d分",[model.m  intValue]/60/60,[model.mUseTime  intValue]/60%60];
    
    self.mLB_price.text = [NSString stringWithFormat:@"￥%@",model.mminPrice ];
    self.mLB_JT.text = [NSString stringWithFormat:@"%d个小时%d分",[model.mcostTime  intValue]/60,[model.mcostTime  intValue]%60];
}
-(void)setSeats:(SLTTListModel *)model{
    if(model.mseats == nil || model.mseats == 0){
        return;
    }
    UILabel *mOldLable;
    for (int i = 0; i<model.mseats.count; i++) {
        if (i>=3) {
            return;
        }
        UILabel *mLable = [[UILabel alloc]init];
        NSString *text = [NSString stringWithFormat:@"%@:%@张",model.mseats[i][@"name"],model.mseats[i][@"count"]];
        [mLable setFont:DEFAULT_FONT(12)];
        [mLable setTextColor:self.mLB_formAirport.textColor];
        [mLable setText:text];
        [self.mSeatSView addSubview:mLable];
        [mLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (mOldLable == nil) {
                make.top.mas_equalTo(12);
                make.left.mas_equalTo(10);
            }else{
                make.top.mas_equalTo(12);
                make.left.equalTo(mOldLable.mas_right).with.offset(30);
            }
            
            
        }];
        
        mOldLable = mLable;
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
