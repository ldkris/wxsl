//
//  SLTicketAlterationInfoVC.m
//  wxsl
//
//  Created by 刘冬 on 16/8/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTicketAlterationInfoVC.h"
#import "SLFIInputCell.h"

#import "SLDataPickerView.h"
#import "SLDatePickerView.h"
@interface SLTicketAlterationInfoVC ()<UITableViewDataSource,UITableViewDelegate,SLDataPickerViewDelegate,SLDatePickerViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;

@property(nonatomic,retain)NSMutableDictionary *mInfoDic;
@end

@implementation SLTicketAlterationInfoVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.tableFooterView = [UIView new];
    
    self.title = @"填写航班信息";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"起飞时间",@"到达时间",@"起飞机场",@"到达机场",@"航班日期",@"航空公司名称",@"航班等级"];
    }
    return _mDataSoure;
}
-(NSMutableDictionary *)mInfoDic{
    if (_mInfoDic == nil) {
        _mInfoDic = [NSMutableDictionary dictionary];
    }
    return _mInfoDic;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)backInfo:(void (^)(NSDictionary *))block{
    self.backInfoBlock = block;
}
-(void)onclickcomfirBtn:(UIButton *)sender{
    
    for ( SLFIInputCell *cell in [self.mInfoTableView visibleCells]) {
        if (cell.mTF_input.text==nil || cell.mTF_input.text.length == 0) {
            NSString *str =[NSString stringWithFormat:@"%@不能为空",cell.mLB_title.text];
            ShowMSG(str);
            return;
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.backInfoBlock) {
        self.backInfoBlock(self.mInfoDic);
    }
}
#pragma mark UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [UIView new];
    [footView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *mComfir = [UIButton buttonWithType:UIButtonTypeCustom];
    [mComfir setTitle:@"确  定" forState:UIControlStateNormal];
    [mComfir setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mComfir addTarget:self action:@selector(onclickcomfirBtn:) forControlEvents:UIControlEventTouchUpInside];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLFIInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInputCell"];
    SLFIInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInputCell"];
    cell.mTF_input.tag = 10+indexPath.row;
    cell.mTF_input.delegate = (id)self;
    [cell.mTF_input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [cell.mLB_title setText:self.mDataSoure[indexPath.row]];
    cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",self.mDataSoure[indexPath.row]];
    return cell;
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    for (  SLFIInputCell *cell in self.mInfoTableView.visibleCells) {
        [cell.mTF_input resignFirstResponder];
    }

    switch (textField.tag) {
        case 10:{
            SLDatePickerView *mDatePickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
            mDatePickerView.delegate = self;
            mDatePickerView.tag = textField.tag;
            mDatePickerView.mPicker.datePickerMode = UIDatePickerModeTime;
            mDatePickerView.mLB_title.text = @"选择日期";
          //  mDatePickerView.mPicker.datePickerMode = UIDatePickerModeDate;
            [self.navigationController.view addSubview:mDatePickerView];
            [mDatePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            return NO;
            break;}
            
        case 11:{
            SLDatePickerView *mDatePickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
            mDatePickerView.delegate = self;
            mDatePickerView.tag = textField.tag;
            mDatePickerView.mLB_title.text = @"选择日期";
            mDatePickerView.mPicker.datePickerMode = UIDatePickerModeTime;
            [self.navigationController.view addSubview:mDatePickerView];
            [mDatePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            return NO;
            break;}
            
        case 14:{
            SLDatePickerView *mDatePickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
            mDatePickerView.delegate = self;
            mDatePickerView.tag = textField.tag;
            mDatePickerView.mLB_title.text = @"选择日期";
            mDatePickerView.mPicker.datePickerMode = UIDatePickerModeDate;
            [self.navigationController.view addSubview:mDatePickerView];
            [mDatePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            return NO;
            break;}
            
        case 16:{
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.delegate = self;
            mPickerView.tag = textField.tag;
            mPickerView.mPickerDataSoure = @[@"头等舱",@"经济舱",@"商务舱"];
            mPickerView.mLB_title.text = @"选择舱位";
            [self.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
            return NO;
            break;}
            
        default:
            break;
    }
    return YES;
}
- (void)textFieldDidChange:(UITextField *) textField {
    
    SLFIInputCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag - 10 inSection:0]];
    cell.mTF_input.text = textField.text;
    
    switch (textField.tag) {
        case 12:
            [self.mInfoDic setObject:textField.text forKey:@"depAirport"];
            break;
        case 13:
             [self.mInfoDic setObject:textField.text forKey:@"arrAirport"];
            break;
        case 15:
             [self.mInfoDic setObject:textField.text forKey:@"airline"];
            break;
            
        default:
            break;
    }
   
}
#pragma mark SLDatePickerViewDelegate
-(void)SLDatePickerView:(SLDatePickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    
    if (view.tag == 14) {
        SLFIInputCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:view.tag - 10 inSection:0]];
        cell.mTF_input.text = str;

        [self.mInfoDic setObject:str forKey:@"flightDate"];
    }
}
-(void)SLDatePickerView:(SLDatePickerView *)view onclickCompleBtn:(UIButton *)sender SelectedTimeStr:(NSString *)str{
    if (view.tag != 14) {
        SLFIInputCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:view.tag - 10 inSection:0]];
        cell.mTF_input.text = str;
    }
    
    
    switch (view.tag) {
        case 10:
            [self.mInfoDic setObject:str forKey:@"depTime"];
            break;
        case 11:
            [self.mInfoDic setObject:str forKey:@"arrTime"];
            break;
            
        default:
            break;
    }
}
-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    
    SLFIInputCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:view.tag - 10 inSection:0]];
    cell.mTF_input.text = str;
    
    NSArray *tempArray = @[@"头等舱",@"经济舱",@"商务舱"];
    NSString *mCount = [NSString stringWithFormat:@"%lu",(unsigned long)[tempArray indexOfObject:str]];
    [self.mInfoDic setObject:mCount forKey:@"cabin"];
}
@end
