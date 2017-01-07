//
//  SLAddressVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/21.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLAddressVC.h"
#import "SLAddAddressVC.h"

#import "SLAddressCell.h"
@interface SLAddressVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLAddressVC{
    BOOL _Editing;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _Editing = NO;
    
    self.mInfoTableView.backgroundColor = SL_GRAY;
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.tableFooterView = [UIView new];
    
    UIBarButtonItem *mRightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onclickedBtn:)];
    self.navigationItem.rightBarButtonItem = mRightBtn;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self getDeliverAddrList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark event response
-(void)onclickedBtn:(UIButton *)sender{
    _Editing = !_Editing;
    [self.mInfoTableView setEditing:_Editing animated:YES];
}
- (IBAction)onclikAddBtn:(UIButton *)sender {
    SLAddAddressVC *temp = [[SLAddAddressVC alloc]init];
    [self.navigationController pushViewController:temp animated:YES];
}
#pragma mark networking
-(void)delDeliverAddr:(SLAddressModel *)model compleBlock:(void(^)(BOOL reslut))block{
    
    if(model == nil){
        return;
    }
    
    [HttpApi delDeliverAddr:@{@"userId":sl_userID,@"no":model.mID} SuccessBlock:^(id responseBody) {
        if (block) {
            block(YES);
        }
        
    } FailureBlock:^(NSError *error) {
        if (block) {
            block(NO);
        }
        
    }];
}
-(void)getDeliverAddrList{
    [HttpApi getDeliverAddrList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLAddressModel class] fromJSONArray:responseBody[@"delivers"] error:&error];
        self.mDataSoure = [NSMutableArray arrayWithArray:temp];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma  mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        SLAddressModel *model = self.mDataSoure[indexPath.row];
        
        [self delDeliverAddr:model compleBlock:^(BOOL reslut) {
            if (reslut) {
                //        获取选中删除行索引值
                NSInteger row = [indexPath row];
                //        通过获取的索引值删除数组中的值
                [self.mDataSoure removeObjectAtIndex:row];
                //        删除单元格的某一行时，在用动画效果实现删除过程
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
