//
//  SLFlightTrackCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFlightTrackCell.h"
@interface SLFlightTrackCell()
@property (weak, nonatomic) IBOutlet UIButton *btn_lookUpBtn;
@end
@implementation SLFlightTrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btn_lookUpBtn.layer.masksToBounds = YES;
    self.btn_lookUpBtn.layer.cornerRadius = 2;
    NSString *DateStr = [MyFounctions getCurrentDateWithDateFormatter:@"MM月dd日"];
    [self.btn_formTime setTitle:DateStr forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark public
-(void)loadCityInfo:(NSDictionary *)formCity toCity:(NSDictionary *)toCity{
    if (formCity && [[formCity allKeys]count]>0 ) {
        [self.btn_formCity setTitle:formCity[@"city"] forState:UIControlStateNormal];
    }
    
    if (toCity && [[toCity allKeys] count]>0 ) {
        [self.btn_toCity setTitle:toCity[@"city"] forState:UIControlStateNormal];
    }
}

#pragma mark delegate
- (IBAction)onclickLookUpBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclickLookUpBtn:)]) {
        [_delegate SLFlightTrackCell:self onclickLookUpBtn:sender];
    }
}
- (IBAction)onclikFromCityBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclikFromCityBtn:)]) {
        [_delegate SLFlightTrackCell:self onclikFromCityBtn:sender];
    }
}
- (IBAction)onclicktoCityBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclicktoCityBtn:)]) {
        [_delegate SLFlightTrackCell:self onclicktoCityBtn:sender];
    }
}
- (IBAction)onclickfromTimeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclickfromTimeBtn:)]) {
        [_delegate SLFlightTrackCell:self onclickfromTimeBtn:sender];
    }
}
- (IBAction)onclickToTimeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclickToTimeBtn:)]) {
        [_delegate SLFlightTrackCell:self onclickToTimeBtn:sender];
    }
}
- (IBAction)onclickChangeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLFlightTrackCell:onclickChangeBtn:)]) {
        [_delegate SLFlightTrackCell:self onclickChangeBtn:sender];
    }
}

@end
