//
//  SLForgetPwdVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/19.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLForgetPwdVC.h"

@interface SLForgetPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd_comfir;


@property (weak, nonatomic) IBOutlet UIButton *mBtn_save;
@end

@implementation SLForgetPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.、
    self.title = @"修改密码";
    self.view.backgroundColor = SL_GRAY;
    
    [self.mBtn_save.layer setMasksToBounds:YES];
    [self.mBtn_save.layer setCornerRadius:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//保存
- (IBAction)onclickSaveBtn:(UIButton *)sender {
    
    NSDictionary *mParamDic;
    if (isTest) {
        mParamDic = @{@"userId":self.mUserID,@"password":@"380001"};
    }else{
        
        if (self.mTF_newPwd_comfir.text.length == 0 || self.mTF_newPwd_comfir.text == nil) {
            ShowMSG(@"请输入密码");
            return;
        }
        
        if (![self.mTF_newPwd.text isEqualToString:self.mTF_newPwd_comfir.text]) {
            ShowMSG(@"两次输入的密码不一致");
            return;
        }
        mParamDic = @{@"userId":self.mUserID,@"password":[MyFounctions md5:self.mTF_newPwd_comfir.text]};
    }

    [HttpApi forgetPwd:mParamDic SuccessBlock:^(id responseBody) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
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
