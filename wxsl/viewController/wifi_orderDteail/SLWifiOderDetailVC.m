//
//  SLWifiOderDetailVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiOderDetailVC.h"
#import "SLWifiOderDetailHederView.h"
#import "SLWifiOderDetailCell.h"
#import "SLWifiOderDetailOneCell.h"
#import "SLWifiCancelOrderView.h"
@interface SLWifiOderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mCellDataSoure;
@property(nonatomic,retain)SLWifiOderDetial *mOderDetial;
@end

@implementation SLWifiOderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.estimatedRowHeight = 30.f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    
    self.title = @"订单详情";
    
    [[SLNetWorkingHelper shareNetWork]getWifiOrderDetail:@{@"userId":sl_userID,@"orderNo":self.oder.mOrderNo} SuccessBlock:^(id responseBody) {
        NSError *error;
        SLWifiOderDetial *asd = [MTLJSONAdapter modelOfClass:[SLWifiOderDetial class] fromJSONDictionary:responseBody[@"order"] error:&error];
        
        self.mOderDetial= asd;
        self.mOderDetial.mPrice = self.oder.mPrice;
        
        if (self.mOderDetial.mCancelTime && self.mOderDetial.mCancelTime.length>0) {
            _mDataSoure = @[@[@""],@[@"使用日期",@"押金",@"租赁台数"],@[@"取件点",@"还件点"],@[@"领取方式",@"退改规则"],@[@"取件人",@"取件人手机"],@[@"预定日期",@"支付方式",@"支付时间"],@[@"取消台数",@"退款总额",@"取消时间",@"取消手续费"]];
        }
        
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@[@""],@[@"使用日期",@"押金",@"租赁台数"],@[@"取件点",@"还件点"],@[@"领取方式",@"退改规则"],@[@"取件人",@"取件人手机"],@[@"预定日期",@"支付方式",@"支付时间"]];
    }
    return _mDataSoure;
}
-(NSArray *)mCellDataSoure{
    if (_mCellDataSoure == nil) {
        _mCellDataSoure = @[@[@""],@[@"2016-10-15 至 2016-10-20",@"500/台（取件时付现）",@"15/天x1"],@[@"江北机场/T1出发 安检外 国际出发 环球漫游柜台（询问柜台旁）周一至周日6：00-凌晨01：00",@"江北机场/T1出发 安检外 国际出发 环球漫游柜台（询问柜台旁）周一至周日6：00-凌晨01：00"],@[@"凭取件人手机号，出国当天取件，归还时退换押金",@"江北机场/T1出发 安检外 国际出发 环球漫游柜台（询问柜台旁）周一至周日6：00-凌晨01：00",@"江北机场/T1出发 安检外 国际出发 环球漫游柜台（询问柜台旁）周一至周日6：00-凌晨01：00"],@[@"刘冬",@"13983747231"],@[@"2016-09-18",@"在线支付",@"2016-09-28"]];
    }
    return _mCellDataSoure;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 72.0f;
    }
    if (section == 4) {
        return 40.0f;
    }
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        SLWifiOderDetailHederView *tempView = [[NSBundle mainBundle]loadNibNamed:@"SLWifiOderDetailHederView" owner:nil options:nil][0];
        return tempView;
    }
    
    if (section == 4) {
        UIView *mHeadView=  [UIView new];
        [mHeadView setBackgroundColor:SL_GRAY];
//        [mHeadView setBackgroundColor:[UIColor redColor]];
        UILabel *mLable = [[UILabel alloc]init];
        [mLable setText:@"联系人"];
        [mLable setFont:[UIFont systemFontOfSize:15.0f]];
        [mHeadView addSubview:mLable];
        [mLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(13);
        }];
        
        return mHeadView;
    }
    
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SLWifiOderDetailCell" bundle:nil] forCellReuseIdentifier:@"SLWifiOderDetailCell"];
        SLWifiOderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiOderDetailCell"];
        [cell loadCellInfoWithInfo:self.mOderDetial andListModel:self.oder];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell onclikCancelBlock:^(UIButton *sender) {
            SLWifiCancelOrderView *tempView = [[NSBundle mainBundle]loadNibNamed:@"SLWifiCancelOrderView" owner:nil options:nil][0];
            tempView.num = [NSString stringWithFormat:@"%@",self.mOderDetial.mCount];
            [self.navigationController.view addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_offset(0);
            }];
            
            [tempView onclickComfirBtnBlock:^(UIButton *sender) {
                [[SLNetWorkingHelper shareNetWork]cancelOrder:@{@"userId":sl_userID,@"orderNo":self.mOderDetial.mOrderNo,@"count":[NSString stringWithFormat:@"%ld",sender.tag]} SuccessBlock:^(id responseBody) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
            }];
        }];
        return cell;

    }
    
    
    [tableView registerNib:[UINib nibWithNibName:@"SLWifiOderDetailOneCell" bundle:nil] forCellReuseIdentifier:@"SLWifiOderDetailOneCell"];
    SLWifiOderDetailOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiOderDetailOneCell"];
    cell.mlab_title.text = self.mDataSoure[indexPath.section][indexPath.row];
//    cell.mlab_subTitle.text = self.mCellDataSoure[indexPath.section][indexPath.row];
    [cell loadCellInfoData:self.mOderDetial withInde:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
//    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    }
//    return cell;
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
