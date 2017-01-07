//
//  SLWifiInputInfo.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/13.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiInputInfo.h"

@interface SLWifiInputInfo ()
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfire;
@property (weak, nonatomic) IBOutlet UITextField *tf_inpt;
@end

@implementation SLWifiInputInfo{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mBtn_comfire.layer.masksToBounds = YES;
    self.mBtn_comfire.layer.cornerRadius = 5.0f;
    
    [self.view setBackgroundColor:SL_GRAY];
    
    self.tf_inpt.placeholder = [NSString stringWithFormat:@"请输入%@",self.title];
}
-(void)backDataBlock:(void (^)(NSString *))block{
    self.backData = block;
}
- (IBAction)onclickComFirBtn:(id)sender {
    if(self.tf_inpt.text == nil || self.tf_inpt.text.length==0 ){
        NSString *temp =[NSString stringWithFormat:@"请输入%@",self.title];
        ShowMSG(temp);
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    self.backData(self.tf_inpt.text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
