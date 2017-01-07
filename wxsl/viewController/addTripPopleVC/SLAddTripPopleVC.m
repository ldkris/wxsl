//
//  SLAddTripPopleVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddTripPopleVC.h"
#import "SLAddCertificateVC.h"

#import "SLCUIdCardCell.h"
#import "SLDataPickerView.h"
#import "SLDatePickerView.h"
@interface SLAddTripPopleVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SLDataPickerViewDelegate,SLDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mDeparts;

@property(nonatomic,retain)NSMutableDictionary *mParamDic;
@end

@implementation SLAddTripPopleVC{

    NSString * _userName;
    NSString * _birthDay;
    NSDictionary * _departInfo;
    NSMutableArray *_IDsInfo;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"出行人";
   // [self  addSaveBarBtn];
    
    [self getDepartList];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    UITextField *temp = [self.view viewWithTag:11];
    UITextField *temp1 = [self.view viewWithTag:12];
    [temp resignFirstResponder];
    [temp1 resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if(_mDataSoure == nil){
        _mDataSoure = @[@[@"真实姓名",@"所属部门",@"出生日期"],[NSMutableArray arrayWithObjects:@"证件类型", nil]];
    }
    return _mDataSoure;
}
-(NSArray *)mDeparts{
    if (_mDeparts == nil) {
        _mDeparts = @[];
    }
    
    return _mDeparts;
}
-(NSMutableDictionary *)mParamDic{
    if (_mParamDic == nil) {
        _mParamDic = [NSMutableDictionary dictionary];
    }
    return _mParamDic;
}
#pragma mark  networking
-(void)getDepartList{
    [HttpApi getDepartList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
//        LDLOG(@"部门列表%@",responseBody);
        self.mDeparts = responseBody[@"departs"];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
#pragma  mark public
-(void)backInfoBlock:(void (^)(SLPassengerModel *, SLPassengerModel *))block{
    self.backBlocl = block;
}
#pragma mark private
-(void)addSaveBarBtn{
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mBtn setTitle:@"说明" forState:UIControlStateNormal];
    mBtn.frame = CGRectMake(0, 0, 50, 50);
    [mBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [mBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mBtn.titleLabel setTextColor:SL_GRAY_BLACK];
    [mBtn addTarget:self action:@selector(onclickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mSaveBtn = [[UIBarButtonItem alloc]initWithCustomView:mBtn];
    self.navigationItem.rightBarButtonItem = mSaveBtn;
}
#pragma mark event reponse
-(void)onclickAddIdCard:(UIButton *)sender{
    LDLOG(@"增加证件");
    SLAddCertificateVC *mAddCerVC = [[SLAddCertificateVC alloc]init];
    [self.navigationController pushViewController:mAddCerVC animated:YES];
    
    if (_IDsInfo == nil) {
        _IDsInfo = [NSMutableArray array];
    }
    
    [mAddCerVC backIdInfo:^(NSDictionary *IDInfoDIc) {
        [_IDsInfo addObject:IDInfoDIc];
        NSMutableArray *temp = self.mDataSoure[1];
        [temp insertObject:IDInfoDIc atIndex:[temp count]];
        [self.mInfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
-(void)onclickSaveBtn:(UIButton *)sender{
   
    UITextField *nameTF = [self.view viewWithTag:10];
    UITextField *DTF = [self.view viewWithTag:11];
    UITextField *Btf = [self.view viewWithTag:12];
    
    if (nameTF.text == nil || nameTF.text.length == 0) {
        ShowMSG(@"请输入姓名");
        return;
    }
    
    if (DTF.text == nil || DTF.text.length == 0) {
        ShowMSG(@"请输入所属部门");
        return;
    }
    
    if (Btf.text == nil || Btf.text.length == 0) {
        ShowMSG(@"请输入出生日期");
        return;
    }
    
    if ([self.mDataSoure[1] count] == 1) {
        ShowMSG(@"请添加证件");
        return;
    }
    
    NSMutableArray *mdocTypes = [NSMutableArray array];
    
    for (NSDictionary *temoDic in _IDsInfo) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:temoDic];
        [dic removeObjectForKey:@"IDname"];
        [mdocTypes addObject:dic];
    }
    
    if (mdocTypes.count == 0 || mdocTypes == nil) {
        return;
    }
    
    NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
    
    if (self.mPassenger) {
        if (self.mPassenger && self.backBlocl && _IDsInfo) {
            NSDictionary *info = _IDsInfo[0];
            
            self.mPassenger.mIDType = info[@"type"];
            self.mPassenger.mIdcard = info[@"no"];
            self.backBlocl(self.mPassenger,self.mPassenger);
            
            NSDictionary *mParam = @{@"userId":self.mPassenger.mID,@"name":self.mPassenger.mName,@"dno":[self.mPassenger.mDID stringValue],@"dname":self.mPassenger.mName,@"birth":_birthDay,@"docTypes":string};
            
            [HttpApi putTravelPeople:mParam SuccessBlock:^(id responseBody) {
                LDLOG(@"新增联系人：%@",responseBody);
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } FailureBlock:^(NSError *error) {
                
            }];
        }
        
        return;
    }
    
    if (self.mUsermodel) {
        if (self.mUsermodel && self.mUsermodel && _IDsInfo) {
            NSDictionary *info = _IDsInfo[0];
            SLPassengerModel *mPassenger = [[SLPassengerModel alloc]init];
            mPassenger.mName = self.mUsermodel.mChineseName;
            mPassenger.mID = sl_userID;
            mPassenger.mDID = self.mUsermodel.mDid;
            mPassenger.mDname = self.mUsermodel.mDName;
            mPassenger.mIDType = info[@"type"];
            mPassenger.mIdcard = info[@"no"];
           
            NSDictionary *mParam = @{@"userId":mPassenger.mID,@"name":mPassenger.mName,@"dno":[mPassenger.mDID stringValue],@"dname":mPassenger.mName,@"birth":_birthDay,@"docTypes":string};
            
            [HttpApi putTravelPeople:mParam SuccessBlock:^(id responseBody) {
//                LDLOG(@"新增联系人：%@",responseBody);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                     self.backBlocl(mPassenger,mPassenger);
                });
            } FailureBlock:^(NSError *error) {
                
            }];
        }
        
        return;
    }
    
    NSDictionary *mParam = @{@"userId":sl_userID,@"name":_userName,@"dno":_departInfo[@"no"],@"dname":_departInfo[@"name"],@"birth":_birthDay,@"docTypes":string};
    
    [HttpApi putTravelPeople:mParam SuccessBlock:^(id responseBody) {
        LDLOG(@"新增联系人：%@",responseBody);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
        });
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
#pragma mark SLDataPickerViewDelegate
-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    UITextField *temp = [self.view viewWithTag:11];
    NSDictionary *tempDic = (NSDictionary *)str;
    temp.text = tempDic[@"name"] ;
    
    _departInfo = tempDic;
}
#pragma mark SLDatePickerViewDelegate
-(void)SLDatePickerView:(SLDatePickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    UITextField *temp1 = [self.view viewWithTag:12];
    temp1.text = str ;
    _birthDay = str;
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidChange:(UITextField *)textField{

    _userName = textField.text;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 10) {
        
    }
    
    UITextField *tempTextFiled = [self.view viewWithTag:10];
    [tempTextFiled resignFirstResponder];
    
    if (textField.tag == 11) {
        SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
        mPickerView.delegate = self;
        if (self.mDeparts.count >0) {
            mPickerView.mPickerDataSoure = self.mDeparts;
        }
        mPickerView.mLB_title.text = @"所属部门";
        [self.view addSubview:mPickerView];
        [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        
        return NO;
    }
    
    if (textField.tag == 12) {
        SLDatePickerView *mDatePickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
        mDatePickerView.delegate = self;
        mDatePickerView.mLB_title.text = @"选择出生日期";
        mDatePickerView.mPicker.datePickerMode = UIDatePickerModeDate;
        [self.view addSubview:mDatePickerView];
        [mDatePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   

}
#pragma mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.00f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100.0f;
    }
    return 0.01f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        
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
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //证件
        static NSString *cellIndetifier = @"SLCUIdCardCell";
        [tableView registerNib:[UINib nibWithNibName:@"SLCUIdCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndetifier];
        SLCUIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        cell.mLB_IdCardNum.text = self.mDataSoure[indexPath.section][indexPath.row][@"no"];
        NSString *temp =[NSString stringWithFormat:@"%@ - %@", self.mDataSoure[indexPath.section][indexPath.row][@"startTime"], self.mDataSoure[indexPath.section][indexPath.row][@"endTime"]];
        cell.mLB_Time.text = temp;
        cell.mLB_CardType.text =self.mDataSoure[indexPath.section][indexPath.row][@"IDname"];
        return cell;
    }
    
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
    }
    
    cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0) {
        UITextField *mNameTF = [[UITextField alloc]init];
        mNameTF.delegate = self;
        mNameTF.tag = 10 +indexPath.row;
        [mNameTF setFont:DEFAULT_FONT(13)];
        mNameTF.placeholder = [NSString stringWithFormat:@"请输入%@",self.mDataSoure[indexPath.section][indexPath.row]];
        [mNameTF setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
        [cell.contentView addSubview:mNameTF];
        [mNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(1);
        }];
        
        if (self.mPassenger) {
            NSArray *temp = @[self.mPassenger.mName,self.mPassenger.mDname];
            if (indexPath.row<2) {
                mNameTF.text = temp[indexPath.row];
            }
        }
        
        if (self.mUsermodel) {
            NSArray *temp = @[self.mUsermodel.mChineseName,self.mUsermodel.mDName];
            if (indexPath.row<2) {
                mNameTF.text = temp[indexPath.row];
            }
        }
    
        if (indexPath.row == 0) {
            [mNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    //self.mUserInfo[indexPath.section][indexPath.row];
    [cell.detailTextLabel setFont:DEFAULT_FONT(15)];
    [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 1 && indexPath.row == 0) {
        //增加证件
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mAddBtn setFrame:CGRectMake(0, 0, 25, 25)];
        [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
        [mAddBtn addTarget:self action:@selector(onclickAddIdCard:) forControlEvents:UIControlEventTouchUpInside];
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
