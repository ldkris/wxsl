//
//  SLTripPipleVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTripPipleVC.h"
#import "SLAddContactVC.h"

#import "SLTripPopleCell.h"
@interface SLTripPipleVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableVIew;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

@property(nonatomic,retain)NSMutableArray *mSelectArray;
@end

@implementation SLTripPipleVC{
    BOOL _Editing;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableVIew.tableFooterView = [UIView new];
    self.mInfoTableVIew.backgroundColor = SL_GRAY;
    
    self.mInfoTableVIew.estimatedRowHeight = 44.0f;
    self.mInfoTableVIew.rowHeight = UITableViewAutomaticDimension;
    
    _Editing = NO;
    
    if (self.isSelect == YES) {
        UIBarButtonItem *mRightBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onclickRightBtn:)];
        self.navigationItem.rightBarButtonItem = mRightBtn;
    }else{
        UIBarButtonItem *mRightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onclickedBtn:)];
        self.navigationItem.rightBarButtonItem = mRightBtn;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self getContactList];
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
-(NSMutableArray *)mSelectArray{
    if (_mSelectArray == nil) {
        _mSelectArray = [NSMutableArray array];
    }
    return _mSelectArray;
}
#pragma  mark public
-(void)backPopleInfo:(void (^)( NSMutableArray*))block{
    self.backBlock = block;
}
#pragma mark networking
-(void)delContact:(SLContactModel *)model compleBlock:(void(^)(BOOL reslut))block{
    
    if(model == nil){
        return;
    }
    
    [HttpApi delContact:@{@"userId":sl_userID,@"no":model.mID} SuccessBlock:^(id responseBody) {
        if (block) {
            block(YES);
        }
        
    } FailureBlock:^(NSError *error) {
        if (block) {
            block(NO);
        }

    }];
}
-(void)getContactList{
    [HttpApi getContactList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {

        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLContactModel class] fromJSONArray:responseBody[@"contacts"] error:&error];
        self.mDataSoure = [NSMutableArray arrayWithArray:temp];
        [self.mInfoTableVIew reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];

}
#pragma mark event response
-(void)onclickedBtn:(UIButton *)sender{
    _Editing = !_Editing;
    [self.mInfoTableVIew setEditing:_Editing animated:YES];
}
-(void)onclickRightBtn:(UIButton *)sender{
    
    if (self.isSelect) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.backBlock && self.mSelectArray.count>0) {
            self.backBlock(self.mSelectArray);
        }
    }

}
- (IBAction)onclickAddBtn:(id)sender {
    SLAddContactVC *mTempVC =[[SLAddContactVC alloc]init];
    [self.navigationController pushViewController:mTempVC animated:YES];
    
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
    SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.row]];
    cell.mBtn_status.hidden = !self.isSelect;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SLTripPopleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    SLContactModel *temp = self.mDataSoure[indexPath.row];
    if (![self.mSelectArray containsObject:temp]) {
        [cell.mBtn_status setImage:[UIImage imageNamed:@"hotel_icon_fan_select"] forState:UIControlStateNormal];
        [self.mSelectArray addObject:temp];
    }else{
        [self.mSelectArray removeObject:temp];
        [cell.mBtn_status setImage:[UIImage imageNamed:@"hotel_icon_fan"] forState:UIControlStateNormal];
        
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        SLContactModel *model = self.mDataSoure[indexPath.row];
        
        [self delContact:model compleBlock:^(BOOL reslut) {
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
