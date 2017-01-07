//
//  SLSelectpolicVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectpolicVC.h"
#import "SLPolicyCell.h"
#import "SLSelectPopleCell.h"

#import "SLCheckFlightVC.h"
#import "SLFillInOderVC.h"
@interface SLSelectpolicVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLSelectpolicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择差旅政策";
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithArray:self.mSelectedPassengers];
    }

    return _mDataSoure;
}
#pragma mark event response
-(void)onclickcomfirBtn:(UIButton *)sender{
    
    if (self.mSeleledPolic == nil) {
        ShowMSG(@"请选择商旅政策");
        return;
    }
    
    if (self.PassengerType == yuangong ) {
        NSDictionary *paramDic;
        if (self.mQSelectRBDModel) {
            paramDic = @{@"userId":sl_userID,@"passengerId":@"",@"flightDate":self.fightMode.mFlightDate,@"discount":self.mQSelectRBDModel.mRBDDiscount};

        }else{
            paramDic = @{@"userId":sl_userID,@"passengerId":@"",@"flightDate":self.fightMode.mFlightDate,@"discount":self.mSelectRBDModel.mRBDDiscount};
        }
        
        [SVProgressHUD show];
        [HttpApi checkWhetherIllegalBook:paramDic SuccessBlock:^(id responseBody) {
            [SVProgressHUD dismiss];
            if ([responseBody[@"illegalJudgment"] integerValue] == 1) {
                //需要违规判定
                if ([responseBody[@"illegalBook"] integerValue] == 1) {
                    //应许违规预定
                     self.illegalReasonLists = responseBody[@"illegalReasonLists"];
                    if (self.mQSelectRBDModel) {
                        SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                        mTempVC.mBackFlightInfoDIC =self.mBackFlightInfoDIC;
                        mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mTempVC.fightMode = self.fightMode;
                        mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        mTempVC.isViolation = YES;
                        mTempVC.mSelectedPassengers = self.mSelectedPassengers;
                        mTempVC.mSeleledPolic = self.mSeleledPolic;
                        mTempVC.QTicketType = Others;
                        mTempVC.QReasonType = self.QReasonType;
                        mTempVC.illegalReasonLists = self.illegalReasonLists;
                        [self.navigationController pushViewController:mTempVC animated:YES];
                    }else{
                        SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                        mtempVC.TicketType = Others;
                        mtempVC.ReasonType = company;
                        mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mtempVC.fightMode = self.fightMode;
                        // mtempVC.mBackFightMode = self.mBackFightMode;
                        mtempVC.mSelectRBDModel = self.mSelectRBDModel;
                        //mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        mtempVC.TicketType = self.QTicketType;
                        mtempVC.ReasonType = self.QReasonType;
                        mtempVC.mSeleledPolic = self.mSeleledPolic;
                        mtempVC.isViolation = YES;
                        mtempVC.mSelectedPassengers = self.mSelectedPassengers;
                        mtempVC.illegalReasonLists = self.illegalReasonLists;
                        [self.navigationController pushViewController:mtempVC animated:YES];
                    }
                    
                }else{
                    //不应许违规预定
                    ShowMSG(@"违规预定");
                }
            }else{
            //不需要
                if (self.mQSelectRBDModel) {
                    SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                    mTempVC.mBackFlightInfoDIC =self.mBackFlightInfoDIC;
                    mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                    mTempVC.fightMode = self.fightMode;
                    mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                    mTempVC.isViolation = YES;
                    mTempVC.mSelectedPassengers = self.mSelectedPassengers;
                    mTempVC.mSeleledPolic = self.mSeleledPolic;
                    mTempVC.QTicketType = Others;
                    mTempVC.QReasonType = self.QReasonType;
                    [self.navigationController pushViewController:mTempVC animated:YES];
                }else{
                    SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                    mtempVC.TicketType = Others;
                    mtempVC.ReasonType = self.QReasonType;
                    mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                    mtempVC.fightMode = self.fightMode;
                    // mtempVC.mBackFightMode = self.mBackFightMode;
                    mtempVC.mSelectRBDModel = self.mSelectRBDModel;
                    //mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                    mtempVC.isViolation = YES;
                    mtempVC.mSelectedPassengers = self.mSelectedPassengers;
                     mtempVC.mSeleledPolic = self.mSeleledPolic;
                    [self.navigationController pushViewController:mtempVC animated:YES];
                }
            }
            
        } FailureBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }else{
    
        NSDictionary *paramDic;
        if (self.mQSelectRBDModel) {
            paramDic = @{@"userId":sl_userID,@"passengerId":self.mSeleledPolic.mID,@"flightDate":self.fightMode.mFlightDate,@"discount":self.mQSelectRBDModel.mRBDDiscount};
            
        }else{
            paramDic = @{@"userId":sl_userID,@"passengerId":self.mSeleledPolic.mID,@"flightDate":self.fightMode.mFlightDate,@"discount":self.mSelectRBDModel.mRBDDiscount};
        }
        
        
        [SVProgressHUD show];
        [HttpApi checkWhetherIllegalBook:paramDic SuccessBlock:^(id responseBody) {
            [SVProgressHUD dismiss];
            if ([responseBody[@"illegalJudgment"] integerValue] == 1) {
                //需要违规判定
                if ([responseBody[@"illegalBook"] integerValue] == 1) {
                    //应许违规预定
                    self.illegalReasonLists = responseBody[@"illegalReasonLists"];
                    if (self.mQSelectRBDModel) {
                        SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                        mTempVC.mBackFlightInfoDIC =self.mBackFlightInfoDIC;
                        mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mTempVC.fightMode = self.fightMode;
                        mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        mTempVC.isViolation = YES;
                        mTempVC.mSelectedPassengers = self.mSelectedPassengers;
                        mTempVC.mSeleledPolic = self.mSeleledPolic;
                        mTempVC.QTicketType = Others;
                        mTempVC.QReasonType = self.QReasonType;
                        mTempVC.illegalReasonLists = self.illegalReasonLists;
                        [self.navigationController pushViewController:mTempVC animated:YES];
                    }else{
                        SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                        mtempVC.TicketType = Others;
                        mtempVC.ReasonType = company;
                        mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mtempVC.fightMode = self.fightMode;
                        // mtempVC.mBackFightMode = self.mBackFightMode;
                        mtempVC.mSelectRBDModel = self.mSelectRBDModel;
                        //mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        mtempVC.TicketType = self.QTicketType;
                        mtempVC.ReasonType = self.QReasonType;
                        mtempVC.mSeleledPolic = self.mSeleledPolic;
                        mtempVC.isViolation = YES;
                        mtempVC.mSelectedPassengers = self.mSelectedPassengers;
                        mtempVC.illegalReasonLists = self.illegalReasonLists;
                        [self.navigationController pushViewController:mtempVC animated:YES];
                    }
                    
                }else{
                    //不应许违规预定
                    
                    ShowMSG(@"违规预定");
                }
            }else{
                //不需要
                if (self.mQSelectRBDModel) {
                    SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                    mTempVC.mBackFlightInfoDIC =self.mBackFlightInfoDIC;
                    mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                    mTempVC.fightMode = self.fightMode;
                    mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                    mTempVC.isViolation = YES;
                    mTempVC.mSelectedPassengers = self.mSelectedPassengers;
                    mTempVC.mSeleledPolic = self.mSeleledPolic;
                    mTempVC.QTicketType = Others;
                    mTempVC.QReasonType = self.QReasonType;
                    [self.navigationController pushViewController:mTempVC animated:YES];
                }else{
                    SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                    mtempVC.TicketType = Others;
                    mtempVC.ReasonType = self.QReasonType;
                    mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                    mtempVC.fightMode = self.fightMode;
                    // mtempVC.mBackFightMode = self.mBackFightMode;
                    mtempVC.mSelectRBDModel = self.mSelectRBDModel;
                    //mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                    mtempVC.isViolation = YES;
                    mtempVC.mSelectedPassengers = self.mSelectedPassengers;
                    mtempVC.mSeleledPolic = self.mSeleledPolic;
                    [self.navigationController pushViewController:mtempVC animated:YES];
                }
                
            }
            
        } FailureBlock:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];

    }
}
#pragma mark  UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1){
    
        return 80.00f;
    }
    
    return 0.001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *footView = [UIView new];
        [footView setBackgroundColor:[UIColor clearColor]];
        
        UIButton *mComfir = [UIButton buttonWithType:UIButtonTypeCustom];
        [mComfir setTitle:@"确  定" forState:UIControlStateNormal];
        [mComfir setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mComfir addTarget:self action:@selector(onclickcomfirBtn:) forControlEvents:UIControlEventTouchUpInside];
        [mComfir.titleLabel setFont:DEFAULT_FONT(15)];
        [mComfir setBackgroundColor:SL_BULE];
        [mComfir.layer setMasksToBounds:YES];
        [mComfir.layer setCornerRadius:2.0f];
        
        [footView addSubview:mComfir];
        [mComfir mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(30);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(45);
        }];
        
        return footView;
    }
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @[@"已选乘客",@"选择商旅政策"][section];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
        SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
        [cell loadCellInfoWithModel:self.self.mDataSoure[indexPath.row]];
        return cell;
    }else{
    
        [tableView registerNib:[UINib nibWithNibName:@"SLPolicyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLPolicyCell"];
        SLPolicyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLPolicyCell"];
        [cell loadCellInfoWithModel:self.self.mDataSoure[indexPath.row]];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        return;
    }
  
    for (id tempcell in [tableView visibleCells]) {
        if ([tempcell isKindOfClass:[SLPolicyCell class]]) {
            SLPolicyCell *cell1 = tempcell;
             [cell1.mImg_mark setImage:[UIImage imageNamed:@"hotel_icon_fan"]];
        }
    }
    
    SLPolicyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.mImg_mark setImage:[UIImage imageNamed:@"hotel_icon_fan_select"]];
    self.mSeleledPolic = self.self.mDataSoure[indexPath.row];
    
    if ([self.mSelectedPassengers containsObject:self.mSeleledPolic]) {
        [self.mSelectedPassengers removeObject:self.mSeleledPolic];
        [self.mSelectedPassengers insertObject:self.mSeleledPolic atIndex:0];
    }else{
       [self.mSelectedPassengers insertObject:self.mSeleledPolic atIndex:0];
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
