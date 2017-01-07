//
//  SLOrdersVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLOrdersVC.h"
#import "SLOdersCell.h"

#import "SLorderDetailVC.h"
@interface SLOrdersVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *moderList;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTbaleView;
@end

@implementation SLOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.mOrderType == M_ALLORDER) {
//        self.title = @"所有订单";
        [self getMyOrderList:@"1"];
    }else if (self.mOrderType == M_UNUSEORDER){
        self.title = @"未出行订单";
        [self getMyOrderList:@"2"];
        
    }else{
        self.title = @"审核订单";
        [self getMyOrderList:@"1"];
    }
    
    
    self.mInfoTbaleView.tableFooterView = [UIView new];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)moderList{
    if (_moderList == nil) {
        _moderList = [NSMutableArray array];
    }
    return _moderList;
}
#pragma mark networking
-(void)getMyOrderList:(NSString *)type{
    
    [HttpApi getMyOrderList:@{@"userId":sl_userID,@"type":type} SuccessBlock:^(id responseBody) {
        //LDLOG(@"订单 == %@",responseBody);
        
        NSArray *oders = responseBody[@"myOrders"];
    
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLOrderModel class] fromJSONArray:oders error:&error];
        
        if(self.mOrderType == M_SHENHE ){
            NSMutableArray *tempOders = [NSMutableArray array];
            
            for (SLOrderModel *model in temp) {
                if ([model.mBookStatus intValue] == 10) {
                    [tempOders addObject:model];
                }
            }
            
            [self.moderList addObjectsFromArray:tempOders];
        }else{
            [self.moderList addObjectsFromArray:temp];
        }
        
        
        
        [self.mInfoTbaleView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return  self.moderList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLOdersCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLOdersCell"];
    
    SLOdersCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLOdersCell"];
   [cell loadCellInfoWithModel:self.moderList[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SLOrderModel *temp = self.moderList[indexPath.row];
    SLorderDetailVC *mTempVC = [[SLorderDetailVC alloc]init];
    mTempVC.mOderModel = temp;
    [self.navigationController pushViewController:mTempVC animated:YES];
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
