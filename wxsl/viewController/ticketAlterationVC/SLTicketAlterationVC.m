//
//  SLTicketAlterationVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTicketAlterationVC.h"
#import "SLsdPopleInfoCell.h"
#import "SLtaFihhtInfoCell.h"
#import "SLtaInputCell.h"

#import "SLTicketAlterationInfoVC.h"
#import "SLCommonPassengerVC.h"
@interface SLTicketAlterationVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

@property(nonatomic,retain)NSMutableDictionary *mParamDic;
@end

@implementation SLTicketAlterationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"改签申请";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark gtter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        NSMutableArray *mpassengers = [NSMutableArray arrayWithArray:self.mOderDetialModel.passengers];
        [mpassengers insertObject:@"" atIndex:0];
        _mDataSoure = [NSMutableArray arrayWithArray:@[mpassengers,@[@"",@""],@[@""]]];
    }
    return _mDataSoure;
}
-(NSMutableDictionary *)mParamDic{
    if (_mParamDic == nil) {
        NSMutableArray *temp = [NSMutableArray array];
        
        for (NSDictionary *dic in self.mOderDetialModel.passengers) {
            [temp addObject:dic[@"pid"]];
        }
        
        //乘客
        NSData *mData1 = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
        NSString *passString = [[NSString alloc]initWithData:mData1 encoding:NSUTF8StringEncoding];
        
        _mParamDic = [NSMutableDictionary dictionary];
        [_mParamDic setObject:passString forKey:@"pids"];
        [_mParamDic setObject:sl_userID forKey:@"userId"];
        [_mParamDic setObject:self.mOderModel.mOderId forKey:@"orderId"];
    }
    
    return _mParamDic;
}
#pragma mark event response
//改签
- (void)onclickGQBtn:(UIButton *)sender {
    
    NSArray *allKeys = [self.mParamDic allKeys];
    if (![allKeys containsObject:@"depTime"]) {
        ShowMSG(@"请选择你想要的航班");
        return;
    }
    
    
    SLtaInputCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NSString *reasonStr = cell.textView.text;
    if (reasonStr== nil || reasonStr.length==0) {
        ShowMSG(@"请输入改签的理由");
        return;
    }
    
    [self.mParamDic setObject:reasonStr forKey:@"reason"];
    
    [HttpApi changeTicket:self.mParamDic SuccessBlock:^(id responseBody) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    // [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section ==2){
        return 120.0f;
    }
    
    return 5.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if(section ==2){
        UIView *mFootterView = [UIView new];
        [mFootterView setBackgroundColor:SL_GRAY];
        
        UIButton *mSQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mSQBtn setBackgroundColor:SL_BULE];
        [mSQBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [mSQBtn.titleLabel setFont:DEFAULT_FONT(14)];
        [mSQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mSQBtn.layer setMasksToBounds:YES];
        [mSQBtn.layer setCornerRadius:5.0f];
        [mSQBtn addTarget:self action:@selector(onclickGQBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mFootterView addSubview:mSQBtn];
        [mSQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(35);
        }];
        return mFootterView;
    }
    
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row>0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        [cell.mLb_phoneNum setTextColor:SL_GRAY_Hard];
        [cell.mLb_phoneNum setText:self.mDataSoure[indexPath.section][indexPath.row][@"no"]];
        [cell.mLb_name setText:self.mDataSoure[indexPath.section][indexPath.row][@"name"]];
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row>0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLtaFihhtInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLtaFihhtInfoCell"];
        SLtaFihhtInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLtaFihhtInfoCell"];
        [cell loadCellInfoWithModel:self.mOderModel withDetalModel:self.mOderDetialModel];
        return cell;
    }
    
    if (indexPath.section == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"SLtaInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLtaInputCell"];
        SLtaInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLtaInputCell"];
        return cell;
    }
    
    
    NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setText:@[@"选择乘客",@"选择航班",@""][indexPath.section]];
        [cell.textLabel setFont:DEFAULT_FONT(13)];
        [cell.textLabel setTextColor:SL_GRAY_BLACK];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SLCommonPassengerVC *mTempVC = [[SLCommonPassengerVC alloc]init];
        mTempVC.title = @"选择乘客";
        mTempVC.mOderDataSoure = self.mOderDetialModel.passengers;
        [self.navigationController pushViewController:mTempVC animated:YES];
        [mTempVC backInfoBlock:^(NSDictionary *info) {
            SLsdPopleInfoCell *cell  = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
            [cell.mLb_phoneNum setText:info[@"no"]];
            [cell.mLb_name setText:info[@"name"]];
            
            NSArray *temp = @[info[@"pid"]];
            
            NSData *mData1 = [NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
            NSString *passString = [[NSString alloc]initWithData:mData1 encoding:NSUTF8StringEncoding];
            
            [self. mParamDic setObject:passString forKey:@"pids"];
            
        }];
    }
    if (indexPath.section == 1) {
        SLTicketAlterationInfoVC *tempVC = [[SLTicketAlterationInfoVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
        [tempVC backInfo:^(NSDictionary *info) {
            for (NSString *key in [info allKeys]) {
                [self.mParamDic setValue:info[key] forKey:key];
            }
        }];
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
