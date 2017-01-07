//
//  SLWifiListVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiListVC.h"
#import "SLWifiListCell.h"

#import "SLWifiDetailVC.h"
@interface SLWifiListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLWifiListVC{

   int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    
    pageIndex = 1;
    
    [self getHotList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if(_mDataSoure == nil){
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark netWorking
-(void)getHotList{
    [[SLNetWorkingHelper shareNetWork] getWifiList:@{@"userId":sl_userID,@"pageIndex":[NSString stringWithFormat:@"%d",pageIndex],@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLWifiListModel class] fromJSONArray:responseBody[@"products"] error:&error];
        self.mDataSoure = [NSMutableArray arrayWithArray:temp];
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
    
    [tableView registerNib:[UINib nibWithNibName:@"SLWifiListCell" bundle:nil] forCellReuseIdentifier:@"SLWifiListCell"];
    SLWifiListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiListCell"];
    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.row]];
    
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
        
        [[SLNetWorkingHelper shareNetWork] getWifiList:@{@"userId":sl_userID,@"pageIndex":[NSString stringWithFormat:@"%d",pageIndex],@"pageSize":@"10"} SuccessBlock:^(id responseBody) {
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
    
    SLWifiDetailVC *temp = [[SLWifiDetailVC alloc]init];
    SLHotWifiList *model = self.mDataSoure[indexPath.row];
    temp.mCurrModel = model;
    [self.navigationController pushViewController:temp animated:YES];
    
//    SLWifiGetPalceVC * tempVC = [[SLWifiGetPalceVC alloc]init];
//    [self.navigationController pushViewController:tempVC animated:YES];
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    float height = scrollView.contentSize.height > self.mInfoTableView.frame.size.height ?  self.mInfoTableView.frame.size.height : scrollView.contentSize.height;
//    if ((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.07) {
//        // 调用上拉刷新方法
//        
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
