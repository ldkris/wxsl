//
//  SLWifiDetailVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiDetailVC.h"
#import "SLWifiDtailCell_one.h"
#import "SLWifiDtailCell_two.h"
#import "SLWifiDtailCell_three.h"

#import "SLWifiFillOderVC.h"
@interface SLWifiDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain) SLHotWifiDetial *mWifiDetailMoel;
@end

@implementation SLWifiDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情页";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    
    UIView *mBtnsView = [[UIView alloc]init];
    [mBtnsView setFrame:CGRectMake(0, 0, 100, 44)];
    
    UIButton *mFXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mFXBtn setImage:[UIImage imageNamed:@"wifi_fx"]  forState:UIControlStateNormal];
    [mFXBtn addTarget:self action:@selector(onclickFXBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtnsView addSubview:mFXBtn];
    [mFXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    UIButton *mscBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [mMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [mscBtn setImage:[UIImage imageNamed:@"wifi_sc"]  forState:UIControlStateNormal];
    [mscBtn addTarget:self action:@selector(onclickSCBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtnsView addSubview:mscBtn];
    [mscBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mBtnsView];
    
    [self getWifiDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"",@"设备",@"取件机场",@"费用",@"退改"];
    }
    return _mDataSoure;
}
#pragma mark netWorking
-(void)getWifiDetail{
    [[SLNetWorkingHelper shareNetWork]getWifiDetail:@{@"userId":sl_userID,@"productId":self.mCurrModel.mPid} SuccessBlock:^(id responseBody) {
        NSError *error;
       self.mWifiDetailMoel = [MTLJSONAdapter modelOfClass:[SLHotWifiDetial class] fromJSONDictionary:responseBody error:&error];
//        LDLOG(@"%@",temp);

        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark event response
-(void)onclickSCBtn:(UIButton *)sender{

}
-(void)onclickFXBtn:(UIButton *)sender{
    
}
- (IBAction)onclickYDBtn:(UIButton *)sender {
    
    SLWifiFillOderVC *tempVC = [[SLWifiFillOderVC alloc]init];
    tempVC.mWifiDetailMoel = self.mWifiDetailMoel;
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickZXBtn:(UIButton *)sender {
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return 2;
    }
    return 1;
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
    
    UIView *mtempView = [[UIView alloc]init];
//    [mtempView setBackgroundColor:[UIColor redColor]];
    
    UIImageView *imageView = [[UIImageView alloc]init];
//    [imageView setBackgroundColor:[UIColor blueColor]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [mtempView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    if (section>0) {
        [imageView setImage:[UIImage imageNamed:@[@"wifi_detail",@"wifi_detail_fj",@"wifi_detail_rmb",@"wifi_detail_tc"][section - 1]]];
    }
    
    UILabel *mLable = [[UILabel alloc]init];
    [mLable setText:self.mDataSoure[section]];
    [mLable setFont:[UIFont systemFontOfSize:13.0f]];
    [mtempView addSubview:mLable];
    [mLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(imageView.mas_right).with.offset(10);
    }];
    
    return mtempView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SLWifiDtailCell_one" bundle:nil] forCellReuseIdentifier:@"SLWifiDtailCell_one"];
        SLWifiDtailCell_one *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiDtailCell_one"];
        [cell loadCellInfoWithModel:self.mWifiDetailMoel];
        return cell;
    }
    
    [tableView registerNib:[UINib nibWithNibName:@"SLWifiDtailCell_three" bundle:nil] forCellReuseIdentifier:@"SLWifiDtailCell_three"];
    SLWifiDtailCell_three *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiDtailCell_three"];
    if (indexPath.section == 1 && indexPath.row == 0) {
        [cell loadCellInfoWithModel:self.mWifiDetailMoel];
    }
    if(indexPath.section==2){
        [cell loadCellAirInfoWithModel:self.mWifiDetailMoel.mPlaces];
    }
    if(indexPath.section==3){
        [cell loadCellFYInfoWithModel];
    }
    if(indexPath.section==4){
        [cell loadCellTGQInfoWithModel];
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
