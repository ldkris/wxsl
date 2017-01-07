//
//  SLWifiCancelOrderView.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiCancelOrderView.h"
@interface SLWifiCancelOrderView()
@property (weak, nonatomic) IBOutlet UILabel *mlab_num;
@property (weak, nonatomic) IBOutlet UIButton *btn_comfir;
@property (weak, nonatomic) IBOutlet UIView *mContentView;

@end
@implementation SLWifiCancelOrderView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.mContentView.layer.masksToBounds = YES;
    self.mContentView.layer.cornerRadius = 5.0f;
    
    self.btn_comfir.layer.masksToBounds = YES;
    self.btn_comfir.layer.cornerRadius = 5.0f;
}
-(void)onclickJiaBtnBlock:(void (^)(UIButton *))block{
    self.onclickJiaBtnBlock = block;
}
-(void)onclickJianBtnBlock:(void (^)(UIButton *))block{
    self.onclickJianBtnBlock = block;
}
-(void)onclickComfirBtnBlock:(void (^)(UIButton *))block{
    self.onclickComfirBtnBlock = block;
}
- (IBAction)onclickJiaBtn:(UIButton *)sender {
    int i = [self.mlab_num.text intValue];
    i++;
    if ([self.mlab_num.text intValue]> [self.num intValue]) {
        ShowMSG(@"不能超过订单台数！");
        i--;
        return;
    }
    
    self.mlab_num.text = [NSString stringWithFormat:@"%d",i];
    
    if (self.onclickJiaBtnBlock) {
        self.onclickJiaBtnBlock(sender);
    }
}
- (IBAction)onclickJianBtn:(UIButton *)sender {
    int i = [self.mlab_num.text intValue];
    i--;
    if ([self.mlab_num.text intValue] == 1) {
        ShowMSG(@"至少取消一台！");
         i++;
        return;
    }
    
    self.mlab_num.text = [NSString stringWithFormat:@"%d",i];
    
    if (self.onclickJianBtnBlock) {
        self.onclickJianBtnBlock(sender);
    }
}
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    sender.tag =  [self.mlab_num.text intValue];
    if (self.onclickComfirBtnBlock) {
        self.onclickComfirBtnBlock(sender);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}

@end
