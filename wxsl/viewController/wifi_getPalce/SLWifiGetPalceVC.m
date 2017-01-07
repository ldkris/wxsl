//
//  SLWifiGetPalceVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiGetPalceVC.h"
#import "SLWifiGetPalceCell.h"

#import "SLWifiDetailVC.h"
@interface SLWifiGetPalceVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;

@end

@implementation SLWifiGetPalceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"取件机场";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSArray array];
    }
    return _mDataSoure;
}
#pragma mark block
-(void)backDataBlock:(void (^)(NSDictionary *))block{
    self.backData = block;
}
#pragma  mark UITableViewDataSource &&UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView registerNib:[UINib nibWithNibName:@"SLWifiGetPalceCell" bundle:nil] forCellReuseIdentifier:@"SLWifiGetPalceCell"];
    SLWifiGetPalceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLWifiGetPalceCell"];
    [cell loadCellInfoWthDic:self.mDataSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.mDataSoure[indexPath.row];
    self.backData(dic);
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
