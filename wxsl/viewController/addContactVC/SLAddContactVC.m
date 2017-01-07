//
//  SLAddContactVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/20.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddContactVC.h"

@interface SLAddContactVC ()
@property (weak, nonatomic) IBOutlet UITextField *mTF_Name;
@property (weak, nonatomic) IBOutlet UITextField *mTF_phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_comfir;

@end

@implementation SLAddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新增加联系人";
    self.view.backgroundColor = SL_GRAY;
    
    self.btn_comfir.layer.masksToBounds = YES;
    self.btn_comfir.layer.cornerRadius = 2;
}
#pragma mark event response
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    if (self.mTF_Name.text == nil || self.mTF_Name.text.length == 0) {
        ShowMSG(@"请输入联系人姓名");
        return;
    }
    if (self.mTF_phoneNum.text == nil || self.mTF_phoneNum.text.length == 0) {
        ShowMSG(@"请输入联系人电话");
        return;
    }
    
    
    NSDictionary *mParamDic = @{@"userId":sl_userID,@"name":self.mTF_Name.text ,@"contact":self.mTF_phoneNum.text};
    [HttpApi putNewContact:mParamDic SuccessBlock:^(id responseBody) {
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
        });
    
    } FailureBlock:^(NSError *error) {
        
    }];
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
