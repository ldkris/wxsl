//
//  SLWifiOrderListVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiOrderListVC.h"
#import "SLWifiOrderListCell.h"
#import "SLWifiOderDetailVC.h"
#import "SLWifiCancelOrderView.h"
@interface SLWifiOrderListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)UIImageView *mBGImgeView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLWifiOrderListVC{

   int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"WIFI订单";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundView:self.mBGImgeView];
    pageIndex = 1;
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mDataSoure removeAllObjects];
    [self getOderList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(UIImageView *)mBGImgeView{
    if (_mBGImgeView == nil) {
        _mBGImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flight_img_complete_bg"]];
    }
    return _mBGImgeView;
}
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark  netWorking
-(void)getOderList{
    [[SLNetWorkingHelper shareNetWork]getWifiOrderList:@{@"userId":sl_userID,@"pageIndex":@"1",@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
         NSError *error;
         NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLWifiOderListModel class] fromJSONArray:responseBody[@"orders"] error:&error];
//        LDLOG(@"%@",temp);
        [self.mDataSoure addObjectsFromArray:temp];
        [self.mInfoTableView reloadData];
        pageIndex++;
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView registerNib:[UINib nibWithNibName:@"SLWifiOrderListCell" bundle:nil] forCellReuseIdentifier:@"SLWifiOrderListCell"];
    SLWifiOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiOrderListCell"];
    SLWifiOderListModel *model = self.mDataSoure[indexPath.row];
    [cell loadCellInfoWithModel:model];
    
    
    [cell onclikCancelBlock:^(UIButton *sender) {
        SLWifiCancelOrderView *tempView = [[NSBundle mainBundle]loadNibNamed:@"SLWifiCancelOrderView" owner:nil options:nil][0];
        tempView.num = [model.mCount stringValue];
        [self.navigationController.view addSubview:tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_offset(0);
        }];
        [tempView onclickComfirBtnBlock:^(UIButton *sender) {
            [tempView removeFromSuperview];
            [[SLNetWorkingHelper shareNetWork]cancelOrder:@{@"userId":sl_userID,@"orderNo":model.mOrderNo,@"count":[NSString stringWithFormat:@"%ld",sender.tag]} SuccessBlock:^(id responseBody) {
                [SVProgressHUD showSuccessWithStatus:@"成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.mDataSoure removeAllObjects];
                    [self getOderList];
                });
                
            } FailureBlock:^(NSError *error) {
                
            }];
        }];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.mDataSoure.count - 1 && self.mDataSoure.count>=10 && pageIndex>1) {
        LDLOG(@"最后一行 最后一行 最后一行 最后一行最后一行最后一行");
        self.mInfoTableView.tableFooterView = nil;
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.mInfoTableView.bounds.size.width, 50.0f)];
        UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
        [loadMoreText setCenter:tableFooterView.center];
        [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
        [loadMoreText setText:@"正在加载更多数据"];
        [tableFooterView addSubview:loadMoreText];
        self.mInfoTableView.tableFooterView = tableFooterView;
        
        [[SLNetWorkingHelper shareNetWork] getWifiOrderList:@{@"userId":sl_userID,@"pageIndex":[NSString stringWithFormat:@"%d",pageIndex],@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
            NSError *error;
            NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLWifiListModel class] fromJSONArray:responseBody[@"products"] error:&error];
            if (temp.count>0) {
                [self.mDataSoure addObjectsFromArray:temp];
                [self.mInfoTableView reloadData];
                pageIndex++;
            }else{
                [loadMoreText setText:@"没有更多数据了！"];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLWifiOderDetailVC *tempVC = [[SLWifiOderDetailVC alloc]init];
    tempVC.oder = self.mDataSoure[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
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
