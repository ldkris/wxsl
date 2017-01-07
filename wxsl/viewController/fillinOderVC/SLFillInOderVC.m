//
//  SLFillInOderVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFillInOderVC.h"
#import "SLSelectPassengerVC.h"
#import "SLTripPipleVC.h"
#import "SLFinishVC.h"
#import "SLSelectAdressVC.h"
#import "SLAddTripPopleVC.h"
#import "SLReturnTicketVC.h"

#import "SLFIFightInfoCell.h"
#import "SLFIInputCell.h"
#import "SLFIInsureInfoCell.h"
#import "SLTripPopleCell.h"
#import "SLFIAttachCell.h"
#import "SLSelectPopleCell.h"
#import "SLAddressCell.h"
#import "SLDJRTableViewCell.h"
#import "SLViolationCell.h"

#import "SLFIFlightInfoView.h"
#import "SLDataPickerView.h"
@interface SLFillInOderVC ()<UITableViewDelegate,UITableViewDataSource,SLDataPickerViewDelegate,SLFIInsureInfoCellDeleagte>
@property (weak, nonatomic) IBOutlet UILabel *mLB_fromCity;
@property (weak, nonatomic) IBOutlet UILabel *mLB_arrivalCity;
@property (weak, nonatomic) IBOutlet UILabel *mLB_moeny;

@property (weak, nonatomic) IBOutlet UIButton *btn_sub;

@property (weak, nonatomic) IBOutlet UITableView *minfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

/**
 *  保险列表
 */
@property(nonatomic,retain)NSArray *mInsurances;

/**
 *  部门列表
 */
@property(nonatomic,retain)NSArray *mDeparts;
@end

@implementation SLFillInOderVC{
    NSString *_mudi;//出行目的
    NSString *_feiyong;//费用归属
    NSString *_beizhu;//备注
    NSString *_OA;
    NSString *_fujia;
    NSString *_bxpz;
    NSString *_psName;
    NSString *_psPhone;
    NSString *_psAdress;
    NSMutableString *_wgReason;
    
    NSString *_IdNum;
    
    NSString *_IdType;
    
    NSString *_numOfIn;
    int _priceOfIn;
    
    UISwitch *_mTempSwtch;
    
    NSIndexPath *_mSelectIndex;
    
    
    UILabel *mTempLable;
    
    SLUserInfoModel*_userInfoModel;
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _priceOfIn = 0;//保险价格
    
    self.minfoTableView.estimatedRowHeight = 44.0f;
    self.minfoTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.mLB_fromCity.text = self.mFlightInfoDIC[@"fromCityStr"];
    self.mLB_arrivalCity.text = self.mFlightInfoDIC[@"toCityStr"];
    

    [self getTrafficInsuranceList:^{
        if (self.mBackFlightInfoDIC) {
            
            if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
                self.mLB_moeny.text =  [NSString stringWithFormat:@"%lu",[self.mSelectRBDModel.mRBDSalePrice integerValue] + _priceOfIn*self.mSelectedPassengers.count +[self.mQSelectRBDModel.mRBDSalePrice integerValue] +_priceOfIn + [self.fightMode.mAirrax integerValue] + [self.mBackFightMode.mAirrax integerValue]];
            }else{
                self.mLB_moeny.text =  [NSString stringWithFormat:@"%lu",[self.mSelectRBDModel.mRBDSalePrice integerValue] +_priceOfIn*self.mSelectedPassengers.count +[self.mQSelectRBDModel.mRBDSalePrice integerValue] +_priceOfIn + [self.fightMode.mAirrax integerValue] + [self.mBackFightMode.mAirrax integerValue]];
            }
        }else{
            
            if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
                self.mLB_moeny.text =  [NSString stringWithFormat:@"%lu",[self.mSelectRBDModel.mRBDSalePrice integerValue] + _priceOfIn*self.mSelectedPassengers.count + [self.fightMode.mAirrax integerValue]];
            }else{
                self.mLB_moeny.text =  [NSString stringWithFormat:@"%ld",
                                        [self.mSelectRBDModel.mRBDSalePrice integerValue] +_priceOfIn + [self.fightMode.mAirrax integerValue]];
            }
            
        }
        
    }];
    _bxpz = @"2";
    _mudi = @"商务谈判/拜访";
    _psName = @"";
    _psPhone = @"";
    _psAdress = @"";
    _numOfIn = @"1";
    _wgReason = [NSMutableString string];
    
    if (self.mSeleledPolic) {
         _feiyong = self.mSeleledPolic.mDname;
    }
  
    if (self.TicketType == 0) {
        [HttpApi getMyTravelPolicyList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
            if ([responseBody[@"approveType"] intValue]>=2) {
                [self.btn_sub setTitle:@"提交审核" forState:UIControlStateNormal];
            }else{
                [self.btn_sub setTitle:@"提交订单" forState:UIControlStateNormal];
            }
        } FailureBlock:^(NSError *error) {
            
        }];
    }else{
        SLPassengerModel *mSeleledPolic = self.mSelectedPassengers[0];
        if ( [mSeleledPolic.mAudit integerValue]>=2) {
            [self.btn_sub setTitle:@"提交审核" forState:UIControlStateNormal];
        }else{
            [self.btn_sub setTitle:@"提交订单" forState:UIControlStateNormal];
        }
    }
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
-(NSArray *)mDeparts{
    if (_mDeparts == nil) {
        _mDeparts = @[@{@"no":@"23",@"name":@"售后部"}];
    }
    
    return _mDeparts;
}
-(NSArray *)mInsurances{
    if (_mInsurances == nil) {
        _mInsurances = [NSArray array];
    }
    
    return _mInsurances;
}
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        
        NSMutableDictionary *userInfoDic = [MyFounctions getUserDetailInfo];
        NSError *error;
        SLUserInfoModel*mtempModel = [MTLJSONAdapter modelOfClass:[SLUserInfoModel class] fromJSONDictionary:userInfoDic error:&error];
        
        
        if (_userInfoModel == nil) {
            _userInfoModel =mtempModel;
        }
        

        if(mtempModel){
             _feiyong = mtempModel.mDName;
            if (self.TicketType == principal) {
                //为本人预定
                if (self.ReasonType == company){
                    //因共
                    if(self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0){
                        
                        NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                        
                        
                        if (self.mInsurances && self.mInsurances.count>0) {
                             _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],@[@"出行的目的",@"备注",@"OA出差申请号"],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel,@"费用归属"]],@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }else{
                            _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],@[@"出行的目的",@"备注",@"OA出差申请号"],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel,@"费用归属"]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }
                    
                        
                    }else{
                        //违规预定
                        NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                        
                        NSMutableArray *mTempV = [NSMutableArray arrayWithObjects:@"政策违规", nil];
                        
                        for (NSDictionary *temp in self.illegalReasonLists) {
                            [mTempV insertObject:temp atIndex:1];
                        }
                        
                        
                        
                        if (self.mInsurances && self.mInsurances.count>0) {
                               _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],mTempV,@[@"出行的目的",@"备注",@"OA出差申请号"],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel,@"费用归属"]],@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }else{
                           _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],mTempV,@[@"出行的目的",@"备注",@"OA出差申请号"],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel,@"费用归属"]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }
                    }
                    
                }else{
                    //因私
                    
                    if(self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0){
                        
                        NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                      
                        if (self.mInsurances && self.mInsurances.count>0) {
                         _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel]],@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }else{
                         _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }
                        
                       
                    }else{
                        
                        NSMutableArray *mTempV = [NSMutableArray arrayWithObjects:@"政策违规", nil];
                        
                        for (NSDictionary *temp in self.illegalReasonLists) {
                            [mTempV insertObject:temp atIndex:1];
                        }
                        
                        NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                        
                        if (self.mInsurances && self.mInsurances.count>0) {
                            _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel]],@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }else{
                            _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],[NSMutableArray arrayWithArray:@[@"登机人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                        }
                    }
                    
                }
                
            }else{
                //为他人预定
                if(self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0){
                    NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                    
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.mSelectedPassengers];
                    [temp insertObject:@"登机人" atIndex:0];
                    [temp insertObject:@"费用归属" atIndex:self.mSelectedPassengers.count +1 ];
                    
                    if (self.mInsurances.count>0 && self.mInsurances) {
                        _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],@[@"出行的目的",@"备注",@"OA出差申请号"],temp,@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                    }else{
                        _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],@[@"出行的目的",@"备注",@"OA出差申请号"],temp,[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                    }
                    
                 
                }else{
                    NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.fightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.fightMode.mFlightDate],[self stringWithDateStr:self.fightMode.mFormTime],self.fightMode.mFormAirport,self.fightMode.mArriveAirport];
                    
                    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.mSelectedPassengers];
                    [temp insertObject:@"登机人" atIndex:0];
                    [temp insertObject:@"费用归属" atIndex:self.mSelectedPassengers.count +1 ];
                    
                    NSMutableArray *mTempV = [NSMutableArray arrayWithObjects:@"政策违规", nil];
                    
                    for (NSDictionary *temp in self.illegalReasonLists) {
                        [mTempV insertObject:temp atIndex:1];
                    }
                    
                    if (self.mInsurances.count>0 && self.mInsurances) {
                      _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],mTempV,@[@"出行的目的",@"备注",@"OA出差申请号"],temp,@[@"交通意外险",[NSString stringWithFormat:@"￥%d/份",_priceOfIn]],[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                    }else{
                      _mDataSoure = [NSMutableArray arrayWithArray:@[@[tempTime,@""],mTempV,@[@"出行的目的",@"备注",@"OA出差申请号"],temp,[NSMutableArray arrayWithArray:@[@"联系人",_userInfoModel]],[NSMutableArray arrayWithArray:@[@"报销凭证"]],@[@"附加信息"]]];
                    }
                    
                }
                
            }
            
        }else{
            _mDataSoure = [NSMutableArray array];
        }
        
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)putMyInfo:(NSDictionary *)userDic{
    [HttpApi putMyInfo:userDic SuccessBlock:^(id responseBody) {
        
        [self getUserInfoNetWroking];
        
    } FailureBlock:^(NSError *error) {
        
    }];

}
-(void)getUserInfoNetWroking{
    
    [HttpApi getUserInfo:@{@"userId":sl_userID} isShowLoadingView:NO SuccessBlock:^(id responseBody) {
         LDLOG(@"用户信息 ==== %@",responseBody);
        [MyFounctions removeUserDetailInfo];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseBody];
        [MyFounctions saveDetailUserInfo:userInfo];
        
        NSError *error;
        SLUserInfoModel*mtempModel = [MTLJSONAdapter modelOfClass:[SLUserInfoModel class] fromJSONDictionary:userInfo error:&error];
        
         _userInfoModel =mtempModel;
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getTrafficInsuranceList:(void(^)())block{
    [SVProgressHUD show];
    [HttpApi getTrafficInsuranceList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
         [SVProgressHUD dismiss];
      //  LDLOG(@"保险列表列表%@",responseBody);
        self.mInsurances = responseBody[@"insurances"];
        if (self.mInsurances.count>0) {
            self.mDataSoure = nil;
            _priceOfIn = [self.mInsurances[0][@"fee"] intValue];
            [self.minfoTableView reloadData];
            if (block) {
                block();
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getDepartListComple:(void(^)())block{
    [SVProgressHUD show];
    [HttpApi getDepartList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
         [SVProgressHUD dismiss];
//        LDLOG(@"部门列表%@",responseBody);
        self.mDeparts = responseBody[@"departs"];
        if (self.mDeparts.count>0) {
            if (block) {
                block();
            }
        }
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark private
-(BOOL)IsChinese:(NSString *)str {
    if(str == nil){
        return NO;
    }
    
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
        
    }
    return NO;
}
-(NSString *)stringWithDateStr:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:timeStr];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
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
#pragma mark Cell点击
#pragma mark 没有违规
//因私订票
-(void)SLTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }
            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    //出行目的
    if(indexPath.section == 1){
        if (indexPath.row == 0) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.tag = 11;
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = @[@"商务谈判/拜访",@"商务考察/视察",@"学习/培训",@"技术支持",@"会展/服务",@"其他"];
            mPickerView.mLB_title.text = @"出行目的";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
    }
    
    //登机人
    if(indexPath.section == 3){
        NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
        if (indexPath.row == [mTemp count] - 1) {
            [self getDepartListComple:^{
                SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
                mPickerView.tag = 12;
                mPickerView.delegate = self;
                mPickerView.mPickerDataSoure = self.mDeparts;
                mPickerView.mLB_title.text = @"费用归属";
                [self.navigationController.view addSubview:mPickerView];
                [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.mas_equalTo(0);
                }];
            }];
        }else if(indexPath.row != [mTemp count] - 1 && indexPath.row != 0){
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            if (model.mDocTypes && model.mDocTypes.count>0) {
                return;
            }
            

            SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
            temp.mUsermodel = model;
            [self.navigationController pushViewController:temp animated:YES];
            [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
                
                NSMutableDictionary *userInfoDic  = [NSMutableDictionary dictionary];
                NSDictionary *tempDic = [MyFounctions getUserDetailInfo];
                if (tempDic && [tempDic allKeys].count>0) {
                    [userInfoDic setObject:sl_userID forKey:@"userId"];
                    [userInfoDic setObject:tempDic[@"zname"] forKey:@"zname"];
                    //                        [userInfoDic setObject:@"" forKey:@"ename"];
                    
                    [userInfoDic setObject:tempDic[@"email"] forKey:@"email"];
                    [userInfoDic setObject:tempDic[@"sex"] forKey:@"sex"];
                    
                    NSString *tempBirthday = tempDic[@"birthday"];
                    if (tempBirthday.length>0 && tempBirthday) {
                        [userInfoDic setObject:tempBirthday forKey:@"birthday"];
                    }
                    
                    NSString *tempHeadimgurl = tempDic[@"headimgurl"];
                    if (tempHeadimgurl.length>0 && tempHeadimgurl) {
                        [userInfoDic setObject:tempHeadimgurl forKey:@"headimgurl"];
                    }
                    
                    NSArray * mdocTypes =@[@{@"type":mPassenger.mIDType,@"no":mPassenger.mIdcard,@"startTime":@"",@"endTime":@""}];
                    NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
                    
                    [userInfoDic setObject:string forKey:@"docTypes"];
                    
                    [self putMyInfo:userInfoDic];
                }
                
                
                _IdNum = mPassenger.mIdcard;
                NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                    SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                    tempcell.mLB_name.text = mPassenger.mName;
                    //cell.mLB_Policy.text = mPassenger.mPolicy;
                    
                    tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                    _IdType = mPassenger.mIDType;
                }else{
                    SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                    tempcell.mLB_name.text = mPassenger.mName;
                    tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                    _IdType = mPassenger.mIDType;
                }
                
            }];

        }
    }

    
    //配送地址
    if(indexPath.section == 5){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                if (model) {
                    _psName = model.mName;
                    _psPhone =  model.mMobile;
                    _psAdress = model.mAddress;;
                }
                
                if ([style integerValue] == 1) {
                    //自取
                    _bxpz = @"2";
                    
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }

}
-(void)SLForSITableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }
            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    
    //登机人
    if(indexPath.section == 1){
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            return;
        }
        
        SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
        temp.mUsermodel = model;
        [self.navigationController pushViewController:temp animated:YES];
        [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
            
            NSMutableDictionary *userInfoDic  = [NSMutableDictionary dictionary];
            NSDictionary *tempDic = [MyFounctions getUserDetailInfo];
            if (tempDic && [tempDic allKeys].count>0) {
                [userInfoDic setObject:sl_userID forKey:@"userId"];
                [userInfoDic setObject:tempDic[@"zname"] forKey:@"zname"];
                //                        [userInfoDic setObject:@"" forKey:@"ename"];
                
                [userInfoDic setObject:tempDic[@"email"] forKey:@"email"];
                [userInfoDic setObject:tempDic[@"sex"] forKey:@"sex"];
                
                NSString *tempBirthday = tempDic[@"birthday"];
                if (tempBirthday.length>0 && tempBirthday) {
                    [userInfoDic setObject:tempBirthday forKey:@"birthday"];
                }
                
                NSString *tempHeadimgurl = tempDic[@"headimgurl"];
                if (tempHeadimgurl.length>0 && tempHeadimgurl) {
                    [userInfoDic setObject:tempHeadimgurl forKey:@"headimgurl"];
                }
                
                NSArray * mdocTypes =@[@{@"type":mPassenger.mIDType,@"no":mPassenger.mIdcard,@"startTime":@"",@"endTime":@""}];
                NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
                
                [userInfoDic setObject:string forKey:@"docTypes"];
                
                [self putMyInfo:userInfoDic];
            }
            
            
            _IdNum = mPassenger.mIdcard;
            NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                tempcell.mLB_name.text = mPassenger.mName;
                //cell.mLB_Policy.text = mPassenger.mPolicy;
                
                tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                _IdType = mPassenger.mIDType;
            }else{
                SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                tempcell.mLB_name.text = mPassenger.mName;
                tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                _IdType = mPassenger.mIDType;
            }
            
        }];


    }
    
    //配送地址
    if(indexPath.section == 4){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                
                if ([style integerValue] == 1) {
                    //自取
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }
    
}
-(void)SLForAnyelseTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }

            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    //出行目的
    if(indexPath.section == 1){
        if (indexPath.row == 0) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.tag = 11;
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = @[@"商务谈判/拜访",@"商务考察/视察",@"学习/培训",@"技术支持",@"会展/服务",@"其他"];
            mPickerView.mLB_title.text = @"出行目的";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
    }
    
    //登机人
    if(indexPath.section == 2){
        
        [self getDepartListComple:^{
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
                mPickerView.tag = 12;
                mPickerView.delegate = self;
                mPickerView.mPickerDataSoure = self.mDeparts;
                mPickerView.mLB_title.text = @"费用归属";
                [self.navigationController.view addSubview:mPickerView];
                [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.right.mas_equalTo(0);
                }];
            }else if(indexPath.row != [mTemp count] - 1 && indexPath.row != 0){
                SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
                if (model.mIdcard && model.mIdcard.length>0) {
                    return;
                }
                
                SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
                temp.mPassenger = model;
                [self.navigationController pushViewController:temp animated:YES];
                [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    _IdNum = mPassenger.mIdcard;
                    NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                    
                    if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                        SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        //cell.mLB_Policy.text = mPassenger.mPolicy;
                        
                        tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                        _IdType = mPassenger.mIDType;
                    }else{
                        SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                        _IdType = mPassenger.mIDType;                    }
                    
                }];
                
            }
        }];
    }
    
    //配送地址
    if(indexPath.section == 5){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                if (model) {
                    _psName = model.mName;
                    _psPhone =  model.mMobile;
                    _psAdress = model.mAddress;;
                }
                
                if ([style integerValue] == 1) {
                    //自取
                    _bxpz = @"2";
                    
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }
    
}
#pragma mark Cell点击
#pragma mark 违规

-(void)ViolationSLTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }
            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    
    if(indexPath.section == 1 && indexPath.row >0){
        SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
        mPickerView.tag = 111;
        mPickerView.delegate = self;
        
        NSMutableArray *mtempArray = [NSMutableArray array];
        for (NSDictionary *dic in self.illegalReasonLists) {
            NSArray *tempStr = dic[@"illegalReasons"];
            for (NSDictionary *dic1  in tempStr) {
                NSString *str = dic1[@"reason"];
                 [mtempArray addObject:str];
            }
           
        }
        mPickerView.mPickerDataSoure = mtempArray;
        mPickerView.mLB_title.text = @"选择违规理由";
        [self.navigationController.view addSubview:mPickerView];
        [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];

    }
    
    //出行目的
    if(indexPath.section == 2){
        if (indexPath.row == 0) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.tag = 11;
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = @[@"商务谈判/拜访",@"商务考察/视察",@"学习/培训",@"技术支持",@"会展/服务",@"其他"];
            mPickerView.mLB_title.text = @"出行目的";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
    }
    
    //登机人
    if(indexPath.section == 3){
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                [self getDepartListComple:^{
                    SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
                    mPickerView.tag = 12;
                    mPickerView.delegate = self;
                    mPickerView.mPickerDataSoure = self.mDeparts;
                    mPickerView.mLB_title.text = @"费用归属";
                    [self.navigationController.view addSubview:mPickerView];
                    [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.left.right.mas_equalTo(0);
                    }];
                }];
            }else if(indexPath.row != [mTemp count] - 1 && indexPath.row != 0){
                SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
                if (model.mDocTypes && model.mDocTypes.count>0) {
                    return;
                }
                
                SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
                temp.mUsermodel = model;
                 [self.navigationController pushViewController:temp animated:YES];

                [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
                    
                    NSMutableDictionary *userInfoDic  = [NSMutableDictionary dictionary];
                    NSDictionary *tempDic = [MyFounctions getUserDetailInfo];
                    if (tempDic && [tempDic allKeys].count>0) {
                        [userInfoDic setObject:sl_userID forKey:@"userId"];
                        [userInfoDic setObject:tempDic[@"zname"] forKey:@"zname"];
//                        [userInfoDic setObject:@"" forKey:@"ename"];

                        [userInfoDic setObject:tempDic[@"email"] forKey:@"email"];
                        [userInfoDic setObject:tempDic[@"sex"] forKey:@"sex"];
                        
                        NSString *tempBirthday = tempDic[@"birthday"];
                        if (tempBirthday.length>0 && tempBirthday) {
                            [userInfoDic setObject:tempBirthday forKey:@"birthday"];
                        }
                        
                        NSString *tempHeadimgurl = tempDic[@"headimgurl"];
                        if (tempHeadimgurl.length>0 && tempHeadimgurl) {
                            [userInfoDic setObject:tempHeadimgurl forKey:@"headimgurl"];
                        }
                      
                        NSArray * mdocTypes =@[@{@"type":mPassenger.mIDType,@"no":mPassenger.mIdcard,@"startTime":@"",@"endTime":@""}];
                        NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
                        
                        [userInfoDic setObject:string forKey:@"docTypes"];
                        
                        [self putMyInfo:userInfoDic];
                    }
                    
                    
                    _IdNum = mPassenger.mIdcard;
                    NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                    
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                        SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        //cell.mLB_Policy.text = mPassenger.mPolicy;
                        
                        tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                        _IdType = mPassenger.mIDType;
                    }else{
                        SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                        _IdType = mPassenger.mIDType;
                    }

                }];
               
            }
    }
    
    //配送地址
    if(indexPath.section == 6){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                if (model) {
                    _psName = model.mName;
                    _psPhone =  model.mMobile;
                    _psAdress = model.mAddress;;
                }
                
                if ([style integerValue] == 1) {
                    //自取
                    _bxpz = @"2";
                    
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }
    
}
-(void)ViolationSLForSITableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }

            
            
            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    
    if(indexPath.section == 1 && indexPath.row >0){
        SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
        mPickerView.tag = 111;
        mPickerView.delegate = self;
        
        NSMutableArray *mtempArray = [NSMutableArray array];
        for (NSDictionary *dic in self.illegalReasonLists) {
            NSArray *tempStr = dic[@"illegalReasons"];
            for (NSDictionary *dic1  in tempStr) {
                NSString *str = dic1[@"reason"];
                [mtempArray addObject:str];
            }
            
        }
        mPickerView.mPickerDataSoure = mtempArray;
        mPickerView.mLB_title.text = @"选择违规理由";
        [self.navigationController.view addSubview:mPickerView];
        [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
    }
    
    //登机人
    if(indexPath.section == 2){
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            return;
        }
        
        SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
        temp.mUsermodel = model;
        [self.navigationController pushViewController:temp animated:YES];
        [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
            
            NSMutableDictionary *userInfoDic  = [NSMutableDictionary dictionary];
            NSDictionary *tempDic = [MyFounctions getUserDetailInfo];
            if (tempDic && [tempDic allKeys].count>0) {
                [userInfoDic setObject:sl_userID forKey:@"userId"];
                [userInfoDic setObject:tempDic[@"zname"] forKey:@"zname"];
                //                        [userInfoDic setObject:@"" forKey:@"ename"];
                
                [userInfoDic setObject:tempDic[@"email"] forKey:@"email"];
                [userInfoDic setObject:tempDic[@"sex"] forKey:@"sex"];
                
                NSString *tempBirthday = tempDic[@"birthday"];
                if (tempBirthday.length>0 && tempBirthday) {
                    [userInfoDic setObject:tempBirthday forKey:@"birthday"];
                }
                
                NSString *tempHeadimgurl = tempDic[@"headimgurl"];
                if (tempHeadimgurl.length>0 && tempHeadimgurl) {
                    [userInfoDic setObject:tempHeadimgurl forKey:@"headimgurl"];
                }
                
                NSArray * mdocTypes =@[@{@"type":mPassenger.mIDType,@"no":mPassenger.mIdcard,@"startTime":@"",@"endTime":@""}];
                NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
                NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
                
                [userInfoDic setObject:string forKey:@"docTypes"];
                
                [self putMyInfo:userInfoDic];
            }
            
            
            _IdNum = mPassenger.mIdcard;
            NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                tempcell.mLB_name.text = mPassenger.mName;
                //cell.mLB_Policy.text = mPassenger.mPolicy;
                
                tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                _IdType = mPassenger.mIDType;
            }else{
                SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                tempcell.mLB_name.text = mPassenger.mName;
                tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                _IdType = mPassenger.mIDType;
            }
            
        }];
    }

    //配送地址
    if(indexPath.section == 5){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                
                if ([style integerValue] == 1) {
                    //自取
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }
    
}
-(void)ViolationSLForAnyelseTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //航班详细信息
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SLFIFlightInfoView*mtempView = [[SLFIFlightInfoView alloc]init];
            if (self.mBackFightMode) {
                [mtempView showFlightInfo:@[self.fightMode,self.mBackFightMode]];
            }else{
                [mtempView showFlightInfo:@[self.fightMode]];
            }

            [self.view addSubview:mtempView];
            [mtempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_equalTo(0);
            }];
        }
    }
    
    if(indexPath.section == 1 && indexPath.row >0){
        SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
        mPickerView.tag = 111;
        mPickerView.delegate = self;
        
        NSMutableArray *mtempArray = [NSMutableArray array];
        for (NSDictionary *dic in self.illegalReasonLists) {
            NSArray *tempStr = dic[@"illegalReasons"];
            for (NSDictionary *dic1  in tempStr) {
                NSString *str = dic1[@"reason"];
                [mtempArray addObject:str];
            }
            
        }
        mPickerView.mPickerDataSoure = mtempArray;
        mPickerView.mLB_title.text = @"选择违规理由";
        [self.navigationController.view addSubview:mPickerView];
        [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(0);
        }];
    }
    
    //出行目的
    if(indexPath.section == 2){
        if (indexPath.row == 0) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.tag = 11;
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = @[@"商务谈判/拜访",@"商务考察/视察",@"学习/培训",@"技术支持",@"会展/服务",@"其他"];
            mPickerView.mLB_title.text = @"出行目的";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
    }
    
    //登机人
    if(indexPath.section == 3){
        
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                [self getDepartListComple:^{
                    SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
                    mPickerView.tag = 12;
                    mPickerView.delegate = self;
                    mPickerView.mPickerDataSoure = self.mDeparts;
                    mPickerView.mLB_title.text = @"费用归属";
                    [self.navigationController.view addSubview:mPickerView];
                    [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.left.right.mas_equalTo(0);
                    }];
                }];
            }else if(indexPath.row != [mTemp count] - 1 && indexPath.row != 0){
                SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
                if (model.mIdcard && model.mIdcard.length>0) {
                    return;
                }
                SLAddTripPopleVC *temp = [[SLAddTripPopleVC alloc]init];
                temp.mPassenger = model;
                [self.navigationController pushViewController:temp animated:YES];
                [temp backInfoBlock:^(SLPassengerModel *mPassenger, SLPassengerModel *mNewPassenger) {
                    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    
                    _IdNum = mPassenger.mIdcard;
                    NSDictionary *tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                    
                    if ([cell isKindOfClass:[SLSelectPopleCell class]]) {
                        SLSelectPopleCell  *tempcell = (SLSelectPopleCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        //cell.mLB_Policy.text = mPassenger.mPolicy;
                        
                        tempcell.mLB_IDnum.text = [NSString stringWithFormat:@"%@ %@",tempDci[mPassenger.mIDType],mPassenger.mIdcard];
                        _IdType = mPassenger.mIDType;
                    }else{
                        SLDJRTableViewCell *tempcell = (SLDJRTableViewCell *)cell;
                        tempcell.mLB_name.text = mPassenger.mName;
                        tempcell.mLB_IdNum.text = [tempDci[mPassenger.mIDType] stringByAppendingString:mPassenger.mIdcard];//mPassenger.mIdcard;
                        _IdType = mPassenger.mIDType;
                    }
                    
                }];
              
            }
       
    }
    
    //配送地址
    if(indexPath.section == 6){
        if (indexPath.row == 1) {
            SLSelectAdressVC *temp =[[SLSelectAdressVC alloc]init];
            [self.navigationController pushViewController:temp animated:YES];
            
            [temp backInfoBlock:^(NSString *style, SLAddressModel *model) {
                LDLOG(@"地址 ====== %@ %@",style,model);
                if (model) {
                    _psName = model.mName;
                    _psPhone =  model.mMobile;
                    _psAdress = model.mAddress;;
                }
                
                if ([style integerValue] == 1) {
                    //自取
                    _bxpz = @"2";
                    
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:@"自取" atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }else{
                    NSMutableArray *tmeparrary = self.mDataSoure[indexPath.section];
                    [tmeparrary removeObjectAtIndex:1];
                    [tmeparrary insertObject:model atIndex:1];
                    [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }];
        }
    }
    
}
#pragma mark Cell加载
#pragma  mark 因私订票Cell
-(UITableViewCell *)loadCellForOthersTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
   
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //登机人CELL
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
            SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
            SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
    }
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 2 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 3 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 5 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    }else{
    
        
        if (indexPath.section == 2 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 4 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    }
    
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.adjustsFontSizeToFitWidth=YES;
            cell.textLabel.minimumScaleFactor=0.5;
        }
    }
    
    if (indexPath.section == 1 ) {
        if (indexPath.section == 2) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                 cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
    }
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 2) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.accessoryView = nil;
                for (id  temp in cell.contentView.subviews) {
                    //                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                     mTempLable = [[UILabel alloc]init];
                }
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
    
    if (indexPath.section == 2) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                mTempLable = [[UILabel alloc]init];
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    
    }
    
    
    return cell;
}
#pragma mark Cell加载
#pragma  mark 加载为他人预订Cell
-(UITableViewCell *)loadForAnyelseCelltableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //输入框
        [tableView registerNib:[UINib nibWithNibName:@"SLFIInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInputCell"];
        SLFIInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInputCell"];
        [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
        cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
        return cell;
    }
    
    if (indexPath.section == 2 && indexPath.row!=[self.mDataSoure[indexPath.section] count]-1 && indexPath.row!=0) {
        //登机人CELL
        SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        
        if(model.mIdcard && model.mIdcard.length>0){
            
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
        SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
        [cell loadCellInfoWithModel:model];
    }
    
    if (self.mInsurances.count>0 && self.mInsurances) {
        if (indexPath.section == 3 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 4 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 6 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    }else{
        
        if (indexPath.section == 3 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 5 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    
    }
    
 
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.mBackFightMode) {
                
                NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.mBackFightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.mBackFightMode.mFlightDate],[self stringWithDateStr:self.mBackFightMode.mFormTime],self.mBackFightMode.mFormAirport,self.mBackFightMode.mArriveAirport];
                
                NSString * contentStr =   [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,tempTime];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                
                [attrStr addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:13]
                                range:NSMakeRange(0, contentStr.length)];
                
                [attrStr addAttribute:NSForegroundColorAttributeName
                                value:SL_GRAY_Hard
                                range:NSMakeRange(0, contentStr.length)];
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                //段落间距
                paragraph.paragraphSpacing = 8;
                //对齐方式
                paragraph.alignment = NSTextAlignmentLeft;
                
                [attrStr addAttribute:NSParagraphStyleAttributeName
                                value:paragraph
                                range:NSMakeRange(0, [contentStr length])];
                
                cell.textLabel.attributedText = attrStr;
                //自动换行
                cell.textLabel.numberOfLines = 0;
                //label高度自适应
                [ cell.textLabel sizeToFit];
                
            }else{
                cell.textLabel.adjustsFontSizeToFitWidth=YES;
                cell.textLabel.minimumScaleFactor=0.5;
            }
        }
    }
    
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"商务谈判/拜访";
            cell.detailTextLabel.font = DEFAULT_FONT(12);
            [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
        }
    }
    
    if (indexPath.section == 2 ) {
        if (indexPath.section == 2) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
    }
    
    if (self.mInsurances.count>0 && self.mInsurances) {
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                cell.accessoryView = nil;
                for (id  temp in cell.contentView.subviews) {
                    //                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                // [mTempBtn setBackgroundColor:[UIColor redColor]];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                    mTempLable = [[UILabel alloc]init];
                }
                
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
        
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                    mTempLable = [[UILabel alloc]init];
                }
                
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }
    
    
    return cell;
}
#pragma mark Cell加载
#pragma mark 因共订票
-(UITableViewCell *)loadCelltableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //输入框
        [tableView registerNib:[UINib nibWithNibName:@"SLFIInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInputCell"];
        SLFIInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInputCell"];
        [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
        cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
        return cell;
    }
    
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 3 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 4 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 6 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    }else{
      
        if (indexPath.section == 3 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 5 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
        
    }
    
    
    
    if (indexPath.section == 2 && indexPath.row!=[self.mDataSoure[indexPath.section] count]-1 && indexPath.row!=0) {
        //登机人CELL
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
            SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
            SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
    }
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.mBackFightMode) {
                
                NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.mBackFightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.mBackFightMode.mFlightDate],[self stringWithDateStr:self.mBackFightMode.mFormTime],self.mBackFightMode.mFormAirport,self.mBackFightMode.mArriveAirport];
                
                NSString * contentStr =   [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,tempTime];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                
                [attrStr addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:13]
                                range:NSMakeRange(0, contentStr.length)];
                
                [attrStr addAttribute:NSForegroundColorAttributeName
                                value:SL_GRAY_Hard
                                range:NSMakeRange(0, contentStr.length)];
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                //段落间距
                paragraph.paragraphSpacing = 8;
                //对齐方式
                paragraph.alignment = NSTextAlignmentLeft;
                
                [attrStr addAttribute:NSParagraphStyleAttributeName
                                value:paragraph
                                range:NSMakeRange(0, [contentStr length])];
                
                cell.textLabel.attributedText = attrStr;
                //自动换行
                cell.textLabel.numberOfLines = 0;
                //label高度自适应
                [ cell.textLabel sizeToFit];
                
            }else{
                cell.textLabel.adjustsFontSizeToFitWidth=YES;
                cell.textLabel.minimumScaleFactor=0.5;
            }
        }
    }
    
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"商务谈判/拜访";
            cell.detailTextLabel.font = DEFAULT_FONT(12);
            [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
        }
    }
    
    if (indexPath.section == 2 ) {
        if (indexPath.section == 2) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                 cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
    
    }
    
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                cell.accessoryView = nil;
                for (id  temp in cell.contentView.subviews) {
//                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                // [mTempBtn setBackgroundColor:[UIColor redColor]];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                    mTempLable = [[UILabel alloc]init];
                }
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
       
        
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                mTempLable = [[UILabel alloc]init];
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }
    }
    
    return cell;
}
#pragma mark Cell加载
#pragma makr #pragma  mark 加载违规政策Cell(因私订票)
-(UITableViewCell *)ViolationLoadCellForOthersTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
        
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //违规
        [tableView registerNib:[UINib nibWithNibName:@"SLViolationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLViolationCell"];
        SLViolationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLViolationCell"];
        
        if (indexPath.row>0) {
            [cell loadCellInfoWithModel:self.illegalReasonLists[indexPath.row - 1]];
        }

        
        return cell;
    }

    
    if (indexPath.section == 2 && indexPath.row > 0) {
        //登机人CELL
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
            SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
            SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
    }
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 3 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 4 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 6 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
        
    }else{
    
        if (indexPath.section == 3 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 5 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
        
    }
    
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.adjustsFontSizeToFitWidth=YES;
            cell.textLabel.minimumScaleFactor=0.5;
        }
    }
    
    if (indexPath.section == 2 ) {
        if (indexPath.section == 3) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                 cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
    }
    
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 3) {
            if(indexPath.row == 0){
                
                cell.accessoryView = nil;
                for (id  temp in cell.contentView.subviews) {
                    //                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                // [mTempBtn setBackgroundColor:[UIColor redColor]];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                    mTempLable = [[UILabel alloc]init];
                }
            
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                if (mTempLable == nil) {
                     mTempLable = [[UILabel alloc]init];
                }
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }
    
    
    return cell;
}
#pragma mark Cell加载
#pragma  mark 加载违规政策Cell(因共订票)
-(UITableViewCell *)ViolationLoadCelltableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //违规
        [tableView registerNib:[UINib nibWithNibName:@"SLViolationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLViolationCell"];
        SLViolationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLViolationCell"];
        if (indexPath.row>0) {
            [cell loadCellInfoWithModel:self.illegalReasonLists[indexPath.row - 1]];
        }
        
        return cell;
    }
    
    if (indexPath.section == 2 && indexPath.row > 0) {
        //输入框
        [tableView registerNib:[UINib nibWithNibName:@"SLFIInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInputCell"];
        SLFIInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInputCell"];
        [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
        cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
        return cell;
    }
    if (self.mInsurances && self.mInsurances.count>0) {
        
        if (indexPath.section == 4 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 5 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 7 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
    }else{
    
        if (indexPath.section == 4 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 6 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }

    
    }
    
    
   
    
    if (indexPath.section == 3 && indexPath.row!=[self.mDataSoure[indexPath.section] count]-1 && indexPath.row!=0) {
        //登机人CELL
        SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        if (model.mDocTypes && model.mDocTypes.count>0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }else{
            [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
            SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
            SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
    }
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.mBackFightMode) {
                
                NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.mBackFightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.mBackFightMode.mFlightDate],[self stringWithDateStr:self.mBackFightMode.mFormTime],self.mBackFightMode.mFormAirport,self.mBackFightMode.mArriveAirport];
                
                NSString * contentStr =   [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,tempTime];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                
                [attrStr addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:13]
                                range:NSMakeRange(0, contentStr.length)];
                
                [attrStr addAttribute:NSForegroundColorAttributeName
                                value:SL_GRAY_Hard
                                range:NSMakeRange(0, contentStr.length)];
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                //段落间距
                paragraph.paragraphSpacing = 8;
                //对齐方式
                paragraph.alignment = NSTextAlignmentLeft;
                
                [attrStr addAttribute:NSParagraphStyleAttributeName
                                value:paragraph
                                range:NSMakeRange(0, [contentStr length])];
                
                cell.textLabel.attributedText = attrStr;
                //自动换行
                cell.textLabel.numberOfLines = 0;
                //label高度自适应
                [ cell.textLabel sizeToFit];
                
            }else{
                cell.textLabel.adjustsFontSizeToFitWidth=YES;
                cell.textLabel.minimumScaleFactor=0.5;
            }
        }
    }
    
    if (indexPath.section ==1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
 
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"商务谈判/拜访";
            cell.detailTextLabel.font = DEFAULT_FONT(12);
            [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
        }
    }
    
    if (indexPath.section == 3 ) {
        if (indexPath.section == 3) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                 cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
        
    }
    
    if (self.mInsurances && self.mInsurances.count>0) {
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.accessoryView = nil;
        
                for (id  temp in cell.contentView.subviews) {
                    //                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                    mTempLable = [[UILabel alloc]init];
                }
       
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 6) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
        
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                mTempLable = [[UILabel alloc]init];
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }
    }

    return cell;
}
#pragma mark Cell加载
#pragma  mark 加载违规政策Cell(为他人预订)
-(UITableViewCell *)ViolationLoadForAnyelseCelltableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        //航班信息
        [tableView registerNib:[UINib nibWithNibName:@"SLFIFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIFightInfoCell"];
        SLFIFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIFightInfoCell"];
        if (self.mBackFlightInfoDIC) {
            [cell loadCellInfo:self.mQSelectRBDModel withFightModel:self.fightMode WFinfo:self.mSelectRBDModel withWFFightModel:self.mBackFightMode];
        }else{
            [cell loadCellInfo:self.mSelectRBDModel withFightModel:self.fightMode];
        }
        return cell;
    }
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        //违规
        [tableView registerNib:[UINib nibWithNibName:@"SLViolationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLViolationCell"];
        SLViolationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLViolationCell"];
        if (indexPath.row>0 && self.illegalReasonLists.count>0) {
            [cell loadCellInfoWithModel:self.illegalReasonLists[indexPath.row - 1]];
        }

        return cell;
    }
    
    if (indexPath.section == 2 && indexPath.row > 0) {
        //输入框
        [tableView registerNib:[UINib nibWithNibName:@"SLFIInputCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInputCell"];
        SLFIInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInputCell"];
        [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
        cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
        return cell;
    }
    
    if (indexPath.section == 3 && indexPath.row!=[self.mDataSoure[indexPath.section] count]-1 && indexPath.row!=0) {
        //登机人CELL
        
        SLPassengerModel *model = self.mDataSoure[indexPath.section][indexPath.row];
        
        if(model.mIdcard && model.mIdcard.length>0){
            
            [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
            SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        [tableView registerNib:[UINib nibWithNibName:@"SLDJRTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLDJRTableViewCell"];
        SLDJRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLDJRTableViewCell"];
        [cell loadCellInfoWithModel:model];
        return cell;
        
    }

    
    if(self.mInsurances && self.mInsurances.count>0){
        if (indexPath.section == 4 && indexPath.row > 0) {
            //保险
            [tableView registerNib:[UINib nibWithNibName:@"SLFIInsureInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIInsureInfoCell"];
            SLFIInsureInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIInsureInfoCell"];
            cell.delegate = self;
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            return cell;
        }
        
        if (indexPath.section == 5 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 7 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
        
    }else{
        
        if (indexPath.section == 4 && indexPath.row > 0) {
            //联系人
            [tableView registerNib:[UINib nibWithNibName:@"SLTripPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLTripPopleCell"];
            SLTripPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLTripPopleCell"];
            SLUserInfoModel *model = self.mDataSoure[indexPath.section][indexPath.row];
            [cell loadCellInfoWithModel:model];
            return cell;
        }
        
        if (indexPath.section == 6 ) {
            //附件信息
            [tableView registerNib:[UINib nibWithNibName:@"SLFIAttachCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFIAttachCell"];
            SLFIAttachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFIAttachCell"];
            [cell.mLB_title setText:self.mDataSoure[indexPath.section][indexPath.row]];
            cell.mTF_input.placeholder = [NSString stringWithFormat:@"请输入%@",cell.mLB_title.text];
            return cell;
        }
        
        
    }
    
    NSString *cellIndentifier =[NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
    }
    
    [cell.textLabel setFont:DEFAULT_FONT(13)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    id temp = self.mDataSoure[indexPath.section][indexPath.row];
    if ([temp isKindOfClass:[NSString class]]) {
        [cell.textLabel setText:self.mDataSoure[indexPath.section][indexPath.row]];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            if (self.mBackFightMode) {
                
                NSString *tempTime = [NSString stringWithFormat:@"%@  %@ %@ %@ - %@",[[self.mBackFightMode.mFlightDate substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"月"],[self getWeekDayWithStr:self.mBackFightMode.mFlightDate],[self stringWithDateStr:self.mBackFightMode.mFormTime],self.mBackFightMode.mFormAirport,self.mBackFightMode.mArriveAirport];
                
                NSString * contentStr =   [NSString stringWithFormat:@"%@\n%@",cell.textLabel.text,tempTime];
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
                
                [attrStr addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:13]
                                range:NSMakeRange(0, contentStr.length)];
                
                [attrStr addAttribute:NSForegroundColorAttributeName
                                value:SL_GRAY_Hard
                                range:NSMakeRange(0, contentStr.length)];
                
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                //段落间距
                paragraph.paragraphSpacing = 8;
                //对齐方式
                paragraph.alignment = NSTextAlignmentLeft;
                
                [attrStr addAttribute:NSParagraphStyleAttributeName
                                value:paragraph
                                range:NSMakeRange(0, [contentStr length])];
                
                cell.textLabel.attributedText = attrStr;
                //自动换行
                cell.textLabel.numberOfLines = 0;
                //label高度自适应
                [ cell.textLabel sizeToFit];
                
            }else{
                cell.textLabel.adjustsFontSizeToFitWidth=YES;
                cell.textLabel.minimumScaleFactor=0.5;
            }
        }
    }
    
    if (indexPath.section ==1 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"商务谈判/拜访";
            cell.detailTextLabel.font = DEFAULT_FONT(12);
            [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
        }
    }
    
    if (indexPath.section == 3 ) {
        if (indexPath.section == 3) {
            NSMutableArray *mTemp = self.mDataSoure[indexPath.section];
            if (indexPath.row == [mTemp count] - 1) {
                 cell.detailTextLabel.text = _feiyong;
                cell.detailTextLabel.font = DEFAULT_FONT(12);
                [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
            }
        }
    }
    
    if (self.mInsurances.count>0 && self.mInsurances) {
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                cell.accessoryView = nil;
                for (id  temp in cell.contentView.subviews) {
                    //                     LDLOG(@"asd==== %@",temp);
                    if ([temp isKindOfClass:[UILabel class]]) {
                        UILabel *tempTF = temp;
                        if ([tempTF.text isEqualToString:@"最多可选择3个联系人"]) {
                            [tempTF removeFromSuperview];
                        }
                    }
                }
                
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                // [mTempBtn setBackgroundColor:[UIColor redColor]];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                mTempLable = [[UILabel alloc]init];
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 6) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }else{
        if (indexPath.section == 4) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryNone;
                UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                // [mTempBtn setBackgroundColor:[UIColor redColor]];
                [mTempBtn setImage:[UIImage imageNamed:@"common_btn_info"] forState:UIControlStateNormal];
                [mTempBtn addTarget:self action:@selector(onclickBxBtn:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:mTempBtn];
                [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(5);
                    make.centerY.mas_equalTo(0);
                    make.width.height.mas_equalTo(18);
                }];
                
            }
        }
        
        if (indexPath.section == 5) {
            if(indexPath.row == 0){
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mAddBtn.tag = indexPath.section;
                [mAddBtn setFrame:CGRectMake(0, 0, 20, 20)];
                [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
                [mAddBtn addTarget:self action:@selector(onclickAddPople:) forControlEvents:UIControlEventTouchUpInside];
                cell.accessoryView = mAddBtn;
                
                if (mTempLable == nil) {
                      mTempLable = [[UILabel alloc]init];
                }
                [mTempLable setFont:DEFAULT_FONT(12)];
                [mTempLable setTextColor:SL_GRAY_Hard];
                [mTempLable setText:@"最多可选择3个联系人"];
                [cell.contentView addSubview:mTempLable];
                [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.textLabel.mas_right).with.offset(15);
                    make.centerY.mas_equalTo(0);
                }];
            }
        }
        
        if (indexPath.section == 6) {
            if(indexPath.row == 0){
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if (_mTempSwtch == nil) {
                    _mTempSwtch = [[UISwitch alloc]init];
                    
                }
                _mTempSwtch.tag = indexPath.section;
                [cell.contentView addSubview:_mTempSwtch];
                [_mTempSwtch addTarget:self action:@selector(onclickSwitchValueChage:) forControlEvents:UIControlEventValueChanged];
                [_mTempSwtch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-13);
                    make.centerY.mas_equalTo(0);
                }];
                
                if (temp.count >1) {
                    [_mTempSwtch setOn:YES];
                }else{
                    [_mTempSwtch setOn:NO];
                }
            }else{
                NSMutableArray *temp =  self.mDataSoure[indexPath.section];
                id tempID = temp[1];
                if ([tempID isKindOfClass:[SLAddressModel class]]) {
                    [tableView registerNib:[UINib nibWithNibName:@"SLAddressCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLAddressCell"];
                    SLAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLAddressCell"];
                    [cell loadCellInfoWithModel:self.mDataSoure[indexPath.section][indexPath.row]];
                    return cell;
                }
            }
        }

    }
    
    
    return cell;
}
#pragma mark evet response
- (IBAction)onclickGoBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onclickSubOderBtn:(UIButton *)sender {
    
    
    if (self.ReasonType == company){
        if (_mudi == nil || _mudi.length == 0) {
            ShowMSG(@"请选择出行目的");
            return;
        }
        
        if (_feiyong == nil || _feiyong.length == 0) {
            ShowMSG(@"请选择费用归属");
            return;
        }
    }else{
        _mudi = @"商务谈判/拜访";
        _feiyong = @"";
    }
    
    NSString *mTgqId = @"";
    if (self.fightMode.mTgqid && self.fightMode.mTgqid.length>0) {
        mTgqId = self.fightMode.mTgqid;
    }
    
    if (self.TicketType == 0) {
        //本人约定
        __block  NSArray *inArray;
        __block   NSArray *passArray;
        __block  NSArray *fightArray;
        __block  NSString *audit  = @"2";
        [SLNetWorkingStatusView show];
        [HttpApi getMyTravelPolicyList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
            
            if ([responseBody[@"approveType"] intValue]>=2) {
                audit = @"1";
            }else{
                audit = @"2";
            }
            
            SLUserInfoModel*mtempModel;
            if(self.ReasonType == company){
                if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
                    mtempModel = self.mDataSoure[2][1];
                }else{
                    mtempModel = self.mDataSoure[3][1];
                }
            }else{
            
                if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
                    mtempModel = self.mDataSoure[1][1];
                }else{
                    mtempModel = self.mDataSoure[2][1];
                }
            }
            
            if (_IdNum == nil || _IdNum.length == 0) {
                NSArray *mtemp = mtempModel.mDocTypes;
                _IdNum = @"";
                _IdType = @"";
                if (mtemp && mtemp.count > 0) {
                    NSDictionary *info = mtemp[0];
                    _IdNum = info[@"no"];
                    NSString *key = info[@"type"];
                    NSDictionary *tempDci;
                    if (key && key.length>0) {
                        if ([self IsChinese:key]) {
                            tempDci = @{@"身份证":@"1",@"护照":@"2",@"军人证":@"3",@"回乡证":@"4",@"港澳通行证":@"5",@"台胞证":@"6",@"其他":@"0"};
                        }else{
                            tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                        }
                        _IdType = tempDci[key];
                    }
                  
                }else{
                    ShowMSG(@"请输入证件");
                    [SVProgressHUD dismiss];
                    return;
                }
            }
            
            inArray  = @[@{@"fee":[NSString stringWithFormat:@"%d",_priceOfIn],@"num":_numOfIn,@"desc":@"最高保额80万，当次航班有效"},];
            
            if (_IdType == nil) {
                _IdType = @"";
            }
            
            passArray= @[@{@"name":mtempModel.mChineseName,@"no":_IdNum,@"idtype":_IdType}];
    
           
            if (self.mBackFlightInfoDIC) {
                //往返
                fightArray  = @[@{@"orgCity":self.mFlightInfoDIC[@"fromCity"],@"dstCity":self.mFlightInfoDIC[@"toCity"],@"org":self.fightMode.mformAirportCode,@"dst":self.fightMode.marrAirportCode,@"depTime":self.fightMode.mFormTime,@"arrTime":self.fightMode.mArriveTime,@"depAirport":self.fightMode.mFormAirport,@"arrAirport":self.fightMode.mArriveAirport,@"depTerm":self.fightMode.mformTerm,@"arrTerm":self.fightMode.marrTerm,@"flightTime":self.fightMode.mUseTime,@"airline":self.fightMode.mAirlineName,@"airlineNo":self.fightMode.mAirCode,@"flight":self.fightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mQSelectRBDModel.mRBDRefund,@"mcCost":self.fightMode.mAirrax,@"discount":self.mQSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mQSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mQSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mQSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mQSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}
                                
                    ,@{@"orgCity":self.mBackFlightInfoDIC[@"fromCity"],@"dstCity":self.mBackFlightInfoDIC[@"toCity"],@"org":self.mBackFightMode.mformAirportCode,@"dst":self.mBackFightMode.marrAirportCode,@"depTime":self.mBackFightMode.mFormTime,@"arrTime":self.mBackFightMode.mArriveTime,@"depAirport":self.mBackFightMode.mFormAirport,@"arrAirport":self.mBackFightMode.mArriveAirport,@"depTerm":self.mBackFightMode.mformTerm,@"arrTerm":self.mBackFightMode.marrTerm,@"flightTime":self.mBackFightMode.mUseTime,@"airline":self.mBackFightMode.mAirlineName,@"airlineNo":self.mBackFightMode.mAirCode,@"flight":self.mBackFightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mSelectRBDModel.mRBDRefund,@"mcCost":self.mBackFightMode.mAirrax,@"discount":self.mSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}];
            }else{
                //单程
                fightArray  = @[@{@"orgCity":self.mFlightInfoDIC[@"fromCity"],@"dstCity":self.mFlightInfoDIC[@"toCity"],@"org":self.fightMode.mformAirportCode,@"dst":self.fightMode.marrAirportCode,@"depTime":self.fightMode.mFormTime,@"arrTime":self.fightMode.mArriveTime,@"depAirport":self.fightMode.mFormAirport,@"arrAirport":self.fightMode.mArriveAirport,@"depTerm":self.fightMode.mformTerm,@"arrTerm":self.fightMode.marrTerm,@"flightTime":self.fightMode.mUseTime,@"airline":self.fightMode.mAirlineName,@"airlineNo":self.fightMode.mAirCode,@"flight":self.fightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mSelectRBDModel.mRBDRefund,@"mcCost":self.fightMode.mAirrax,@"discount":self.mSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}];
            }
            //保
            NSData *mData = [NSJSONSerialization dataWithJSONObject:inArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *inString = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
            
            //乘客
            NSData *mData1 = [NSJSONSerialization dataWithJSONObject:passArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *passString = [[NSString alloc]initWithData:mData1 encoding:NSUTF8StringEncoding];
            
            //航班
            NSData *mData2 = [NSJSONSerialization dataWithJSONObject:fightArray options:NSJSONWritingPrettyPrinted error:nil];
            NSString *passString1 = [[NSString alloc]initWithData:mData2 encoding:NSUTF8StringEncoding];
            
            
            if (self.mSelectedPassengers && self.mSelectedPassengers.count >0) {
                SLPassengerModel *mSeleledPolic = self.mSelectedPassengers[0];
                audit = [mSeleledPolic.mAudit stringValue];
            }
            
            //所有参数
            NSDictionary *tempParamDic = @{@"userId":sl_userID,@"type":@"FD",@"tripType":@"1",@"legType":self.mFlightInfoDIC[@"tripType"],@"bookType":@"1",@"contacts":mtempModel.mChineseName,@"mobile":[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"],@"bxpz":_bxpz,@"oaRegNum":@"",@"tpid":@"1",@"tripPurpose":_mudi,@"distribution":_psAdress,@"dmobile":_psPhone,@"dname":_psName,@"audit":audit};
            
            NSMutableDictionary *mParamDic = [NSMutableDictionary dictionaryWithDictionary:tempParamDic];
            [mParamDic setObject:inString forKey:@"insurances"];
            [mParamDic setObject:passString forKey:@"passengers"];
            [mParamDic setObject:passString1 forKey:@"fights"];
            NSString *illegal = @"2";
            if(self.illegalReasonLists && self.illegalReasonLists.count>0){
                illegal= @"1";
                if((_wgReason.length == 0 || [[_wgReason componentsSeparatedByString:@"#"] count] < self.illegalReasonLists.count) && self.illegalReasonLists.count>0){
                    ShowMSG(@"请输入违规原因");
                    [SVProgressHUD dismiss];
                    [SLNetWorkingStatusView dismiss];
                    return;
                }
                
                NSMutableString *tempReasonStr = [NSMutableString string];
                for (NSDictionary *dic in self.illegalReasonLists) {
                    NSString *str = dic[@"illegalDesc"];
                    [tempReasonStr appendFormat:@"#%@",str];
                    [tempReasonStr deleteCharactersInRange:NSMakeRange(0, 1)];
                }
                
                [mParamDic setObject:tempReasonStr forKey:@"illegalDesc"];
                [mParamDic setObject:_wgReason forKey:@"illegalReason"];
            }
            [mParamDic setObject:illegal forKey:@"illegal"];
            
            [HttpApi putFlightOrder:mParamDic SuccessBlock:^(id responseBody) {
                [SVProgressHUD showSuccessWithStatus:@"成功"];
                LDLOG(@"生成订单%@",responseBody);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    SLFinishVC *mTempVC = [[SLFinishVC alloc]init];
                    mTempVC.orderNo = responseBody[@"orderNo"];
                    mTempVC.mCreateTime = responseBody[@"createTime"];
                    mTempVC.paytimeout = responseBody[@"paytimeout"];
                    mTempVC.audit = audit;
                    mTempVC.mPirceStr =  self.mLB_moeny.text;
                    [self.navigationController pushViewController:mTempVC animated:YES];
                });
            } FailureBlock:^(NSError *error) {
                
            }];
            
        } FailureBlock:^(NSError *error) {
            
        }];
        
    }else{
        //他人预定
        NSArray *inArray;
        NSMutableArray *passArray = [NSMutableArray array];
        NSArray *fightArray;
        
        SLPassengerModel*mtempModel = self.mSelectedPassengers[0];
       inArray  = @[@{@"fee":[NSString stringWithFormat:@"%d",_priceOfIn],@"num":_numOfIn,@"desc":@"最高保额80万，当次航班有效"},];
        
        for (SLPassengerModel *model in self.mSelectedPassengers) {
            
            if (model.mIdcard== nil || model.mIdcard.length ==0) {
                ShowMSG(@"请输入证件");
                return;
            }else{
                NSDictionary *tempDci;
                
                NSString *key =  model.mIDType;
                if (key && key.length>0) {
                    if ([self IsChinese:key]) {
                        tempDci = @{@"身份证":@"1",@"护照":@"2",@"军人证":@"3",@"回乡证":@"4",@"港澳通行证":@"5",@"台胞证":@"6",@"其他":@"0"};
                    }else{
                        tempDci = @{@"1":@"身份证",@"2":@"护照",@"3":@"军人证",@"4":@"回乡证",@"5":@"港澳通行证",@"6":@"台胞证",@"0":@"其他"};
                    }
                    
                    NSDictionary *info = @{@"name":model.mName,@"no":model.mIdcard,@"idtype":tempDci[key]};
                    [passArray addObject: info];
                }
            }
        }
        
        if (self.mBackFlightInfoDIC) {
           //往返
            fightArray  = @[@{@"orgCity":self.mFlightInfoDIC[@"fromCity"],@"dstCity":self.mFlightInfoDIC[@"toCity"],@"org":self.fightMode.mformAirportCode,@"dst":self.fightMode.marrAirportCode,@"depTime":self.fightMode.mFormTime,@"arrTime":self.fightMode.mArriveTime,@"depAirport":self.fightMode.mFormAirport,@"arrAirport":self.fightMode.mArriveAirport,@"depTerm":self.fightMode.mformTerm,@"arrTerm":self.fightMode.marrTerm,@"flightTime":self.fightMode.mUseTime,@"airline":self.fightMode.mAirlineName,@"airlineNo":self.fightMode.mAirCode,@"flight":self.fightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mQSelectRBDModel.mRBDRefund,@"mcCost":self.fightMode.mAirrax,@"discount":self.mQSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mQSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mQSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mQSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mQSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}
                            
                ,@{@"orgCity":self.mBackFlightInfoDIC[@"fromCity"],@"dstCity":self.mBackFlightInfoDIC[@"toCity"],@"org":self.mBackFightMode.mformAirportCode,@"dst":self.mBackFightMode.marrAirportCode,@"depTime":self.mBackFightMode.mFormTime,@"arrTime":self.mBackFightMode.mArriveTime,@"depAirport":self.mBackFightMode.mFormAirport,@"arrAirport":self.mBackFightMode.mArriveAirport,@"depTerm":self.mBackFightMode.mformTerm,@"arrTerm":self.mBackFightMode.marrTerm,@"flightTime":self.mBackFightMode.mUseTime,@"airline":self.mBackFightMode.mAirlineName,@"airlineNo":self.mBackFightMode.mAirCode,@"flight":self.mBackFightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mSelectRBDModel.mRBDRefund,@"mcCost":self.mBackFightMode.mAirrax,@"discount":self.mSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}];
        }else{
            //单程
            
            fightArray  = @[@{@"orgCity":self.mFlightInfoDIC[@"fromCity"],@"dstCity":self.mFlightInfoDIC[@"toCity"],@"org":self.fightMode.mformAirportCode,@"dst":self.fightMode.marrAirportCode,@"depTime":self.fightMode.mFormTime,@"arrTime":self.fightMode.mArriveTime,@"depAirport":self.fightMode.mFormAirport,@"arrAirport":self.fightMode.mArriveAirport,@"depTerm":self.fightMode.mformTerm,@"arrTerm":self.fightMode.marrTerm,@"flightTime":self.fightMode.mUseTime,@"airline":self.fightMode.mAirlineName,@"airlineNo":self.fightMode.mAirCode,@"flight":self.fightMode.mFlightno,@"bookStatus":@"1",@"ticketNum":@"1",@"tgqDesc":self.mSelectRBDModel.mRBDRefund,@"mcCost":self.fightMode.mAirrax,@"discount":self.mSelectRBDModel.mRBDDiscount,@"bookTime":[MyFounctions  getCurrentDate],@"ticketPrice":[self.mSelectRBDModel.mRBDSalePrice stringValue],@"grade":self.mSelectRBDModel.mRBDName,@"booktype":@"1",@"cabin":self.mSelectRBDModel.mRBDCode,@"bookStatus":@"",@"price":self.mSelectRBDModel.mRBDPrice,@"tgqid":mTgqId}];
        }
        //保
        NSData *mData = [NSJSONSerialization dataWithJSONObject:inArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *inString = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
        
        //乘客
        NSData *mData1 = [NSJSONSerialization dataWithJSONObject:passArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *passString = [[NSString alloc]initWithData:mData1 encoding:NSUTF8StringEncoding];
        
        //航班
        NSData *mData2 = [NSJSONSerialization dataWithJSONObject:fightArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *passString1 = [[NSString alloc]initWithData:mData2 encoding:NSUTF8StringEncoding];
        
        //所有参数
        NSString *audit  = @"2";
        if (self.mSelectedPassengers && self.mSelectedPassengers.count >0) {
            SLPassengerModel *mSeleledPolic = self.mSelectedPassengers[0];
            
            if([mSeleledPolic.mAudit intValue] == 1){
                audit  = @"2";
            }else{
                audit = @"1";
            }
        }
        
        NSDictionary *tempParamDic = @{@"userId":sl_userID,@"type":@"FD",@"tripType":@"1",@"legType":self.mFlightInfoDIC[@"tripType"],@"bookType":@"1",@"contacts":mtempModel.mName,@"mobile":[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"],@"bxpz":_bxpz,@"oaRegNum":@"",@"tpid":@"1",@"tripPurpose":_mudi,@"distribution":_psAdress,@"dmobile":_psPhone,@"dname":_psName,@"audit":audit};
        
        NSMutableDictionary *mParamDic = [NSMutableDictionary dictionaryWithDictionary:tempParamDic];
        [mParamDic setObject:inString forKey:@"insurances"];
        [mParamDic setObject:passString forKey:@"passengers"];
        [mParamDic setObject:passString1 forKey:@"fights"];
         NSString *illegal = @"2";
        if(self.illegalReasonLists && self.illegalReasonLists.count>0){
            illegal = @"1";
            if((_wgReason.length == 0 || [[_wgReason componentsSeparatedByString:@"#"] count] < self.illegalReasonLists.count) && self.illegalReasonLists.count>0){
                ShowMSG(@"请输入违规原因");
                [SVProgressHUD dismiss];
                [SLNetWorkingStatusView dismiss];
                return;
            }
            if(_wgReason == nil || _wgReason.length == 0){
                _wgReason = [NSMutableString stringWithString:@""];
            }
            
            NSMutableString *tempReasonStr = [NSMutableString string];
            
            for (NSDictionary *dic in self.illegalReasonLists) {
                NSString *str = dic[@"illegalDesc"];
                [tempReasonStr appendFormat:@"#%@",str];
                [tempReasonStr deleteCharactersInRange:NSMakeRange(0, 1)];
            }
        
            [mParamDic setObject:_wgReason forKey:@"illegalReason"];
            [mParamDic setObject:tempReasonStr forKey:@"illegalDesc"];
        }
        [mParamDic setObject:illegal forKey:@"illegal"];
        
        [HttpApi putFlightOrder:mParamDic SuccessBlock:^(id responseBody) {
             [SVProgressHUD showSuccessWithStatus:@"成功"];
            LDLOG(@"生成订单%@",responseBody);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if(self.illegalReasonLists &&self.illegalReasonLists.count>0){
//                    [self.navigationController popToRootViewControllerAnimated:YES];
//                }else{
                    SLFinishVC *mTempVC = [[SLFinishVC alloc]init];
                    mTempVC.orderNo = responseBody[@"orderNo"];
                    mTempVC.mCreateTime = responseBody[@"createTime"];
                    mTempVC.paytimeout = responseBody[@"paytimeout"];
                    mTempVC.mPirceStr =  self.mLB_moeny.text;
                    mTempVC.audit = audit;
                    [self.navigationController pushViewController:mTempVC animated:YES];
//                }
                
            });
        } FailureBlock:^(NSError *error) {
            
        }];

    }
    
  
}
//真加登机人
-(void)onclickAddIdCard:(UIButton *)sender{
    LDLOG(@"真加登机人");

}
//报销
-(void)onclickBxBtn:(UIButton *)sender{

}
//真加联系人
-(void)onclickAddPople:(UIButton *)sender{
    
    SLTripPipleVC *mTempVC = [[SLTripPipleVC alloc]init];
    mTempVC.isSelect = YES;
    mTempVC.title = @"联系人";
    [self.navigationController pushViewController:mTempVC animated:YES];
    
    [mTempVC backPopleInfo:^(NSMutableArray *infoDic) {
        LDLOG(@"选择的联系人%@",infoDic);
        NSMutableArray *tempArray = self.mDataSoure[self.mDataSoure.count - 3];
        for (SLContactModel *temp in infoDic) {
            [tempArray addObject:temp];
        }
        [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:self.mDataSoure.count - 3] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}
-(void)onclickSwitchValueChage:(UISwitch *)sender{
    
    if (sender.on ==YES) {
        _bxpz = @"1";
        NSMutableArray *tmeparrary = self.mDataSoure[sender.tag];
        [tmeparrary insertObject:@"选择配送方式" atIndex:1];
         [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        _bxpz = @"2";
        _psName = @"";
        _psPhone = @"";
        _psAdress = @"";
        NSMutableArray *tmeparrary = self.mDataSoure[sender.tag];
        [tmeparrary removeAllObjects];
        [tmeparrary addObject:@"报销凭证"];
        [self.minfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationNone];
    }
}
#pragma mark SLFIInsureInfoCellDeleagte
-(void)SLFIInsureInfoCell:(SLFIInsureInfoCell *)cell onclickJiaBnt:(id)sender{
    int i = [cell.mLB_Num.text intValue];
    
    cell.mLB_Num.text = [NSString stringWithFormat:@"%d",i+1];
    
    if(self.mBackFightMode){
        if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%lu",[ self.mLB_moeny.text integerValue] +2*_priceOfIn*self.mSelectedPassengers.count];
        }else{
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%ld",[ self.mLB_moeny.text integerValue] + 2*_priceOfIn];
        }
    
    }else{
        if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%lu",[ self.mLB_moeny.text integerValue] +_priceOfIn*self.mSelectedPassengers.count];
        }else{
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%ld",[ self.mLB_moeny.text integerValue] +_priceOfIn];
        }
    }
    _numOfIn = cell.mLB_Num.text;
}
-(void)SLFIInsureInfoCell:(SLFIInsureInfoCell *)cell onclickJianBnt:(id)sender{
    int i = [cell.mLB_Num.text intValue];
    
    if (i == 0) {
        return;
    }
    
    cell.mLB_Num.text = [NSString stringWithFormat:@"%d",i-1];
    
    if(self.mBackFightMode){
        if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%lu",[ self.mLB_moeny.text integerValue] -2*_priceOfIn*self.mSelectedPassengers.count];
        }else{
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%ld",[ self.mLB_moeny.text integerValue] -2*_priceOfIn];
        }
        
    }else{
        if (self.mSelectedPassengers && self.mSelectedPassengers.count>0) {
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%lu",[ self.mLB_moeny.text integerValue] - _priceOfIn*self.mSelectedPassengers.count];
        }else{
            self.mLB_moeny.text  =[NSString stringWithFormat:@"%ld",[ self.mLB_moeny.text integerValue] - _priceOfIn];
        }
    }
    _numOfIn = cell.mLB_Num.text;
}
#pragma mark SLDataPickerViewDelegate
-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    
    
    if (view.tag == 111) {
       SLViolationCell *cell = [self.minfoTableView cellForRowAtIndexPath:_mSelectIndex];
        cell.mLB_reason.text = str;
        [_wgReason appendFormat:@"#%@",str];
        [_wgReason deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    if (view.tag == 11) {
        UITableViewCell *cell = [self.minfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.detailTextLabel.text = str;
        _mudi = str;
    }
    
    if (view.tag == 12) {
        NSMutableArray *mTemp = self.mDataSoure[2];
        UITableViewCell *cell = [self.minfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:mTemp.count - 1 inSection:2]];
        NSDictionary *dic = (NSDictionary *)str;
        cell.detailTextLabel.text = dic[@"name"];
        _feiyong = dic[@"name"];
    }
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDataSoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.00f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.TicketType == principal) {
        //为本人预定
        if (self.ReasonType == company){
            //因共
            if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
                 return  [self  loadCelltableView:tableView cellForRowAtIndexPath:indexPath];
            }else{
                return  [self  ViolationLoadCelltableView:tableView cellForRowAtIndexPath:indexPath];;
            }
           
        }else{
            //因私
            if(self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0){
                return [self loadCellForOthersTableView:tableView cellForRowAtIndexPath:indexPath];
            }else{
                return [self ViolationLoadCellForOthersTableView:tableView cellForRowAtIndexPath:indexPath];
            }
    
        }
        
    }else{
        //为他人预定
        if(self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0){
         return  [self  loadForAnyelseCelltableView:tableView cellForRowAtIndexPath:indexPath];
        }else{
         return  [self  ViolationLoadForAnyelseCelltableView:tableView cellForRowAtIndexPath:indexPath];
        }
       
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _mSelectIndex = indexPath;
    if (self.TicketType == principal) {
        //为本人预定
        if (self.ReasonType == company){
            //因共
            if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
                [self SLTableView:tableView didSelectRowAtIndexPath:indexPath];
            }else{
                [self  ViolationSLTableView:tableView didSelectRowAtIndexPath:indexPath];
            }
           
        }else{
            //因私
            if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
                [self SLForSITableView:tableView didSelectRowAtIndexPath:indexPath];
            }else{
                [self ViolationSLForSITableView:tableView didSelectRowAtIndexPath:indexPath];
            }
        }
        
    }else{
        //为他人预定
        if (self.illegalReasonLists == nil || [self.illegalReasonLists count] ==0) {
            [self SLForAnyelseTableView:tableView didSelectRowAtIndexPath:indexPath];
        }else{
            [self ViolationSLForAnyelseTableView:tableView didSelectRowAtIndexPath:indexPath];
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
