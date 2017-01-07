//
//  SLAddCertificateVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddCertificateVC.h"

#import "SLDataPickerView.h"
#import "SLDatePickerView.h"
@interface SLAddCertificateVC ()<SLDataPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *mTF_CerType;
@property (weak, nonatomic) IBOutlet UITextField *mTF_CerNum;
@property (weak, nonatomic) IBOutlet UITextField *mTF_Time;
@property (weak, nonatomic) IBOutlet UITextField *mTF_endTime;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfir;

@end

@implementation SLAddCertificateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"增加证件";
    self.view.backgroundColor = SL_GRAY;
    
    [self.mBtn_comfir.layer setMasksToBounds:YES];
    [self.mBtn_comfir.layer setCornerRadius:5];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark public
-(void)backIdInfo:(chooseDate)block{
    self.mIDInfoDIcBlock = block;
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self allTFResignFirstResponder];
    
    if (textField == self.mTF_CerType) {
        SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
        mPickerView.delegate = self;
        mPickerView.mPickerDataSoure = @[@"身份证",@"护照",@"军人证",@"回乡证",@"港澳通行证",@"台胞证",@"其他"];
        mPickerView.mLB_title.text = @"选择证件类型";
        [self.view addSubview:mPickerView];
        [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
         return NO;
    }else{
        SLDatePickerView *mDatePickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
        mDatePickerView.delegate = self;
        mDatePickerView.tag = textField.tag;
        mDatePickerView.mLB_title.text = @"选择有效期";
        mDatePickerView.mPicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:mDatePickerView];
        [mDatePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
         return NO;
    }

    return YES;
}

#pragma mark SLDataPickerViewDelegate
-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    LDLOG(@"%@",str);
    self.mTF_CerType.text = str;
}
#pragma mark SLDatePickerViewDelegate
-(void)SLDatePickerView:(SLDatePickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    LDLOG(@"%@",str);
    
    if (view.tag ==11) {
        self.mTF_endTime.text = str;
        return;
    }
    self.mTF_Time.text = str;
}
#pragma mark event response
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    if (self.mTF_CerType.text== nil  ||  self.mTF_CerType.text.length==0) {
        ShowMSG(@"请输入证件类型");
        return;
    }
    
    if (self.mTF_Time.text== nil  ||  self.mTF_Time.text.length==0) {
        ShowMSG(@"请输入证件有效开始时间");
        return;
    }
    
    if (self.mTF_endTime.text== nil  ||  self.mTF_endTime.text.length==0) {
        ShowMSG(@"请输入证件有效结束时间");
        return;
    }
    
    if (self.mTF_CerNum.text== nil  || self.mTF_CerNum.text.length==0) {
        ShowMSG(@"请输入证件号");
        return;
    }
    
    
    NSMutableDictionary *tempInfo = [NSMutableDictionary dictionary];
    NSDictionary *tempDci = @{@"身份证":@"1",@"护照":@"2",@"军人证":@"3",@"回乡证":@"4",@"港澳通行证":@"5",@"台胞证":@"6",@"其他":@"0"};
    [tempInfo setObject:tempDci[self.mTF_CerType.text] forKey:@"type"];
    [tempInfo setObject:self.mTF_CerType.text forKey:@"IDname"];
    [tempInfo setObject:self.mTF_CerNum.text forKey:@"no"];
    [tempInfo setObject:self.mTF_Time.text forKey:@"startTime"];
    [tempInfo setObject:self.mTF_Time.text forKey:@"endTime"];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.mIDInfoDIcBlock) {
        self.mIDInfoDIcBlock(tempInfo);
    }
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
