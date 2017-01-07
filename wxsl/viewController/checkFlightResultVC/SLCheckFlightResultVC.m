//
//  SLCheckFlightResultVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCheckFlightResultVC.h"
#import "SLSelectPassengerVC.h"
#import "SLFillInOderVC.h"
#import "SLCheckFlightVC.h"

#import "SLCheckResultCell.h"
#import "CCActionSheet.h"
@interface SLCheckFlightResultVC ()<UITableViewDelegate,UITableViewDataSource,SLCheckResultCellDelegate,CCActionSheetDelegate>
/**
 *  出发城市
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_formCity;
/**
 *  到达城市
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_toCity;
/**
 *  出发时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_formTime;
/**
 *  到达时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_toTime;
/**
 *  出发机场
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_formAirport;
/**
 *  到达机场
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_tomAirport;
/**
 *  日期
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_date;
/**
 *  经历时间
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_contetTime;
@property (weak, nonatomic) IBOutlet UILabel *mLB_content;

@property (weak, nonatomic) IBOutlet UITableView *minfoTableView;

@property(nonatomic,retain)NSArray *mDataSoure;
@end

@implementation SLCheckFlightResultVC{
    SLRBDModel *_selectRBDModel;
    
    int bookRange;//是否需要违规检查
    
   // NSArray *_illegalReasonLists;//违规原因列表
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.minfoTableView.tableFooterView = [UIView new];
    
    if (self.mBackFlightInfoDIC) {
        self.mLB_formCity.text = self.mBackFlightInfoDIC[@"toCityStr"];
        self.mLB_toCity.text = self.mBackFlightInfoDIC[@"fromCityStr"];
        self.mLB_formTime.text = [self stringWithDateStr:self.mBackFightMode.mFormTime];
        self.mLB_toTime.text = [self stringWithDateStr:self.mBackFightMode.mArriveTime];
        
        if ([self.mBackFightMode.mShare boolValue]) {
            self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.mBackFightMode.mUseTime  intValue]/60/60,[self.mBackFightMode.mUseTime  intValue]/60%60,@"经停"];
            
        }else{
            self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.mBackFightMode.mUseTime  intValue]/60/60,[self.mBackFightMode.mUseTime  intValue]/60%60,@"直接"];
        }
        self.mLB_formAirport.text = [NSString stringWithFormat:@"%@%@",self.mBackFightMode.mFormAirport,self.mBackFightMode.mformTerm];
        self.mLB_tomAirport.text = [NSString stringWithFormat:@"%@%@",self.mBackFightMode.mArriveAirport,self.mBackFightMode.marrTerm];
        self.mLB_date.text = self.mBackFightMode.mFlightDate;
        self.mLB_content.text = [NSString stringWithFormat:@"%@ %@%@ %@",self.mBackFightMode.mAirlineName,self.mBackFightMode.mAirCode,self.mBackFightMode.mFlightno,self.mBackFightMode.mAirModel];
    }else{
        self.mLB_formCity.text = self.mFlightInfoDIC[@"fromCityStr"];
        self.mLB_toCity.text = self.mFlightInfoDIC[@"toCityStr"];
        self.mLB_formTime.text = [self stringWithDateStr:self.fightMode.mFormTime];
        self.mLB_toTime.text = [self stringWithDateStr:self.fightMode.mArriveTime];
        if ([self.fightMode.mStop boolValue]) {
            self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.fightMode.mUseTime  intValue]/60/60,[self.fightMode.mUseTime  intValue]/60%60,@"经停"];
            
        }else{
            self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.fightMode.mUseTime  intValue]/60/60,[self.fightMode.mUseTime  intValue]/60%60,@"直接"];
        }
        self.mLB_formAirport.text = [NSString stringWithFormat:@"%@%@",self.fightMode.mFormAirport,self.fightMode.mformTerm];
        self.mLB_tomAirport.text = [NSString stringWithFormat:@"%@%@",self.fightMode.mArriveAirport,self.fightMode.marrTerm];
        self.mLB_date.text = self.fightMode.mFlightDate;
        self.mLB_content.text = [NSString stringWithFormat:@"%@ %@%@ %@",self.fightMode.mAirlineName,self.fightMode.mAirCode,self.fightMode.mFlightno,self.fightMode.mAirModel];
    }
    
    bookRange = 2;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        
        NSArray *tempCabs;
        if (self.mBackFightMode) {
            tempCabs = self.mBackFightMode.mCabinfos;
        }else{
            tempCabs = self.fightMode.mCabinfos;
        }
        
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLRBDModel class] fromJSONArray:tempCabs error:&error];
        _mDataSoure = temp;
    }
    return _mDataSoure;
}
#pragma mark private
-(NSString *)stringWithDateStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:timeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
-(void)checkWhetherIllegalBook:(void(^)(bool reslut))block{
    
    __block bool result = YES;
    
    if([MyFounctions getUserDetailInfo] == nil || [[MyFounctions getUserInfo] allKeys] == 0){
        return;
    }
    NSString *mPassID = [[MyFounctions getUserDetailInfo][@"passengerId"] stringValue];
    
    if (mPassID == nil || mPassID.length==0) {
        mPassID = @"";
    }
    NSDictionary * paramDic = @{@"userId":sl_userID,@"passengerId":mPassID,@"flightDate":self.fightMode.mFlightDate,@"discount":_selectRBDModel.mRBDDiscount};
    
//    [SLNetWorkingStatusView show];
    [SVProgressHUD show];
    [HttpApi checkWhetherIllegalBook:paramDic SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        if ([responseBody[@"illegalJudgment"] integerValue] == 1) {
            //需要违规判定
            if ([responseBody[@"illegalBook"] integerValue] == 1) {
                self.illegalReasonLists = responseBody[@"illegalReasonLists"];
            }else{
                ShowMSG(@"违规预定");
                result = NO;
            }
        }
        
        if (block) {
            block(result);
        }
        
    } FailureBlock:^(NSError *error) {
        result = NO;
        if (block) {
            block(result);
        }
    }];

}
#pragma mark event response
- (IBAction)onclickGoBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark CCActionSheetDelegate
- (void)cc_actionSheetDidSelectedIndex:(NSInteger)index SelectBtn:(UIButton *)sender{
    
    if(index == 0){
        return;
    }
    
    NSString *tempTripType = self.mFlightInfoDIC[@"tripType"];
    
    if ([SLSimpleInterest shareNetWork].mTrType - 10 ==  0) {
        //因共
        if (bookRange == 2) {
            //可以为他人预定
            if([tempTripType integerValue] == 1){
                //单程
                if (index == 1) {
                    //因共
                    [self checkWhetherIllegalBook:^(bool reslut) {
                        
                        if (reslut) {
                            SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                            mtempVC.TicketType = principal;
                            mtempVC.ReasonType = company;
                            mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                            mtempVC.fightMode = self.fightMode;
                            mtempVC.mSelectRBDModel = _selectRBDModel;
                            mtempVC.illegalReasonLists = self.illegalReasonLists;
                            [self.navigationController pushViewController:mtempVC animated:YES];
                            
                        }
                    }];
                    
                }else if (index == 2){
                    //因公为他人预定预定
                    SLSelectPassengerVC *mtempVC = [[SLSelectPassengerVC alloc]init];
                    mtempVC.QTicketType = Others;
                    mtempVC.QReasonType = company;
                    mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                    mtempVC.fightMode = self.fightMode;
                    mtempVC.mSelectRBDModel = _selectRBDModel;
                    [self.navigationController pushViewController:mtempVC animated:YES];
                }
            }else{
                //往返
                if (index == 1) {
                    if (self.mQSelectRBDModel) {
                        //                    SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                        //                    mtempVC.TicketType = principal;
                        //                    mtempVC.ReasonType = company;
                        //                    mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        //                    mtempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
                        //                    mtempVC.fightMode = self.fightMode;
                        //                    mtempVC.mBackFightMode = self.mBackFightMode;
                        //                    mtempVC.mSelectRBDModel = _selectRBDModel;
                        //                    mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        //                    [self.navigationController pushViewController:mtempVC animated:YES];
                        
                    }else{
                        SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                        mTempVC.mBackFlightInfoDIC = self.mFlightInfoDIC;
                        mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mTempVC.QTicketType = principal;
                        mTempVC.QReasonType = company;
                        mTempVC.fightMode = self.fightMode;
                        mTempVC.mQSelectRBDModel = _selectRBDModel;
                        [self.navigationController pushViewController:mTempVC animated:YES];
                    }
                }else if (index == 2){
                    
                    if (self.mQSelectRBDModel) {
                        //                    SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                        //                    mtempVC.TicketType = Others;
                        //                    mtempVC.ReasonType = company;
                        //                    mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        //                    mtempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
                        //                    mtempVC.fightMode = self.fightMode;
                        //                    mtempVC.mBackFightMode = self.mBackFightMode;
                        //                    mtempVC.mSelectRBDModel = _selectRBDModel;
                        //                    mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                        //                    [self.navigationController pushViewController:mtempVC animated:YES];
                        
                    }else{
                        //因公为他人预定预定
                        SLSelectPassengerVC *mtempVC = [[SLSelectPassengerVC alloc]init];
                        mtempVC.QTicketType = Others;
                        mtempVC.QReasonType = company;
                        mtempVC.mBackFlightInfoDIC = self.mFlightInfoDIC;
                        mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                        mtempVC.fightMode = self.fightMode;
                        mtempVC.mQSelectRBDModel = _selectRBDModel;
                        [self.navigationController pushViewController:mtempVC animated:YES];
                        
                    }
                    
                }
            }
            
        }else{
            //只能为自己预定
            if([tempTripType integerValue] == 1){
                //单程
                if (index == 1) {
                    //因共
                    [self checkWhetherIllegalBook:^(bool reslut) {
                        [SVProgressHUD dismiss];
                        if (reslut) {
                            SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                            mtempVC.TicketType = principal;
                            mtempVC.ReasonType = company;
                            mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                            mtempVC.fightMode = self.fightMode;
                            mtempVC.mBackFightMode = self.mBackFightMode;
                            mtempVC.mSelectRBDModel = _selectRBDModel;
                            mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                            mtempVC.illegalReasonLists = self.illegalReasonLists;
                            [self.navigationController pushViewController:mtempVC animated:YES];
                        }
                    }];
                }
            }
        }
    }else{
        //因私
        if([tempTripType integerValue] == 1){
            SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
            mtempVC.TicketType = principal;
            mtempVC.ReasonType = personal;
            mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
            mtempVC.fightMode = self.fightMode;
            mtempVC.mSelectRBDModel = _selectRBDModel;
            //                mtempVC.illegalReasonLists = self.illegalReasonLists;
            [self.navigationController pushViewController:mtempVC animated:YES];
        }else{
            //往返
            if (self.mQSelectRBDModel) {
                //                SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                //                mtempVC.TicketType = principal;
                //                mtempVC.ReasonType = personal;
                //                mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                //                mtempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
                //                mtempVC.fightMode = self.fightMode;
                //                mtempVC.mBackFightMode = self.mBackFightMode;
                //                mtempVC.mSelectRBDModel = _selectRBDModel;
                //                mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                //                mtempVC.illegalReasonLists = _illegalReasonLists;
                //                [self.navigationController pushViewController:mtempVC animated:YES];
                
            }else{
                SLCheckFlightVC *mTempVC = [[SLCheckFlightVC alloc]init];
                mTempVC.QTicketType = principal;
                mTempVC.QReasonType = personal;
                mTempVC.mBackFlightInfoDIC = self.mFlightInfoDIC ;
                mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                mTempVC.fightMode = self.fightMode;
                mTempVC.mQSelectRBDModel = _selectRBDModel;
                //mTempVC.illegalReasonLists = _illegalReasonLists;
                [self.navigationController pushViewController:mTempVC animated:YES];
            }
        }
    }
}
#pragma mark SLCheckResultCellDelegate
-(void)SLCheckResultCell:(SLCheckResultCell *)cell onclickTGQBtn:(UIButton *)sender{
    
    NSIndexPath *index = [self.minfoTableView indexPathForCell:cell];
    SLRBDModel *temp = [self.mDataSoure objectAtIndex:index.row];
    NSString *tempStr = [NSString stringWithFormat:@"%@\n%@\n%@\n",temp.mRBDRefund,temp.mRBDTransfer,temp.mRBDCdate];
    [[CCActionSheet shareSheet]cc_showTuiGaiQianView:@"退改签政策" contentStr:tempStr cancelTitle:@"退出" delegate:self];
    
//    [[CCActionSheet shareSheet]cc_showTuiGaiQianView:@"退改签政策" contentStr:@"退票规定：起飞前两小时(含)前，退票费20%\n起飞前两小时内及飞后，退票费30%\n改期规定：起飞前两个小时(含)前，改期费10%\n起飞前两小时内及起飞后，改期费20%\n签转规定：不得签转\n" cancelTitle:@"退出" delegate:self];
}
-(void)SLCheckResultCell:(SLCheckResultCell *)cell onclickReserveBtn:(UIButton *)sender{
   // LDLOG(@"预定");
    
    NSIndexPath *index = [self.minfoTableView indexPathForCell:cell];
    SLRBDModel *temp = [self.mDataSoure objectAtIndex:index.row];
    _selectRBDModel = temp;
    NSMutableDictionary *dic;
    if (self.mBackFlightInfoDIC) {
        dic = [NSMutableDictionary dictionaryWithDictionary:self.mBackFlightInfoDIC];
        [dic setObject:temp.mRBDCode forKey:@"cabin"];
        [dic setObject:temp.mRBDPrice forKey:@"price"];
        [dic setObject:[NSString stringWithFormat:@"%@%@",self.fightMode.mAirCode,self.fightMode.mFlightno] forKey:@"flight"];
    }else{
        [self.mFlightInfoDIC setObject:temp.mRBDCode forKey:@"cabin"];
        [self.mFlightInfoDIC setObject:temp.mRBDPrice forKey:@"price"];
        [self.mFlightInfoDIC setObject:[NSString stringWithFormat:@"%@%@",self.fightMode.mAirCode,self.fightMode.mFlightno] forKey:@"flight"];
        
        dic = [NSMutableDictionary dictionaryWithDictionary:self.mFlightInfoDIC];
    }
    
    [SVProgressHUD showWithStatus:@"检查价格变动"];
    [HttpApi checkPriceChanges:dic SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        if (self.mQSelectRBDModel) {
             [SVProgressHUD dismiss];
            if(self.mSelectedPassengers && self.mSelectedPassengers.count >0){
                SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                mtempVC.TicketType = self.QTicketType;
                mtempVC.ReasonType = self.QReasonType;
                mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                mtempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
                mtempVC.fightMode = self.fightMode;
                mtempVC.mBackFightMode = self.mBackFightMode;
                mtempVC.mSelectRBDModel = _selectRBDModel;
                mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                mtempVC.isViolation = self.isViolation;
                mtempVC.mSelectedPassengers = self.mSelectedPassengers;
                mtempVC.illegalReasonLists = self.illegalReasonLists;;
                mtempVC.mSeleledPolic = self.mSeleledPolic;
                [self.navigationController pushViewController:mtempVC animated:YES];
            }else{
                SLFillInOderVC *mtempVC = [[SLFillInOderVC alloc]init];
                mtempVC.TicketType = self.QTicketType;
                mtempVC.ReasonType = self.QReasonType;
                mtempVC.mFlightInfoDIC = self.mFlightInfoDIC;
                mtempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
                mtempVC.fightMode = self.fightMode;
                mtempVC.mBackFightMode = self.mBackFightMode;
                mtempVC.mSelectRBDModel = _selectRBDModel;
                mtempVC.mQSelectRBDModel = self.mQSelectRBDModel;
                 mtempVC.illegalReasonLists = self.illegalReasonLists;
                [self.navigationController pushViewController:mtempVC animated:YES];
            }
            
            
        }else{
            
            bookRange = [responseBody[@"bookRange"] intValue];
            
            if ([SLSimpleInterest shareNetWork].mTrType - 10 == 0) {
                if (bookRange == 1) {
                    // 只能为自己预定
                    [[CCActionSheet shareSheet]cc_actionSheetWithSelectArray:@[@"因公,为本人预定"] deltalArray:@[@"因公,为本人预定"] cancelTitle:@"取消" delegate:self  titile:@"选择预定类型"];
                    return ;
                    
                }else{
                    [[CCActionSheet shareSheet]cc_actionSheetWithSelectArray:@[@"因公,为本人预定",@"因公,为他人预定"] deltalArray:@[@"因公,为本人预定",@"因公,为他人预定"] cancelTitle:@"取消" delegate:self  titile:@"选择预定类型"];
                }
            }else{
                [[CCActionSheet shareSheet]cc_actionSheetWithSelectArray:@[@"因私预定"] deltalArray:@[@"因私预定"] cancelTitle:@"取消" delegate:self  titile:@"选择预定类型"];
                return ;
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndentifier = @"SLCheckResultCell";
    [tableView registerNib:[UINib nibWithNibName:@"SLCheckResultCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    SLCheckResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    [cell loadCellInfo:self.mDataSoure[indexPath.row]];
    cell.delegate = self;
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
