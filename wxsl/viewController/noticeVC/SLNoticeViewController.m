//
//  SLNoticeViewController.m
//  wxsl
//
//  Created by 刘冬 on 16/8/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLNoticeViewController.h"
#import "SLNoticeCell.h"
@interface SLNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *mDataSoure;

@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@end

@implementation SLNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"公司公告";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [SVProgressHUD show];
    [HttpApi getEnterpriseNoticeList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        //  LDLOG(@"公告 ===== %@",responseBody);
        [SVProgressHUD dismiss];
        NSArray  *notices = responseBody[@"notices"];
        self.mDataSoure  = notices;
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSArray array];
    }
    return _mDataSoure;
}
#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView registerNib:[UINib nibWithNibName:@"SLNoticeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLNoticeCell"];
    
    SLNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLNoticeCell"];
    [cell loadNotceInfo:self.mDataSoure[indexPath.row]];
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
