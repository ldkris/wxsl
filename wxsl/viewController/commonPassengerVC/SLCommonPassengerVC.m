//
//  SLCommonPassengerVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/20.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCommonPassengerVC.h"
#import "SLSelectPopleCell.h"

#import "SLAddTripPopleVC.h"
@interface SLCommonPassengerVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

@property (weak, nonatomic) IBOutlet UIButton *btn_add;
@end

@implementation SLCommonPassengerVC{

   BOOL _Editing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _Editing = NO;
    
    self.mInfoTableView.tableFooterView = [UIView new];
    self.mInfoTableView.backgroundColor = SL_GRAY;
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *mRightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(onclickedBtn:)];
    self.navigationItem.rightBarButtonItem = mRightBtn;

    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.mOderDataSoure == nil) {
        [self getTravelPeopleList];
        self.btn_add.hidden = NO;
    }else{
        self.btn_add.hidden = YES;
    }
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
-(void)backInfoBlock:(void (^)(NSDictionary *))block{
    self.backInfo = block;
}
#pragma mark networking

-(void)getTravelPeopleList{
    [HttpApi getTravelPeopleList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLPassengerModel class] fromJSONArray:responseBody[@"peoples"] error:&error];
        self.mDataSoure = [NSMutableArray arrayWithArray:temp];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)delTravelPeople:(SLPassengerModel *)model compleBlock:(void(^)(BOOL reslut))block{
    
    if(model == nil){
        return;
    }
    
    [HttpApi delTravelPeople:@{@"userId":sl_userID,@"no":model.mID} SuccessBlock:^(id responseBody) {
        if (block) {
            block(YES);
        }
        
    } FailureBlock:^(NSError *error) {
        if (block) {
            block(NO);
        }
        
    }];
}

#pragma mark event response
- (IBAction)onclikAddBtn:(UIButton *)sender {
    
    SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
    [self.navigationController pushViewController:temp animated:YES];
}

-(void)onclickedBtn:(UIButton *)sender{
    _Editing = !_Editing;
    [self.mInfoTableView setEditing:_Editing animated:YES];
}
#pragma  mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.mOderDataSoure) {
         return [self.mOderDataSoure count];
    }
    
    return [self.mDataSoure count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
    SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
    if (self.mOderDataSoure) {
        cell.mLB_name.text = self.mOderDataSoure[indexPath.row][@"name"];
        cell.mLB_subTitle.text = @"";
        cell.mLB_IDname.text = @"";
        cell.mLB_IDnum.text = self.mOderDataSoure[indexPath.row][@"no"];
//        cell.mBtn_mark.hidden = NO;
    }else{
        [cell loadCellInfoWithModel: self.mDataSoure[indexPath.row]];
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.mOderDataSoure) {
        if (self.backInfo) {
            self.backInfo(self.mOderDataSoure[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        SLPassengerModel *model = self.mDataSoure[indexPath.row];
        
        [self delTravelPeople:model compleBlock:^(BOOL reslut) {
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
