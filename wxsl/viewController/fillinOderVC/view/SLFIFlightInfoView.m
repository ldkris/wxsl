//
//  SLFIFlightInfoView.m
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFIFlightInfoView.h"

#define SZ_GRAY    RGBACOLOR(205, 205, 205, 1)
@interface SLFIFlightInfoView()
@end
@implementation SLFIFlightInfoView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
   
    
    //[self showFlightInfo:@[@"",@""]];
}
-(void)layoutSubviews{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
}
#pragma mark public
-(void)showFlightInfo:(NSArray *)flightInfoArray{
    
    if (flightInfoArray.count == 0 || flightInfoArray == nil) {
        return;
    }
    
    UILabel *mTempLable = [[UILabel alloc]init];
    [mTempLable setFont:DEFAULT_BOLD_FONT(20)];
    [mTempLable setText:@"航班详情"];
    [mTempLable setTextColor:[UIColor whiteColor]];
    [self addSubview:mTempLable];
    [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(150);
    }];
    
    UIView *mOldView;
    for (id temp in flightInfoArray) {
        
        SLCheckFightModel *model = (SLCheckFightModel *)temp;
        
        UIView *mContentView = [[UIView alloc]init];
        [mContentView setBackgroundColor:[UIColor whiteColor]];
        [mContentView.layer setMasksToBounds:YES];
        [mContentView.layer setCornerRadius:5.0f];
        [self addSubview:mContentView];
        [mContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldView == nil) {
                make.top.equalTo(mTempLable.mas_bottom).with.offset(15);
            }else{
                make.top.equalTo(mOldView.mas_bottom).with.offset(15);
            }
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(180);
        }];
        
        UIImageView *mfanImgView = [[UIImageView alloc]init];
        //[mfanImgView setBackgroundColor:[UIColor yellowColor]];
        [mContentView addSubview:mfanImgView];
        [mfanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(20);
            make.height.width.mas_equalTo(10);
        }];
        
        UIImageView *mLogoImgView = [[UIImageView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:[model.mAirCode lowercaseString] ofType:@"png"];
        [mLogoImgView setImage:[UIImage imageWithContentsOfFile:path]];
        [mContentView addSubview:mLogoImgView];
        [mLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(mfanImgView.mas_centerY);
            make.left.equalTo(mfanImgView.mas_right).with.offset(8);
            make.height.width.mas_equalTo(15);
        }];
        
        UILabel *mFightInfoLable = [[UILabel alloc]init];
        [mFightInfoLable setFont:DEFAULT_FONT(14)];
        [mFightInfoLable setTextColor:SL_GRAY_BLACK];
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@ %@",model.mAirlineName,model.mAirCode,model.mFlightno,model.mAirModel];
        [mFightInfoLable setText:str];
        //        [mFightInfoLable setText:@"东航mu5831-实际承运 吉祥H01252"];
        [mContentView addSubview:mFightInfoLable];
        [mFightInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(mLogoImgView.mas_centerY);
            make.left.equalTo(mLogoImgView.mas_right).with.offset(8);
        }];
        
        UILabel *mTimeLable = [[UILabel alloc]init];
        [mTimeLable setFont:DEFAULT_FONT(14)];
        [mTimeLable setTextColor:SL_GRAY_BLACK];
        [mTimeLable setText:model.mFlightDate];
        [mContentView addSubview:mTimeLable];
        [mTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mFightInfoLable.mas_bottom).with.offset(8);
            make.left.equalTo(mFightInfoLable.mas_left);
        }];
        
        
        UILabel *mformLable = [[UILabel alloc]init];
        [mformLable setFont:DEFAULT_BOLD_FONT(18)];
        [mformLable setTextColor:[UIColor blackColor]];
        [mformLable setText:[self stringWithDateStr:model.mFormTime]];
        [mContentView addSubview:mformLable];
        [mformLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mTimeLable.mas_bottom).with.offset(20);
            make.left.equalTo(mTimeLable.mas_left);
        }];
        
        UILabel *mformFightLable = [[UILabel alloc]init];
        [mformFightLable setFont:DEFAULT_BOLD_FONT(13)];
        [mformFightLable setTextColor:SL_GRAY_Hard];
        [mformFightLable setText:model.mFormAirport];
        [mContentView addSubview:mformFightLable];
        [mformFightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mformLable.mas_bottom).with.offset(5);
            make.centerX.equalTo(mformLable.mas_centerX);
        }];
        
        
        UILabel *mtomLable = [[UILabel alloc]init];
        [mtomLable setFont:DEFAULT_BOLD_FONT(18)];
        [mtomLable setTextColor:[UIColor blackColor]];
        [mtomLable setText:[self stringWithDateStr:model.mArriveTime]];
        [mContentView addSubview:mtomLable];
        [mtomLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mTimeLable.mas_bottom).with.offset(20);
            make.right.mas_equalTo(-40);
        }];
        
        UILabel *mtomFightLable = [[UILabel alloc]init];
        [mtomFightLable setFont:DEFAULT_BOLD_FONT(13)];
        [mtomFightLable setTextColor:SL_GRAY_Hard];
        [mtomFightLable setText:model.mArriveAirport];
        [mContentView addSubview:mtomFightLable];
        [mtomFightLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mtomLable.mas_bottom).with.offset(5);
            make.centerX.equalTo(mtomLable.mas_centerX);
        }];
        
        UILabel *museTimeLable = [[UILabel alloc]init];
        [museTimeLable setFont:DEFAULT_BOLD_FONT(12)];
        [museTimeLable setTextColor:SL_GRAY_BLACK];
        [museTimeLable setText:[NSString stringWithFormat:@"%d个小时%d分",[model.mUseTime  intValue]/60/60,[model.mUseTime  intValue]/60%60]];
        [mContentView addSubview:museTimeLable];
        [museTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(mtomLable.mas_centerY).with.offset(0);
            make.centerX.mas_equalTo(10);
        }];
        
        UILabel *markTimeLable = [[UILabel alloc]init];
        [markTimeLable setFont:DEFAULT_BOLD_FONT(12)];
        [markTimeLable setTextColor:SZ_GRAY];
        [markTimeLable setText:@"直接"];
        [mContentView addSubview:markTimeLable];
        [markTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(museTimeLable.mas_bottom).with.offset(5);
            make.centerX.equalTo(museTimeLable.mas_centerX);
        }];
        
        UIImageView *mImgView = [[UIImageView alloc]init];
        [mImgView setImage:[UIImage imageNamed:@"fightMark"]];
        [mContentView addSubview:mImgView];
        [mImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(markTimeLable.mas_bottom).with.offset(20);
            make.left.mas_equalTo(40);
            make.right.mas_equalTo(-40);
            make.height.mas_equalTo(30);
        }];
        
        mOldView = mContentView;
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
@end
