//
//  SLChangePwdVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLChangePwdVC.h"
#import "SLLoginVC.h"
@interface SLChangePwdVC ()
@property (weak, nonatomic) IBOutlet UIView *mChangeLogoPwdView;
@property (weak, nonatomic) IBOutlet UIView *mChangePayView;

@property (weak, nonatomic) IBOutlet UIButton *mBtn_save;
@property (weak, nonatomic) IBOutlet UIView *mMarkChangeType;

//登陆密码
@property (weak, nonatomic) IBOutlet UITextField *mTF_oldPwd;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd_comfir;

//支付密码
@property (weak, nonatomic) IBOutlet UITextField *mTF_VerCode;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd_pay;
@property (weak, nonatomic) IBOutlet UITextField *mTF_newPwd_pay_comfir;

@end

@implementation SLChangePwdVC{
 NSString *_mVerCodeStr;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改密码";
    self.view.backgroundColor = SL_GRAY;
    
    [self.mBtn_save.layer setMasksToBounds:YES];
    [self.mBtn_save.layer setCornerRadius:5];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.mMarkChangeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(40);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark event response
//修改登陆密码
- (IBAction)onclickChangeLoginPwd:(UIButton *)sender {
    
    self.mChangeLogoPwdView.hidden = NO;
    
    [self.mMarkChangeType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(40);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
    
   
}
//修改支付密码
- (IBAction)onclickChangePayPwd:(UIButton *)sender {
    
    self.mChangeLogoPwdView.hidden = YES;
    
    [self.mMarkChangeType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-40);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
}
//保存
- (IBAction)onclickSaveBtn:(UIButton *)sender {
    
    if(self.mChangeLogoPwdView.hidden){
        NSDictionary *mParamDic;
        if (isTest) {
            mParamDic  = @{@"userId":sl_userID,@"type":@"2",@"newpwd":[MyFounctions md5:@"380001"]};
        }else{
            if (self.mTF_newPwd_pay.text.length == 0 || self.mTF_newPwd_pay.text == nil) {
                ShowMSG(@"请输入密码");
                return;
            }
            
            if (![self.mTF_newPwd_pay.text isEqualToString:self.mTF_newPwd_pay_comfir.text]) {
                ShowMSG(@"两次输入的密码不一致");
                return;
            }
            
            if (self.mTF_VerCode.text != _mVerCodeStr) {
                ShowMSG(@"请输入正确的验证码！");
                return;
            }
            //NSString *asd = __BASE64(self.mTF_newPwd_comfir.text)
            
            mParamDic  = @{@"userId":sl_userID,@"type":@"2",@"newpwd":__BASE64(self.mTF_newPwd_pay.text)};
        }
        
        [HttpApi putModifyPwd:mParamDic SuccessBlock:^(id responseBody) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } FailureBlock:^(NSError *error) {
            
        }];
    
    }else{
        NSDictionary *mParamDic;
        if (isTest) {
            mParamDic  = @{@"userId":sl_userID,@"type":@"1",@"oldpwd":[MyFounctions md5:@"380001"],@"newpwd":[MyFounctions md5:@"380001"]};
        }else{
            if (self.mTF_newPwd_comfir.text.length == 0 || self.mTF_newPwd_comfir.text == nil) {
                ShowMSG(@"请输入密码");
                return;
            }
            
            if (![self.mTF_newPwd.text isEqualToString:self.mTF_newPwd_comfir.text]) {
                ShowMSG(@"两次输入的密码不一致");
                return;
            }
            if (![self.mTF_oldPwd.text isEqualToString:self.mTF_newPwd_comfir.text]) {
                ShowMSG(@"新密码和旧密码不能一样");
                return;
            }
            
            mParamDic  = @{@"userId":sl_userID,@"type":@"1",@"oldpwd":__BASE64(self.mTF_oldPwd.text),@"newpwd":__BASE64(self.mTF_newPwd_comfir.text)};
        }
        
        [HttpApi putModifyPwd:mParamDic SuccessBlock:^(id responseBody) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MyFounctions removeUserInfo];
                SLLoginVC *mLoginVC = [[SLLoginVC alloc]initWithNibName:@"SLLoginVC" bundle:[NSBundle mainBundle]];
                UINavigationController *mNav = [[UINavigationController alloc]initWithRootViewController:mLoginVC];
                [self presentViewController:mNav animated:YES completion:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            });
            
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    
}
//获取验证码
- (IBAction)onclickGetVerificationCodeBtn:(UIButton *)sender {
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
