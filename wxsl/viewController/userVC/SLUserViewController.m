//
//  SLUserViewController.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLUserViewController.h"
#import "SLUserVCTableViewCell.h"
#import "SLChangePwdVC.h"
#import "SLChanagePhoneVC.h"
#import "SLChangeUserInfoVC.h"
#import "SLOrdersVC.h"
#import "SLSettingVC.h"
#import "SLTripPipleVC.h"
#import "SLCommonPassengerVC.h"
#import "SLAddressVC.h"
#import "SLWifiOrderListVC.h"

#import "SLUserHeadView.h"
#import "SLMyPolicyView.h"
@interface SLUserViewController ()<UITableViewDelegate,UITableViewDataSource,SLUserVCTableViewCellDelegate,SLUserHeadViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(strong,nonatomic)NSArray *mDataSoure;
@property(strong,nonatomic)NSArray *mImgDataSoure;
@property(nonatomic,retain) SLUserInfoModel *mUserInfoModel;
@end

@implementation SLUserViewController
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.separatorColor = SL_GRAY;
    
    self.view.backgroundColor = SL_GRAY;
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self getUserInfoNetWroking];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getUserInfoNetWroking{
    
    [HttpApi getUserInfo:@{@"userId":sl_userID} isShowLoadingView:NO SuccessBlock:^(id responseBody) {
       // LDLOG(@"用户信息 ==== %@",responseBody);
        [MyFounctions removeUserDetailInfo];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseBody];
        [MyFounctions saveDetailUserInfo:userInfo];
        
        NSError *error;
        SLUserInfoModel*mtempModel = [MTLJSONAdapter modelOfClass:[SLUserInfoModel class] fromJSONDictionary:userInfo error:&error];
        self.mUserInfoModel = mtempModel;
        
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark getter
-(NSArray *)mImgDataSoure{
    if (_mImgDataSoure == nil) {
        _mImgDataSoure = @[@[@"user_all"],@[@"user_unUse"],@[@"user_sc",@"user_cn",@"user_sp"],@[@"mine_5",@"mine_6",@"mine_7"],@[@"mine_8",@"mine_9",@"mine_10"],@[@"mine_12"],@[@"mine_11"]];
    }
    
    return _mImgDataSoure;
}
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@[@"全部订单",@""],@[@"未出行订单"],@[@"积分商城",@"差旅政策",@"审批申请"],@[@"修改手机号码",@"修改个人信息",@"修改密码"],@[@"常用出行人",@"常用联系人",@"常用配送地址"],@[@"我的积分"],@[@"设置"]];
    }
    return _mDataSoure;
}

#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *mTemp = self.mDataSoure[section];
    return mTemp.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 145;
    }
    return 45.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 140.00f;
    }
    
    return 10.00f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        SLUserHeadView *mUserHeadView = [[SLUserHeadView alloc]init];
        mUserHeadView.delegate = self;
        mUserHeadView.mLB_userName.text = [MyFounctions getUserInfo][@"name"];
        mUserHeadView.mLB_commanyName.text = self.mUserInfoModel.mCompanyName;
        if (self.mUserInfoModel.mHeadimgurl) {
            [mUserHeadView.mImg_head sd_setImageWithURL:[NSURL URLWithString:self.mUserInfoModel.mHeadimgurl]];
        }
     
        return mUserHeadView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row) {
        [tableView registerNib:[UINib nibWithNibName:@"SLUserVCTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLUserVCTableViewCell"];
        
        SLUserVCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLUserVCTableViewCell"];
        cell.delegate = self;
        return cell;
    }
    
    static NSString *cellIndertifier = @"cellIndertifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndertifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndertifier];
    }
    cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.mImgDataSoure[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    
    if(indexPath.section == 5){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *score = [self.mUserInfoModel.mScore stringValue];
        if (score == nil || score.length==0 || [score isEqual:[NSNull null]]) {
            score = @"0";
        }
        
        cell.textLabel.text =[NSString stringWithFormat: @"我的积分：%@",score];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 1){
        SLOrdersVC *mOrderVC = [[SLOrdersVC alloc]init];
        mOrderVC.mOrderType = M_UNUSEORDER;
        [self.navigationController pushViewController:mOrderVC animated:YES];
    }
    if (indexPath.section == 2) {
        
        
        if (indexPath.row == 1) {
            [SVProgressHUD show];
            [HttpApi getMyTravelPolicyList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
                [SVProgressHUD dismiss];
                NSString * audit = responseBody[@"approveType"];
                SLMyPolicyView *mOrderVC =[[NSBundle mainBundle]loadNibNamed:@"SLMyPolicyView" owner:nil options:nil][0];
                
                if ([audit integerValue] == 1) {
                    mOrderVC.mLB_fj.text = @"免审";
                }else if([audit integerValue] == 2){
                    mOrderVC.mLB_fj.text = @"出行审批";
                }else{
                    mOrderVC.mLB_fj.text = @"违规审批";
                }
                // mOrderVC.mOrderType = M_ALLORDER;
                mOrderVC.mLB_sp.text = responseBody[@"myTravelPolicys"][0][@"name"];
                [self.tabBarController.view addSubview:mOrderVC];
                [mOrderVC mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.right.bottom.mas_equalTo(0);
                }];
                
            } FailureBlock:^(NSError *error) {
                
            }];
        }
        
        if (indexPath.row == 2) {
            SLOrdersVC *mOrderVC = [[SLOrdersVC alloc]init];
            mOrderVC.mOrderType = M_SHENHE;
            [self.navigationController pushViewController:mOrderVC animated:YES];
        }
        
    }
    
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //更改电话
            SLChanagePhoneVC *mChangePhoneVC = [[SLChanagePhoneVC alloc]init];
            [self.navigationController pushViewController:mChangePhoneVC animated:YES];
        }
        if (indexPath.row == 1) {
            //更改用户信息
            SLChangeUserInfoVC *mChangeUserInfoVC = [[SLChangeUserInfoVC alloc]init];
            [self.navigationController pushViewController:mChangeUserInfoVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            //改密码
            SLChangePwdVC *mChangePwdVC = [[SLChangePwdVC alloc]init];
            [self.navigationController pushViewController:mChangePwdVC animated:YES];
        }
    }
    
    if (indexPath.section == 4) {
        //出行人
        if (indexPath.row == 0) {
            SLCommonPassengerVC *mtempVC = [[SLCommonPassengerVC alloc]init];
            mtempVC.title = @"常用出行人";
            [self.navigationController pushViewController:mtempVC animated:YES];
        }
        //联系人
        if (indexPath.row == 1) {
            SLTripPipleVC *mTempVC = [[SLTripPipleVC alloc]init];
            mTempVC.title = @"常用联系人";
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
        
        if (indexPath.row == 2) {
            
            SLAddressVC *mTempVC = [[SLAddressVC alloc]init];
            mTempVC.title = @"常用配送地址";
            [self.navigationController pushViewController:mTempVC animated:YES];
        }
    }
    
    if (indexPath.section == 6) {
        //设置
         SLSettingVC*mChangePwdVC = [[SLSettingVC alloc]init];
        [self.navigationController pushViewController:mChangePwdVC animated:YES];
    }
}
#pragma mark SLUserVCTableViewCellDelegate
// 出行订单 全部订单。。。。
-(void)SLUserVCTableViewCell:(SLUserVCTableViewCell *)cell didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            
            SLOrdersVC *mOrderVC = [[SLOrdersVC alloc]init];
            mOrderVC.mOrderType = M_ALLORDER;
            mOrderVC.title = @"机票订单";
            [self.navigationController pushViewController:mOrderVC animated:YES];

            break;}
            
        case 1:{
            SLOrdersVC *mOrderVC = [[SLOrdersVC alloc]init];
            mOrderVC.mOrderType = M_UNUSEORDER;
            [self.navigationController pushViewController:mOrderVC animated:YES];

            break;}
            
        case 2:{
            
          

            break;}

        case 7:{
            SLWifiOrderListVC *tempVC = [[SLWifiOrderListVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
            break;}

            
        default:
            break;
    }

}
#pragma mark SLUserHeadViewDelegate
-(void)SLUserHeadView:(SLUserHeadView *)view onclickBackBtn:(UIButton *)sender{
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
