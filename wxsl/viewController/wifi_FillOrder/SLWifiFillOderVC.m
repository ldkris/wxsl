//
//  SLWifiFillOderVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiFillOderVC.h"

#import "SLWifiFillOderCell.h"
#import "SLWifiNumCell.h"

#import "SLFinishVC.h"
#import "SLWifiBZVC.h"
#import "SLWifiGetPalceVC.h"
#import "SLWifiInputInfo.h"
#import "ZFChooseTimeViewController.h"
@interface SLWifiFillOderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mCellDataSoure;
@property (weak, nonatomic) IBOutlet UILabel *lab_aonmt;

@property(nonatomic,retain)NSMutableDictionary *mParaInfoDic;
@end

@implementation SLWifiFillOderVC{

    NSString *param_GetDate;
    NSString *param_BackDate;
    NSString *param_GetAir;
    NSString *param_GetNum;
    NSString *param_Bz;
    NSString *param_Name;
    NSString *param_PhoneNum;
    NSString *param_BackAir;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订单填写";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    
    self.mInfoTableView.delegate = self;
    self.mInfoTableView.dataSource = self;
    
    param_GetNum = @"1";
    self.lab_aonmt.text = [NSString stringWithFormat:@"%d",500+[self.mWifiDetailMoel.mPrice intValue]*[param_GetNum intValue]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableDictionary *)mParaInfoDic{
    if (_mParaInfoDic == nil) {
        _mParaInfoDic = [NSMutableDictionary dictionary];
    }
    return _mParaInfoDic;
}
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"",@"出行信息/备注/特殊要求",@"联系信息"];
    }
    return _mDataSoure;
}
-(NSArray *)mCellDataSoure{
    if (_mCellDataSoure == nil) {
        _mCellDataSoure = @[@[@"",@"取件日期",@"还件日期",@"取件机场",@"还件机场",@"预订台数"],@[@"如前往北海道道或冲绳请备注"],@[@"取件人",@"取件人手机"]];
    }
    return _mCellDataSoure;
}
#pragma mark event response
- (IBAction)onclickPayBtn:(UIButton *)sender {
    
    
    if (param_GetDate == nil && param_GetDate.length == 0) {
        ShowMSG(@"请输入取件时间!!");
        return;
    }
    
    if (param_BackDate == nil && param_BackDate.length == 0) {
        ShowMSG(@"请输入还件时间!!");
        return;
    }
    
    if (param_GetAir == nil && param_GetAir.length == 0) {
        ShowMSG(@"请输入取件机场!!");
        return;
    }
    if (param_BackAir == nil && param_BackAir.length == 0) {
        ShowMSG(@"请输入还件机场!!");
        return;
    }
    
    if (param_Name == nil && param_Name.length == 0) {
        ShowMSG(@"请输入取件人姓名!!");
        return;
    }
    
    if (param_PhoneNum == nil && param_PhoneNum.length == 0) {
        ShowMSG(@"请输入取件人手机!!");
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setValue:param_GetDate forKey:@"useDate"];
    [paramDic setValue:param_BackDate forKey:@"useEndDate"];
    [paramDic setValue:param_GetAir forKey:@"takeAddress"];
    [paramDic setValue:param_BackAir forKey:@"returnAddress"];
    [paramDic setValue:param_GetNum forKey:@"count"];
    [paramDic setValue:param_Name forKey:@"contactName"];
    [paramDic setValue:param_PhoneNum forKey:@"contactMobile"];
    [paramDic setValue:sl_userID forKey:@"userId"];
    [paramDic setValue:self.mWifiDetailMoel.mPid forKey:@"productId"];
    
    if(param_Bz && param_Bz.length>0){
        [paramDic setValue:param_Bz forKey:@"remark"];
    }

    //LDLOG(@"%@",paramDic);
    
    [[SLNetWorkingHelper shareNetWork]putWifiOrder:paramDic SuccessBlock:^(id responseBody) {
        
        SLFinishVC *mTempVC = [[SLFinishVC alloc]init];
        //    mTempVC.orderNo = responseBody[@"orderNo"];
        //    mTempVC.mCreateTime = responseBody[@"createTime"];
        //    mTempVC.paytimeout = responseBody[@"paytimeout"];
        mTempVC.audit = @"2";
        mTempVC.mPirceStr =  self.lab_aonmt.text;
        [self.navigationController pushViewController:mTempVC animated:YES];
    } FailureBlock:^(NSError *error) {
        
    }];
    
    

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mCellDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001f;
    }
    
    return 40.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *mHeadView=  [UIView new];
    UILabel *mLable = [[UILabel alloc]init];
    [mLable setText:self.mDataSoure[section]];
    [mLable setFont:[UIFont systemFontOfSize:13.0f]];
    [mHeadView addSubview:mLable];
    [mLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(13);
    }];
    
    return mHeadView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section ==0 && indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLWifiFillOderCell" bundle:nil] forCellReuseIdentifier:@"SLWifiFillOderCell"];
        SLWifiFillOderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiFillOderCell"];
        cell.mlb_yj.text = [NSString stringWithFormat:@"￥%@/台",[self.mWifiDetailMoel.mDeposit stringValue]];
        cell.mlb_name.text = [NSString stringWithFormat:@"%@Wifi租赁",self.mWifiDetailMoel.mName];
        return cell;
    }
    
    if (indexPath.section == 0 && indexPath.row == 5) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SLWifiNumCell" bundle:nil] forCellReuseIdentifier:@"SLWifiNumCell"];
        SLWifiNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiNumCell"];
        [cell block_Jia:^{
            param_GetNum = cell.lab_num.text;
            self.lab_aonmt.text = [NSString stringWithFormat:@"%d",500+[self.mWifiDetailMoel.mPrice intValue]*[param_GetNum intValue]];
        }];
        [cell block_Jian:^{
            param_GetNum = cell.lab_num.text;
            self.lab_aonmt.text = [NSString stringWithFormat:@"%d",500+[self.mWifiDetailMoel.mPrice intValue]*[param_GetNum intValue]];
        }];
        return cell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.mCellDataSoure[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 1) {
        cell.textLabel.textColor = RGBACOLOR(153, 153, 153, 1);
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    __weak __typeof(UITableViewCell *)weakSelf = cell;
    if(indexPath.section == 0){
        if (indexPath.row == 1) {
            //取件
            ZFChooseTimeViewController * vc =[ZFChooseTimeViewController new];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            
            [vc backDate:^(NSArray *selectArray) {
                NSMutableString *mSelectTime = [NSMutableString string]; //= [selectArray componentsJoinedByString:@""];
                
                for (NSString *temp in selectArray) {
                    if ([selectArray indexOfObject:temp] == 0) {
                        [mSelectTime appendFormat:@"%@",temp];
                    }else{
                        [mSelectTime appendFormat:@"-%@",temp];
                    }
                }
                weakSelf.detailTextLabel.text = mSelectTime;
                param_GetDate = mSelectTime;
            }];
        }
        
        if (indexPath.row == 2) {
            //还件
            ZFChooseTimeViewController * vc =[ZFChooseTimeViewController new];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            
            [vc backDate:^(NSArray *selectArray) {
                NSMutableString *mSelectTime = [NSMutableString string]; //= [selectArray componentsJoinedByString:@""];
                
                for (NSString *temp in selectArray) {
                    if ([selectArray indexOfObject:temp] == 0) {
                        [mSelectTime appendFormat:@"%@",temp];
                    }else{
                        [mSelectTime appendFormat:@"-%@",temp];
                    }
                }
                 weakSelf.detailTextLabel.text = mSelectTime;
                 param_BackDate = mSelectTime;
            }];
        }
        if (indexPath.row == 3) {
            SLWifiGetPalceVC *mTempVC = [[SLWifiGetPalceVC alloc]init];
            mTempVC.mDataSoure = self.mWifiDetailMoel.mPlaces;
            [self.navigationController pushViewController:mTempVC animated:YES];
            [mTempVC backDataBlock:^(NSDictionary *selectDic) {
                weakSelf.detailTextLabel.text = selectDic[@"name"];
                param_GetAir = [selectDic[@"placeId"] stringValue];
            }];
        }
        
        if (indexPath.row == 4) {
            SLWifiGetPalceVC *mTempVC = [[SLWifiGetPalceVC alloc]init];
            mTempVC.mDataSoure = self.mWifiDetailMoel.mPlaces;
            [self.navigationController pushViewController:mTempVC animated:YES];
            [mTempVC backDataBlock:^(NSDictionary *selectDic) {
                weakSelf.detailTextLabel.text = selectDic[@"name"];
                param_BackAir = [selectDic[@"placeId"] stringValue];
            }];
        }
    
    }
    
    if (indexPath.section == 2) {
        SLWifiInputInfo *tempVC = [[SLWifiInputInfo alloc]init];
        if (indexPath.row == 0) {
            tempVC.title = @"取件人";
            [tempVC backDataBlock:^(NSString *str) {
                weakSelf.detailTextLabel.text = str;
                param_Name = str;
            }];
        }else{
            tempVC.title = @"取件人手机";
            [tempVC backDataBlock:^(NSString *str) {
                weakSelf.detailTextLabel.text = str;
                param_PhoneNum = str;
            }];
        }
        
        [self.navigationController pushViewController:tempVC animated:YES];
        
    }
    
    if (indexPath.section == 1) {
        SLWifiBZVC *tempVC = [[SLWifiBZVC alloc]init];
        [self.navigationController pushViewController:tempVC animated:YES];
        [tempVC backDataBlock:^(NSString *str) {
             weakSelf.textLabel.text = str;
            param_Bz = str;
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
