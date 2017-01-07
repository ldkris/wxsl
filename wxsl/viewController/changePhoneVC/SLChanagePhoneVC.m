//
//  SLChanagePhoneVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLChanagePhoneVC.h"

@interface SLChanagePhoneVC ()
@property (weak, nonatomic) IBOutlet UIButton *mBtn_save;

@property (weak, nonatomic) IBOutlet UITextField *mTF_VerCode;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPhomeNum;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPhomeNum_comfir;
@end

@implementation SLChanagePhoneVC{
 NSString *_mVerCodeStr;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改手机号码";
    self.view.backgroundColor = SL_GRAY;
    
    [self.mBtn_save.layer setMasksToBounds:YES];
    [self.mBtn_save.layer setCornerRadius:5];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark event response
//保存
- (IBAction)onclickSaveBtn:(UIButton *)sender {
    
    NSDictionary *mParaDic ;
    if (isTest) {
        mParaDic = @{@"userId":sl_userID,@"mobile":@"15002380001"};
    }else{
        if (_mVerCodeStr == nil ||_mVerCodeStr.length == 0) {
            ShowMSG(@"请先获取验证码！");
            return;
        }
        
        if (self.mTF_VerCode.text == nil || self.mTF_VerCode.text.length == 0) {
            ShowMSG(@"请输入验证码！");
            return;
        }
        
        if (self.mTF_VerCode.text != _mVerCodeStr) {
            ShowMSG(@"请输入正确的验证码！");
            return;
        }
        
         mParaDic = @{@"userId":sl_userID,@"mobile":self.mTF_newPhomeNum.text};
    }
    
    [HttpApi putBindMobile:mParaDic SuccessBlock:^(id responseBody) {
        
        [[NSUserDefaults standardUserDefaults]setObject:mParaDic[@"mobile"] forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
//获取验证码
- (IBAction)onclickGetVerificationCodeBtn:(UIButton *)sender {
//    if (self.mTF_newPhomeNum.text.length == 0 || self.mTF_newPhomeNum.text == nil) {
//        ShowMSG(@"请输入手机号");
//        return;
//    }
//    
//    if (![self.mTF_newPhomeNum_comfir.text isEqualToString:self.mTF_newPhomeNum_comfir.text]) {
//        ShowMSG(@"两次输入的手机号不一致");
//        return;
//    }

    NSDictionary *mTempDic = @{@"mobile":[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]};
    [HttpApi getMobileVcode:mTempDic SuccessBlock:^(id responseBody) {
        
        LDLOG(@"验证码 ===== %@",responseBody[@"vcode"]);
        _mVerCodeStr = responseBody[@"vcode"];
        [MyFounctions startTime:sender];
        
    } FailureBlock:^(NSError *error) {
        
    }];

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
