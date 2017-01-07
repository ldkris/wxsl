//
//  SLWifiHomeFootView.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiHomeFootView.h"
@interface SLWifiHomeFootView ()
@property (weak, nonatomic) IBOutlet UIButton *btn_mAllCity;

@end
@implementation SLWifiHomeFootView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.btn_mAllCity.titleLabel setTextColor:SL_BULE];
}
-(void)SLWifiHomeFootViewOnclickMoreBtnBlock:(void (^)(UIButton *))block{
    self.onclickMoreBtn = block ;
}
- (IBAction)onclickMoreBtn:(UIButton *)sender {
    
    if (self.onclickMoreBtn) {
        self.onclickMoreBtn(sender);
    }
}
@end
