//
//  SLRegisterVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLRegisterVC.h"

#import "SLForgetPwdVC.h"
@interface SLRegisterVC ()
@property (weak, nonatomic) IBOutlet UILabel *mLB_phoneNum;
@property (weak, nonatomic) IBOutlet UILabel *mLBverCode;
@property (weak, nonatomic) IBOutlet UITextField *mTF_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *mTF_verCode;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_getVerCode;
@property (weak, nonatomic) IBOutlet UIView *mMarkView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfir;
@property (weak, nonatomic) IBOutlet UITextField *mTF_commanyName;

@end

@implementation SLRegisterVC{

    NSString *_mVerCodeStr;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional seup after loading the view from its nib.
    self.view.backgroundColor = SL_GRAY;
    
    [self.mBtn_comfir.layer setMasksToBounds:YES];
    [self.mBtn_comfir.layer setCornerRadius:5];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mMarkView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
    }];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self setcontenString];
    self.title = @"忘记密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark private
-(void)setcontenString{
    [self.mLBverCode setText:LDLocalizedString(@"Verification code")];
    [self.mLB_phoneNum setText:LDLocalizedString(@"Mobile NO")];
    [self.mTF_phoneNum setPlaceholder:LDLocalizedString(@"enterphonenumber")];
    [self.mTF_verCode setPlaceholder:LDLocalizedString(@"entercode")];
}

#pragma mark event response
- (IBAction)onclickGetCodeBtn:(id)sender {
 
    NSDictionary *mTempDic;
    
    if (isTest) {
        mTempDic = @{@"mobile":self.mTF_phoneNum.text};
    }else{
        if (self.mTF_phoneNum.text.length == 0 || self.mTF_phoneNum.text == nil) {
            ShowMSG(@"请输入手机号码！");
            return;
        }
        
         mTempDic = @{@"mobile":@"15002380001"};
    }
    
    
    [HttpApi getMobileVcode:mTempDic SuccessBlock:^(id responseBody) {
        
        LDLOG(@"验证码 ===== %@",responseBody[@"vcode"]);
        _mVerCodeStr = responseBody[@"vcode"];
        [MyFounctions startTime:sender];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
}
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    NSDictionary *mParaDic ;
    if (isTest) {
        mParaDic = @{@"ecode":@"51429",@"mobile":@"15002380001"};
    }else{
        if (_mVerCodeStr == nil ||_mVerCodeStr.length == 0) {
            ShowMSG(@"请先后去验证码！");
            return;
        }
        
        if (self.mTF_verCode.text == nil || self.mTF_verCode.text.length == 0) {
            ShowMSG(@"请输入验证码！");
            return;
        }
        
        if (self.mTF_verCode.text != _mVerCodeStr) {
            ShowMSG(@"请输入正确的验证码！");
            return;
        }
        
        mParaDic = @{@"ecode":self.mTF_verCode.text,@"mobile":self.mTF_phoneNum.text};
    }
    
    [HttpApi validateInfo:mParaDic SuccessBlock:^(id responseBody) {
        LDLOG(@"%@",responseBody);
        
        SLForgetPwdVC *mTempVC = [[SLForgetPwdVC alloc]init];
        mTempVC.mUserID = responseBody[@"userId"];
        [self.navigationController pushViewController:mTempVC animated:YES];

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
