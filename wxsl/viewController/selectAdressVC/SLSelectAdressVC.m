//
//  SLSelectAdressVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/23.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectAdressVC.h"

#import "SLAddressCell.h"

@interface SLSelectAdressVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTbaleView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLSelectAdressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择配送方式";
    self.mInfoTbaleView.estimatedRowHeight = 44.0f;
    self.mInfoTbaleView.rowHeight = UITableViewAutomaticDimension;
    
    [self getDeliverAddrList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithArray:@[@[@"自取",@"快递"],[NSMutableArray arrayWithArray:@[@"添加配送地址"]]]];
    }
    
    return _mDataSoure;
}
#pragma mark networking
-(void)getDeliverAddrList{
    [HttpApi getDeliverAddrList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLAddressModel class] fromJSONArray:responseBody[@"delivers"] error:&error];
        
        NSMutableArray *tempAray =self.mDataSoure[1];
        for (SLAddressModel *model in temp) {
            [tempAray insertObject:model atIndex:1];
        }

       [self.mInfoTbaleView reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark public
-(void)backInfoBlock:(void (^)(NSString *, SLAddressModel *))block{
    self.bloclk = block;
}
#pragma mark event response
-(void)onclickBxBtn:(UIButton *)sender{

}

-(void)onclickAddIdCard:(UIButton *)sender{
    
}
#pragma mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"选择配送方式",@"选择配送地址"][section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row>0 && indexPath.section == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
        SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
        [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
        return cell;
    }

    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row];
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
    
    if (indexPath.section == 0) {
        [mAddBtn setImage:[UIImage imageNamed:@"hotel_icon_fan"] forState:UIControlStateNormal];
        [mAddBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
        [mAddBtn addTarget:self action:@selector(onclickAddIdCard:) forControlEvents:UIControlEventTouchUpInside];
    }
    
     cell.accessoryView = mAddBtn;

    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0 && indexPath.row ==0){
        if (_bloclk) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            self.bloclk(@"1",nil);
        }
    }
    
    if(indexPath.section==1 && indexPath.row >0){
        
        SLAddressModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (_bloclk) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            self.bloclk(@"2",model);
        }
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
