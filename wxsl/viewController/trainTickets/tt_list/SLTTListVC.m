//
//  SLTTListVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/25.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTTListVC.h"
#import "SLCheckFlightInfoView.h"
#import "SLCheckFlightResultVC.h"

#import "SLCheckTrainCell.h"
#import "SLTTFilterView.h"

#import "SLMyPolicyView.h"

#define BackGroundColor SL_BULE

@interface SLTTListVC ()
@property (weak, nonatomic) IBOutlet UILabel *mLB_fromCity;
@property (weak, nonatomic) IBOutlet UILabel *mLB_arrivalCity;
@property (weak, nonatomic) IBOutlet UILabel *mLB_numofAllFlight;
@property (weak, nonatomic) IBOutlet UILabel *mLB_time;
@property (weak, nonatomic) IBOutlet UIButton *mLB_bedrockPrice;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;

@property(nonatomic,retain)UIImageView *mBGImgeView;
/**
 *  展示列表
 */
@property(nonatomic,retain)NSMutableArray *mDataSoure;
/**
 *  航司列表
 */
@property (nonatomic,retain   ) NSArray  * mAirlines;
/**
 *  机场列表
 */
@property (nonatomic,retain   ) NSArray  * mAirports;
/**
 *  车次列表
 */
@property (nonatomic,retain   ) NSArray  * mFights;
@end

@implementation SLTTListVC{
    BOOL _timeSort;
    BOOL _priceSort;
    
    SLTTFilterView *_mFilterView;
}


#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGroundColor;
    
    [self.mInfoTableView setTableFooterView:[UIView new]];
    
    [self.mInfoTableView setBackgroundView:self.mBGImgeView];
    
    _timeSort = YES;
    _priceSort = YES;
    
    self.mLB_time.text = [NSString stringWithFormat:@"%@  %@",[self.mFlightInfoDIC[@"fromDate"] substringFromIndex:5],[self getWeekDayWithStr:self.mFlightInfoDIC[@"fromDate"]]];

    
     [self getFightInfoWithNetWorking:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
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
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
-(NSArray *)mAirlines{
    if (_mAirlines == nil) {
        _mAirlines = [NSArray array];
    }
    return _mAirlines;
}
-(NSArray *)mAirports{
    if (_mAirports == nil) {
        _mAirports = [NSArray array];
    }
    return _mAirports;
}
-(UIImageView *)mBGImgeView{
    if (_mBGImgeView == nil) {
        _mBGImgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flight_img_complete_bg"]];
    }
    return _mBGImgeView;
}
#pragma mark private
-(void)getFightInfoWithNetWorking:(void (^)(bool result))comple{
    [self.mDataSoure removeAllObjects];
    
    [SLNetWorkingStatusView show];
    NSMutableDictionary *dic;
    dic = self.mFlightInfoDIC;
    
    [HttpApi searchTrainTicketsList:dic SuccessBlock:^(id responseBody) {
        // LDLOG(@"%@",responseBody);
        
        NSArray *mFights = responseBody[@"trains"];
        NSArray *mAirports = responseBody[@"stations"];
        NSArray *mAirLines = responseBody[@"airlines"];
        self.mAirports = mAirports;
        self.mAirlines = mAirLines;
        
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLTTListModel class] fromJSONArray:mFights error:&error];
        
        self.mFights = temp;
        
        [self.mDataSoure addObjectsFromArray:temp];
        
        
        SLTTListModel *tempModel;
        for (int i = 0; i<self.mDataSoure.count; i++) {
            if (tempModel) {
                SLTTListModel *tempModel2 = temp[i];
                SLTTListModel *tempModel1 = tempModel;
                if (tempModel1.mminPrice < tempModel2.mminPrice) {
                    tempModel = tempModel1;
                }else{
                    tempModel = tempModel2;
                }
            }else{
                tempModel = temp[0];
            }
        }
        
        if([tempModel.mminPrice isEqual:[NSNull null]] || tempModel.mminPrice==nil){
            [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",@"0"] forState:UIControlStateNormal];
        }else{
            [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",tempModel.mminPrice] forState:UIControlStateNormal];
        }
        
        self.mLB_numofAllFlight.text = [NSString stringWithFormat:@"共有%lu个车次信息",(unsigned long)[self.mDataSoure count]];
        
        
        [self.mInfoTableView reloadData];
        
        if (comple) {
            comple(YES);
        }
        
    } FailureBlock:^(NSError *error) {
        if (comple) {
            comple(NO);
        }
    }];
}
-(NSString *)getWeekDayWithStr:(NSString *)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[formatter dateFromString:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                        fromDate:date];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    
    switch (weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            return @"";
            break;
    }
}
#pragma mark event response
- (IBAction)onclickGoBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//商旅政策
- (IBAction)onclickSLPolicyBtn:(UIButton *)sender {
    
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
        [self.navigationController.view addSubview:mOrderVC];
        [mOrderVC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
//前一天
- (IBAction)onclickYesterdayBtn:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date;
    date =[formatter dateFromString:self.mFlightInfoDIC[@"fromDate"]];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 24*3600)];
    
    NSDate *newDate1 = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] - 24*3600)];
    
    if ([newDate  timeIntervalSinceDate:newDate1]<= 0.0) {
        ShowMSG(@"出发时间必须大于当前时间");
        return;
        
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:newDate];
    [self.mFlightInfoDIC setObject:destDateString forKey:@"fromDate"];
    self.mLB_time.text = [NSString stringWithFormat:@"%@  %@",[self.mFlightInfoDIC[@"fromDate"] substringFromIndex:5],[self getWeekDayWithStr:self.mFlightInfoDIC[@"fromDate"]]];
    
    [SLNetWorkingStatusView show];
    [self getFightInfoWithNetWorking:^(bool result) {
        if (result == NO) {
            NSString *destDateString = [dateFormatter stringFromDate:date];
            [self.mFlightInfoDIC setObject:destDateString forKey:@"fromDate"];
        }
        
        self.mLB_time.text = [NSString stringWithFormat:@"%@  %@",[self.mFlightInfoDIC[@"fromDate"] substringFromIndex:5],[self getWeekDayWithStr:self.mFlightInfoDIC[@"fromDate"]]];
    }];
    
}
//后一天
- (IBAction)onclickOneDayAfterBtn:(UIButton *)sender {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date;
    date =[formatter dateFromString:self.mFlightInfoDIC[@"fromDate"]];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*3600)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:newDate];
    
    self.mLB_time.text = [NSString stringWithFormat:@"%@  %@",[self.mFlightInfoDIC[@"fromDate"] substringFromIndex:5],[self getWeekDayWithStr:self.mFlightInfoDIC[@"fromDate"]]];
    
    [self.mFlightInfoDIC setObject:destDateString forKey:@"fromDate"];
    
    [self getFightInfoWithNetWorking:^(bool result) {
        if (result == NO) {
            NSString *destDateString = [dateFormatter stringFromDate:date];
            [self.mFlightInfoDIC setObject:destDateString forKey:@"fromDate"];
            
        }
        
        self.mLB_time.text = [NSString stringWithFormat:@"%@  %@",[self.mFlightInfoDIC[@"fromDate"] substringFromIndex:5],[self getWeekDayWithStr:self.mFlightInfoDIC[@"fromDate"]]];
    }];
}
//筛选
- (IBAction)onclickFilterBtn:(UIButton *)sender {
    
    if (_mFilterView == nil) {
        _mFilterView = [[NSBundle mainBundle]loadNibNamed:@"SLTTFilterView" owner:nil options:nil][0];
    }
    [self.navigationController.view addSubview:_mFilterView];
    [_mFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    _mFilterView.delegate = self;
    _mFilterView.mAirlines = self.mAirlines;
    _mFilterView.mAirports = self.mAirports;
    [_mFilterView show];
    
}
//价格排序
- (IBAction)onclickPriceFilerBtn:(UIButton *)sender {
    _priceSort =!_priceSort;
    
    [self.mInfoTableView setContentOffset:CGPointZero];
    
    if (_priceSort == NO) {
        [sender setImage:[UIImage imageNamed:@"flight_jg"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"flight_jg_un"] forState:UIControlStateNormal];
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"_mminPrice" ascending:!_priceSort];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [self.mDataSoure sortUsingDescriptors:descriptors];
    [self.mInfoTableView reloadData];
    
}
//时间排序
- (IBAction)onclickTimeFilerBtn:(UIButton *)sender {
    _timeSort =!_timeSort;
    
    [self.mInfoTableView setContentOffset:CGPointZero];
    
    if (_timeSort == NO) {
        [sender setImage:[UIImage imageNamed:@"flight_sj"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"flight_sj_un"] forState:UIControlStateNormal];
    }
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"_mdepTime" ascending:_timeSort];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [self.mDataSoure sortUsingDescriptors:descriptors];
    [self.mInfoTableView reloadData];
}
- (IBAction)onclickLowPirceBtn:(UIButton *)sender {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"_mminPrice" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    [self.mDataSoure sortUsingDescriptors:descriptors];
    [self.mInfoTableView reloadData];
}
#pragma mark SLCheckFlightInfoViewDelegate
//显示共享车次
-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view onclickHideFightBtn:(UIButton *)sender{
    
    [self.mInfoTableView setContentOffset:CGPointZero];
    
    if ([sender.titleLabel.text isEqualToString:@"显示共享车次"]) {
        [sender setTitle:@"隐藏共享车次" forState:UIControlStateNormal];
        
        [self.mDataSoure removeAllObjects];
        [self.mDataSoure addObjectsFromArray:self.mFights];
    }else{
        [sender setTitle:@"显示共享车次" forState:UIControlStateNormal];
        
        [self.mDataSoure removeAllObjects];
        
        for (SLCheckFightModel *tempModel in self.mFights) {
            if ([tempModel.mShare boolValue] == NO) {
                [self.mDataSoure addObject:tempModel];
            }
        }
    }
    
    self.mLB_numofAllFlight.text = [NSString stringWithFormat:@"共有%lu个车次信息",(unsigned long)[self.mDataSoure count]];
    
    SLCheckFightModel *tempModel;
    for (int i = 0; i<self.mDataSoure.count; i++) {
        if (tempModel) {
            SLCheckFightModel *tempModel2 = self.mDataSoure[i];
            SLCheckFightModel *tempModel1 = tempModel;
            if (tempModel1.mPrice < tempModel2.mPrice) {
                tempModel = tempModel1;
            }else{
                tempModel = tempModel2;
            }
        }else{
            tempModel = self.mDataSoure[0];
        }
    }
    
    if([tempModel.mPrice isEqual:[NSNull null]] || tempModel.mPrice==nil){
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",@"0"] forState:UIControlStateNormal];
    }else{
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",tempModel.mPrice] forState:UIControlStateNormal];
    }
    [self.mInfoTableView reloadData];
}
//排除经停
-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view onclickStopsBtn:(UIButton *)sender{
    
    [self.mInfoTableView setContentOffset:CGPointZero];
    
    if ([sender.titleLabel.text isEqualToString:@"排除经停"]) {
        [sender setTitle:@"显示经停" forState:UIControlStateNormal];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (SLCheckFightModel *tempModel in self.mDataSoure) {
            if ([tempModel.mShare boolValue]) {
                [tempArray addObject:tempModel];
                
            }
        }
        
        for (SLCheckFightModel *tempModel1 in tempArray) {
            [self.mDataSoure removeObject:tempModel1];
        }
        
    }else{
        [sender setTitle:@"排除经停" forState:UIControlStateNormal];
        [self.mDataSoure removeAllObjects];
        for (SLCheckFightModel *tempModel in self.mFights) {
            if ([tempModel.mShare boolValue] == NO) {
                [self.mDataSoure addObject:tempModel];
            }
        }
    }
    
    self.mLB_numofAllFlight.text = [NSString stringWithFormat:@"共有%lu个车次信息",(unsigned long)[self.mDataSoure count]];
    
    SLCheckFightModel *tempModel;
    for (int i = 0; i<self.mDataSoure.count; i++) {
        if (tempModel) {
            SLCheckFightModel *tempModel2 = self.mDataSoure[i];
            SLCheckFightModel *tempModel1 = tempModel;
            if (tempModel1.mPrice < tempModel2.mPrice) {
                tempModel = tempModel1;
            }else{
                tempModel = tempModel2;
            }
        }else{
            tempModel = self.mDataSoure[0];
        }
    }
    
    if([tempModel.mPrice isEqual:[NSNull null]] || tempModel.mPrice==nil){
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",@"0"] forState:UIControlStateNormal];
    }else{
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",tempModel.mPrice] forState:UIControlStateNormal];
    }
    
    [self.mInfoTableView reloadData];
}
-(void)SLCheckFlightInfoView:(SLCheckFlightInfoView *)view currentActionType:(ENUM_ActionType)type selctInfo:(NSString *)info selectIndex:(NSIndexPath *)index{
    
    [self.mDataSoure removeAllObjects];
    [self.mDataSoure addObjectsFromArray:self.mFights];
    
    [self.mInfoTableView setContentOffset:CGPointZero];
    
    if (index.row == 0) {
        //不限
        [self.mInfoTableView reloadData];
        return;
    }
    
    
    if (type == ENUM_ActionTypeTime) {
        //起飞时间
        if (info == nil || info.length == 0) {
            return;
        }
        
        NSArray *mTimeInterval = [info componentsSeparatedByString:@"--"];
        if (mTimeInterval.count == 2) {
            NSString *tempStarTimeStr = mTimeInterval[0];
            NSString *tempEndTimeStr = mTimeInterval[1];
            NSString *StarTimeStr = [tempStarTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""];
            NSString *EndTimeStr = [tempEndTimeStr stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            for (SLCheckFightModel *tempModel in self.mFights) {
                // LDLOG(@"--------%@",tempModel.mFormTime);
                if (tempModel.mFormTime.length>10) {
                    NSString *sometime = [tempModel.mFormTime substringFromIndex:10];
                    NSString *sometime1 = [sometime substringWithRange:NSMakeRange(0, sometime.length - 2)];
                    NSString *sometimeStr = [sometime1 stringByReplacingOccurrencesOfString:@":" withString:@""];
                    if ([StarTimeStr intValue]<=[sometimeStr intValue] && [sometimeStr intValue]<=[EndTimeStr intValue]) {
                        //LDLOG(@"=========%@",sometimeStr);
                    }else{
                        [self.mDataSoure removeObject:tempModel];
                    }
                }
            }
        }
    }
    
    if (type == ENUM_ActionTypeAirport) {
        //机场
        
        NSArray *mTempArray = (NSArray *)info;
        if (mTempArray== nil || mTempArray.count ==0) {
            return;
        }
        
        if (index.section == 0) {
            //起飞机场
            for (SLCheckFightModel *tempModel in self.mFights) {
                if ([tempModel.mFormAirport isEqual:mTempArray[0][@"name"]]) {
                    
                }else{
                    [self.mDataSoure removeObject:tempModel];
                }
            }
        }
        
        
        if (index.section == 1) {
            //到达机场
            for (SLCheckFightModel *tempModel in self.mFights) {
                if ([tempModel.mArriveAirport isEqual:mTempArray[0][@"name"]]) {
                    
                }else{
                    [self.mDataSoure removeObject:tempModel];
                }
            }
        }
    }
    
    if (type == ENUM_ActionTypeFlyType) {
        //机型
    }
    
    if (type == ENUM_ActionTypeRBD) {
        //舱位
        for (SLCheckFightModel *tempModel in self.mFights) {
            NSArray *mtempRBD = tempModel.mCabinfos;
            for (NSDictionary *RBDInfo in mtempRBD) {
                NSString *mRBDName = RBDInfo[@"name"];
                if ([info containsString:@"/"]) {
                    NSArray *temp = [info componentsSeparatedByString:@"/"];
                    if ([temp[0] isEqualToString:mRBDName] || [temp[1] isEqualToString:mRBDName]) {
                        if ([self.mDataSoure containsObject:tempModel] == NO) {
                            [self.mDataSoure addObject:tempModel];
                        }
                        break;
                    }else{
                        [self.mDataSoure removeObject:tempModel];
                    }
                }else{
                    
                    if ([info isEqualToString:mRBDName]) {
                        if ([self.mDataSoure containsObject:tempModel] == NO) {
                            [self.mDataSoure addObject:tempModel];
                        }
                        break;
                        
                    }else{
                        [self.mDataSoure removeObject:tempModel];
                    }
                }
            }
        }
    }
    
    if (type == ENUM_ActionTypeAirline) {
        
        NSDictionary *tempDic = (NSDictionary *)info;
        
        if (tempDic == nil || [tempDic allKeys].count == 0) {
            return;
        }
        
        for (SLCheckFightModel *tempModel in self.mFights) {
            if ([tempModel.mAirlineName isEqual:tempDic[@"name"]]) {
                
            }else{
                [self.mDataSoure removeObject:tempModel];
            }
        }
    }
    
    self.mLB_numofAllFlight.text = [NSString stringWithFormat:@"共有%lu个车次信息",(unsigned long)[self.mDataSoure count]];
    
    SLCheckFightModel *tempModel;
    for (int i = 0; i<self.mDataSoure.count; i++) {
        if (tempModel) {
            SLCheckFightModel *tempModel2 = self.mDataSoure[i];
            SLCheckFightModel *tempModel1 = tempModel;
            if (tempModel1.mPrice < tempModel2.mPrice) {
                tempModel = tempModel1;
            }else{
                tempModel = tempModel2;
            }
        }else{
            tempModel = self.mDataSoure[0];
        }
    }
    
    if([tempModel.mPrice isEqual:[NSNull null]] || tempModel.mPrice==nil){
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",@"0"] forState:UIControlStateNormal];
    }else{
        [self.mLB_bedrockPrice setTitle:[NSString stringWithFormat:@"最低价格￥%@",tempModel.mPrice] forState:UIControlStateNormal];
    }
    
    [self.mInfoTableView reloadData];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    CATransform3D rotation;
    //    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    //    rotation.m34 = 1.0/ -600;
    //
    //    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    //    cell.layer.shadowOffset = CGSizeMake(10, 10);
    //    cell.alpha = 0;
    //    cell.layer.transform = rotation;
    //    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    //
    //
    //    [UIView beginAnimations:@"rotation" context:NULL];
    //    [UIView setAnimationDuration:0.8];
    //    cell.layer.transform = CATransform3DIdentity;
    //    cell.alpha = 1;
    //    cell.layer.shadowOffset = CGSizeMake(0, 0);
    //    [UIView commitAnimations];
    //
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:0.5 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIndentifier;// = @"SLCheckFlightCell";
    NSString *   cellIBName = @"SLCheckFlightCell";
    cellIndentifier = [NSString stringWithFormat:@"SLCheckTrainCell%ld%ld",indexPath.section,indexPath.row];
    
    if(MainScreenFrame_Height == 667.0){
        cellIBName = @"SLCheckTrainCellPUS";
        cellIndentifier = [NSString stringWithFormat:@"SLCheckTrainCellPUS%ld%ld",indexPath.section,indexPath.row];
        
    }else if (MainScreenFrame_Height == 736.0){
        
        cellIndentifier = [NSString stringWithFormat:@"SLCheckTrainCellPUS+%ld%ld",indexPath.section,indexPath.row];
        cellIBName = @"SLCheckTrainCellPUS+";
    }
    
    [tableView registerNib:[UINib nibWithNibName:cellIBName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    SLCheckTrainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    [cell loadCellInfoWithDic:self.mDataSoure[indexPath.row]];
    [cell setSeats:self.mDataSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SLCheckFlightResultVC *mTempVC = [[SLCheckFlightResultVC alloc]init];
//    SLCheckFightModel *temp = self.mDataSoure[indexPath.row];
//    if (self.mBackFlightInfoDIC) {
//        mTempVC.mBackFightMode = temp;
//        mTempVC.fightMode = self.fightMode;
//        mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
//    }else{
//        mTempVC.fightMode = temp;
//    }
//    mTempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
//    mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
//    mTempVC.mQSelectRBDModel = self.mQSelectRBDModel;
//    mTempVC.isViolation = self.isViolation;
//    mTempVC.mSelectedPassengers = self.mSelectedPassengers;
//    mTempVC.QTicketType = self.QTicketType;
//    mTempVC.QReasonType = self.QReasonType;
//    mTempVC.mSeleledPolic = self.mSeleledPolic;
//    [self.navigationController pushViewController:mTempVC animated:YES];
}

@end
