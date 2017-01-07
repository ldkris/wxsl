//
//  SLAddAddressVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddAddressVC.h"

@interface SLAddAddressVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation SLAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.backgroundColor = SL_GRAY;
    
    self.title = @"新增地址";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
-(NSArray *)mDataSoure{
    if(_mDataSoure == nil){
        _mDataSoure = @[@"收件人",@"联系方式",@"地区",@"详细地址",@"邮编"];
    }
    return _mDataSoure;
}
#pragma mark event response
- (void)onclickSaveBtn:(UIButton *)sender {
    
    UITextView *tempName = [self.view viewWithTag:10];
    UITextView *tempPhone = [self.view viewWithTag:11];
    UITextView *tempArea = [self.view viewWithTag:12];
    UITextView *tempAddress = [self.view viewWithTag:13];
    UITextView *tempCode = [self.view viewWithTag:14];
    
    if (tempName.text == nil || tempName.text.length == 0) {
        ShowMSG(@"请输入收件人姓名");
        return;
    }
    if (tempPhone.text == nil || tempPhone.text.length == 0) {
        ShowMSG(@"请输入联系方式");
        return;
    }
    if (tempArea.text == nil || tempArea.text.length == 0) {
        ShowMSG(@"请输入地区");
        return;
    }
    if (tempAddress.text == nil || tempAddress.text.length == 0) {
        ShowMSG(@"请输入详细地址");
        return;
    }
    
    if (tempCode.text == nil || tempCode.text.length == 0) {
        ShowMSG(@"请输入邮编");
        return;
    }

    NSDictionary *paramDic = @{@"userId":sl_userID,@"shipMethod":@"2",@"recipients":tempName.text,@"contact":tempPhone.text,@"area":tempArea.text,@"address":tempAddress.text,@"zipcode":tempCode.text};
    
    [HttpApi putDeliverAddr:paramDic SuccessBlock:^(id responseBody) {
        LDLOG(@"新增地址====%@",responseBody);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidChange:(UITextField *)textField{
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

}
#pragma mark UITableViewDataSource && UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.00f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 100.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *mComfir = [UIButton buttonWithType:UIButtonTypeCustom];
    [mComfir setTitle:@"保存" forState:UIControlStateNormal];
    [mComfir setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mComfir addTarget:self action:@selector(onclickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mComfir.titleLabel setFont:DEFAULT_FONT(15)];
    [mComfir setBackgroundColor:SL_BULE];
    [mComfir.layer setMasksToBounds:YES];
    [mComfir.layer setCornerRadius:2.0f];
    
    [footView addSubview:mComfir];
    [mComfir mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(45);
    }];
    
    return footView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
    }
    
    cell.textLabel.text = self.mDataSoure[indexPath.row];
    
    UITextField *mNameTF = [[UITextField alloc]init];
    mNameTF.delegate = self;
    mNameTF.tag = 10 +indexPath.row;
    [mNameTF setFont:DEFAULT_FONT(13)];
    mNameTF.placeholder = [NSString stringWithFormat:@"请输入%@",self.mDataSoure[indexPath.row]];
    [mNameTF setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [cell.contentView addSubview:mNameTF];
    [mNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(90);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(1);
    }];
    
    
    [mNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    //self.mUserInfo[indexPath.section][indexPath.row];
    
    [cell.detailTextLabel setFont:DEFAULT_FONT(15)];
    [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
    
//    if (indexPath.row == 2) {
//        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
//    }
   
    if (indexPath.section == 1 && indexPath.row == 0) {
        //增加证件
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mAddBtn setFrame:CGRectMake(0, 0, 25, 25)];
        [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
        [mAddBtn addTarget:self action:@selector(onclickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = mAddBtn;
    }
    
    return cell;
    
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
