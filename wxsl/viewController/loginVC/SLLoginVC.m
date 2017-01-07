//
//  SLLoginVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLLoginVC.h"
#import "SLRegisterVC.h"

#import "JPUSHService.h"
#import <CommonCrypto/CommonCryptor.h>

@interface SLLoginVC ()
@property(nonatomic,retain)UIImageView *mBGImageView;

@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UIImageView *test_WEB;
@property (weak, nonatomic) IBOutlet UITextField *mTF_account;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_login;
@property (weak, nonatomic) IBOutlet UITextField *mTF_Password;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_forgetPwd;
@property (weak, nonatomic) IBOutlet UIView *mMarkView;
@property (weak, nonatomic) IBOutlet UITextField *mTF_comanyID;
@end

@implementation SLLoginVC
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.mBGImageView];
    [self.mBGImageView setBackgroundColor:SL_GRAY];
    
    self.mContentView.layer.masksToBounds = YES;
    self.mContentView.layer.cornerRadius = 2;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self.mBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self.mMarkView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self setContentString];
    
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *imagePath = [mainBundle pathForResource:@"_png" ofType:@"webp"];
//    UIImage *mWebImage = [UIImage imageWithWebP:imagePath];
//    [self.test_WEB setImage:mWebImage];
    
//    [SVProgressHUD show];
//    [HttpApi testPostUrl:@"http://7xkehr.com1.z0.glb.clouddn.com/COACH_QR_CODE_107_1448345622800.jpg?imageMogr2/auto-orient/format/webp/interlace/0" SuccessBlock:^(id responseBody) {
//        UIImage *mWebImage = [UIImage imageWithWebPData:responseBody];
//        if (mWebImage ) {
//            [self.test_WEB setImage:mWebImage];
//        }
//        [SVProgressHUD dismiss];
//    } FailureBlock:^(NSError *error) {
//        // LDLOG(@"错误 === %@",error.NSLocalizedDescription);
//        [SVProgressHUD dismiss];
//    }];

  
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark NetWroking
-(void)getUserInfoNetWroking{
    NSMutableDictionary *userInfoDic = [MyFounctions getUserDetailInfo];
    if (userInfoDic && [userInfoDic allKeys]>0) {
        return;
    }
    
    [HttpApi getUserInfo:@{@"userId":sl_userID} isShowLoadingView:NO SuccessBlock:^(id responseBody) {
       // LDLOG(@"用户信息 ==== %@",responseBody);
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseBody];
        [MyFounctions saveDetailUserInfo:userInfo];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
- (IBAction)onclickLoginBtn:(UIButton *)sender {

    NSString * accountStr;
    NSString * passStr;
    NSString * mcommanyID;
    
    if (isTest) {
        [[NSUserDefaults standardUserDefaults]setObject:@"15002380001" forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        accountStr  = __BASE64(@"15002380005");
        passStr  = [MyFounctions md5:@"380005"];
        mcommanyID  = @"51429";

    }else{
        
        if (self.mTF_comanyID.text.length == 0 || self.mTF_comanyID.text == nil) {
            ShowMSG(@"请输入公司ID！");
            return;
        }
        
        if (self.mTF_account.text.length == 0 || self.mTF_account.text == nil) {
            ShowMSG(@"请输入账号！");
            return;
        }
        
        if (self.mTF_Password.text.length == 0 || self.mTF_Password.text == nil) {
            ShowMSG(@"请输入密码！");
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:self.mTF_account.text forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        accountStr  = __BASE64(self.mTF_account.text);
        passStr  = [MyFounctions md5:self.mTF_Password.text];
        mcommanyID  = self.mTF_comanyID.text;
    }
    
    NSDictionary *mParamDic = @{@"account":accountStr,@"password":passStr,@"ecode":mcommanyID};
    [HttpApi login:mParamDic SuccessBlock:^(id responseBody) {
        NSMutableDictionary*userInfoDic = [NSMutableDictionary dictionaryWithDictionary:mParamDic];
        [userInfoDic setObject:responseBody[@"uname"] forKey:@"name"];
        [userInfoDic setObject:responseBody[@"userId"] forKey:@"userId"];
        [MyFounctions saveUserInfo:userInfoDic];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        [HttpApi getUserInfo:@{@"userId":sl_userID} isShowLoadingView:NO SuccessBlock:^(id responseBody) {
          //  LDLOG(@"用户信息 ==== %@",responseBody);
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseBody];
            [MyFounctions saveDetailUserInfo:userInfo];
            //获取详细信息
            [self getUserInfoNetWroking];
            
            NSString *regId = [JPUSHService registrationID];
            
            if (sl_userID && regId && regId.length>0) {
                NSDictionary *paramDic = @{@"userId":sl_userID,@"regid":[JPUSHService registrationID]};
                
                [HttpApi putRegJpush:paramDic SuccessBlock:^(id responseBody) {
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    
    } FailureBlock:^(NSError *error) {
        
    }];

}

- (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const  char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
}


- (IBAction)onclickForgetPwdBtn:(id)sender {
    SLRegisterVC *mRegisterVC = [[SLRegisterVC alloc]init];
    mRegisterVC.title = LDLocalizedString(@"forget password");
    [self.navigationController pushViewController:mRegisterVC animated:YES];
}
#pragma mark  prviate
-(void)allTFResignFirstResponder{
    [self.mTF_account resignFirstResponder];
    [self.mTF_Password resignFirstResponder];

}
-(void)setContentString{
    [self.mBtn_login setTitle:LDLocalizedString(@"login") forState:UIControlStateNormal];
    [self.mTF_account setPlaceholder:LDLocalizedString(@"Account")];
    [self.mTF_Password setPlaceholder:LDLocalizedString(@"Password")];
    [self.mBtn_forgetPwd setTitle:[LDLocalizedString(@"forget password") stringByAppendingString:@"?"] forState:UIControlStateNormal];
}
#pragma mark getter
-(UIImageView *)mBGImageView{
    if (_mBGImageView == nil) {
        _mBGImageView = [[UIImageView alloc]init];
      //  [_mBGImageView setBackgroundColor:SL_GRAY];
    }
    return _mBGImageView;
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
