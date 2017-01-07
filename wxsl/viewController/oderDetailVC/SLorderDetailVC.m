//
//  SLorderDetailVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLorderDetailVC.h"
#import "SLsdFightInfoCell.h"
#import "SLsdTGQCell.h"
#import "SLsdCell.h"
#import "SLsdInsureCell.h"
#import "SLsdSendCell.h"
#import "SLsdTwoCell.h"
#import "SLsdPopleInfoCell.h"
#import "CCActionSheet.h"

#import "SLReturnTicketVC.h"
#import "SLTicketAlterationVC.h"
@interface SLorderDetailVC ()<UITableViewDelegate,UITableViewDataSource,CCActionSheetDelegate>
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

@property (weak, nonatomic) IBOutlet UITableView *mInfoTbaleView;

@property (strong, nonatomic) SLOrderDetialModel*mOderDetialModel;

@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation SLorderDetailVC{

   __block NSString *passWord;
    
    NSArray *_TPReasonArray;
    NSArray *_TPpassengers;
    NSArray *_TPinfos;
    
    
    NSArray *_GQinfos;
    NSArray *_GQReasonArray;
    
    dispatch_source_t _timer;
    
    UIButton *mSQBtn;
    
    UIButton *mPayTime;
    
    UIView *mFootterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTbaleView.estimatedRowHeight = 44.0f;
    self.mInfoTbaleView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.mLB_formTime.text = [self.mOderModel.mDepTime substringToIndex:5];
    self.mLB_toTime.text = [self.mOderModel.mArrTime substringToIndex:5];
    self.mLB_date.text = self.mOderModel.mFlightDate;
    if ([self.mOderModel.mStop boolValue]) {
        self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.mOderModel.mFlightTime  intValue]/60/60,[self.mOderModel.mFlightTime  intValue]/60%60,@"经停"];
        
    }else{
        self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分 %@",[self.mOderModel.mFlightTime  intValue]/60/60,[self.mOderModel.mFlightTime  intValue]/60%60,@"直接"];
    }
//    self.mLB_contetTime.text = [NSString stringWithFormat:@"%d个小时%d分",[self.mOderModel.mFlightTime  intValue]/60/60,[ self.mOderModel.mFlightTime  intValue]/60%60];
   // self.mLB_formAirport.text = [self.mOderModel.mDepAirport stringByAppendingString:self.mOderModel.mDepTerm];
  //  self.mLB_tomAirport.text = [self.mOderModel.mArrAirport stringByAppendingString:self.mOderModel.mArrTerm];
    
    self.mLB_content.text = [NSString stringWithFormat:@"%@%@%@",self.mOderModel.mAirlineNo,self.mOderModel.mAirline,self.mOderModel.mFlight];
    
    self.mLB_formCity.text = self.mOderModel.mOrgCity;
    self.mLB_toCity.text = self.mOderModel.mDstCity;

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    NSDictionary *paramDic = @{@"userId":sl_userID,@"orderId":self.mOderModel.mOderId};
    
    [SLNetWorkingStatusView show];
   
    [HttpApi getMyReturnOrderDetail:paramDic SuccessBlock:^(id responseBody) {
        
        NSArray *tempRTNs = responseBody[@"orderRtns"];
        
        if (tempRTNs.count == 0 || tempRTNs == nil) {
            
        [HttpApi getMyChangeOrderDetail:paramDic SuccessBlock:^(id responseBody) {
            
            NSArray *orderChgs = responseBody[@"orderChgs"];
            if (orderChgs.count == 0 || orderChgs == nil) {
                
                [HttpApi getMyOrderDetail:paramDic SuccessBlock:^(id responseBody) {
                    
                    NSError *err;
                    self.mOderDetialModel =   [MTLJSONAdapter modelOfClass:[SLOrderDetialModel class] fromJSONDictionary:responseBody error:&err];
                    
                    if (self.mOderDetialModel.illegalReasons && self.mOderDetialModel.illegalReasons.count>0 && [self.mOderDetialModel.mBookStatus integerValue] == 10) {
                          self.mDataSoure = [NSMutableArray arrayWithArray:@[@[@""],@[@""],[NSMutableArray arrayWithArray:@[@"订单号",@"票  号",@"预定时间",@"出行目的",@"订单状态"]],@[@""],[NSMutableArray arrayWithArray:@[@"登机人"]],@[@"政策违规"],[NSMutableArray arrayWithArray:@[@"联系人",@""]],@[@""]]];
                    }else{
                        self.mDataSoure = [NSMutableArray arrayWithArray:@[@[@""],@[@""],[NSMutableArray arrayWithArray:@[@"订单号",@"票  号",@"预定时间",@"出行目的",@"订单状态"]],@[@""],[NSMutableArray arrayWithArray:@[@"登机人"]],[NSMutableArray arrayWithArray:@[@"联系人",@""]],@[@""]]];
                    }
                    
                    
                    for (NSDictionary *temp in self.mOderDetialModel.passengers) {
                        NSMutableArray *tempPassengers = self.mDataSoure[4];
                        [tempPassengers insertObject:temp atIndex:1];
                    }
                    
                
                    self.mLB_formAirport.text = [self.mOderDetialModel.mDepAirport stringByAppendingString:self.mOderDetialModel.mDepTerm];
                    self.mLB_tomAirport.text = [self.mOderDetialModel.mArrAirport stringByAppendingString:self.mOderDetialModel.mArrTerm];
                    
                    
                    [self.mInfoTbaleView reloadData];
                    
            
                    
                } FailureBlock:^(NSError *error) {
                    
                }];
                
            }else{
            //改签订单
                [SVProgressHUD dismiss];
                 LDLOG(@"改签订单");
                
                NSDictionary *GQinfo = orderChgs[0];
                if (GQinfo == nil || [GQinfo allKeys].count ==0) {
                    return ;
                }
                
                _GQinfos = @[GQinfo[@"orderNo"],GQinfo[@"creator"],GQinfo[@"change_service"],GQinfo[@"difference"],GQinfo[@"status"],GQinfo[@"operatorName"]];
                
                _GQReasonArray = @[GQinfo[@"content"]];
              
                  self.mDataSoure = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[@"订单号",@"申请人",@"改签手续费",@"差价总计",@"订单状态",@"改签操作员"]],[NSMutableArray arrayWithArray:@[@"登机人"]],@[@"申请内容"]]];
                
                NSArray *passangers = GQinfo[@"passengers"];
                NSMutableArray *tempPassengers = self.mDataSoure[1];
                
                for (NSDictionary *temp in passangers) {
                    [tempPassengers insertObject:temp atIndex:1];
                }
                 [self.mInfoTbaleView reloadData];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
            
        
        }else{
        //退票定单
            [SVProgressHUD dismiss];
            LDLOG(@"退票");
            NSDictionary *TPinfo = tempRTNs[0];
            if (TPinfo == nil || [TPinfo allKeys].count ==0) {
                return ;
            }
            
            NSString *TPReasonStr = TPinfo[@"returnDescribe"];
            // NSString *TPReasonStr = TPinfo[@"returnDescribe"];
            _TPReasonArray = @[TPReasonStr];
            
            _TPinfos = @[TPinfo[@"orderNo"],TPinfo[@"creator"],TPinfo[@"mobile"],self.mOderModel.mBookTime,TPinfo[@"type"],TPinfo[@"status"],TPinfo[@"orderNo"],TPinfo[@"returnfee"]];
            
            NSArray *fights = responseBody[@"flight"];
            NSDictionary *fightsInfo = fights[0];
            if (fightsInfo && [fightsInfo allKeys].count>0) {
                self.mLB_formAirport.text = fightsInfo[@"org"];
                self.mLB_tomAirport.text = fightsInfo[@"dst"];
            }
            
             self.mDataSoure = [NSMutableArray arrayWithArray:@[[NSMutableArray arrayWithArray:@[@"订单号",@"申请人",@"电话",@"创建时间",@"订单状态",@"退票类型",@"退票金额"]],[NSMutableArray arrayWithArray:@[@"登机人"]],@[@"退票说明"]]];
            
            NSArray *passangers = tempRTNs[0][@"passengers"];
           NSMutableArray *tempPassengers = self.mDataSoure[1];
            
            for (NSDictionary *temp in passangers) {
                [tempPassengers insertObject:temp atIndex:1];
            }
           
            [self.mInfoTbaleView reloadData];
        }
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark private

-(UITableViewCell *)loadNormalWGOderCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdFightInfoCell"];
        SLsdFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdFightInfoCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    if (indexPath.section == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdTGQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTGQCell"];
        SLsdTGQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTGQCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    if (indexPath.section == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdCell"];
        SLsdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdCell"];
        cell.mLb_title.text = self.mDataSoure[indexPath.section][indexPath.row];
        if (self.mOderDetialModel) {
            NSString *mTripPurpose = @"";
            if (self.mOderDetialModel.mTripPurpose) {
                mTripPurpose = self.mOderDetialModel.mTripPurpose;
            }
            
            NSString *mOderId = @"";
            if (self.mOderModel.mOderId) {
                mOderId = [self.mOderModel.mOderId stringValue];
            }
            
            NSString *mTicketNum = @"还未出票";
            if (self.mOderDetialModel.mTicketNum) {
                mTicketNum = self.mOderDetialModel.mTicketNum;
            }
            
            NSString *mBookTime = @"";
            if (self.mOderModel.mBookTime) {
                mBookTime = [self.mOderModel.mBookTime stringByAppendingString:@"预定"];//[self.mOderDetialModel.mBookTime substringToIndex:15];
            }
            
            NSString *mBookStatus = @"";
            if (self.mOderDetialModel.mBookStatus) {
                mBookStatus = [self.mOderDetialModel.mBookStatus stringValue];
            }
            
            NSDictionary *_bookStatusDic = @{@"10":@"待审核",@"11":@"审核被拒",@"101":@"待支付",@"201":@"待出票",@"202":@"出票中",@"203":@"已出票",@"204":@"出票失败",@"301":@"待取消",@"302":@"取消中",@"303":@"已取消",@"304":@"取消失败",@"401":@"待退票",@"402":@"退票中",@"404":@"退票失败",@"501":@"待改签",@"502":@"改签中",@"503":@"已改签",@"504":@"改签失败"};
            
            NSArray *temp = @[mOderId,mTicketNum ,mBookTime,mTripPurpose,_bookStatusDic[mBookStatus]];
            
            cell.mlb_subTitle.text = [NSString stringWithFormat:@"%@",temp[indexPath.row]];
        }
        
        return cell;
    }
    
    if(indexPath.section == 3){
        [tableView registerNib:[UINib nibWithNibName:@"SLsdInsureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdInsureCell"];
        SLsdInsureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdInsureCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
        
    }
    
    if(indexPath.section == 4){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"登机人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        NSDictionary *temp = self.mDataSoure[indexPath.section][indexPath.row];
        [cell loadCellInfoWithModel:temp];
        return cell;
        
    }
    
    if (indexPath.section == 5) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdTGQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTGQCell"];
        SLsdTGQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTGQCell"];
        [cell loadwgCellInfoWithModel:self.mOderDetialModel.illegalReasons];
        if (indexPath.row == 0) {
            cell.mLb_title.text =  self.mDataSoure[indexPath.section][indexPath.row];
        }
        
        return cell;
    }
    
    if(indexPath.section == 6){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"联系人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        [cell loadLianCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    
    if(indexPath.section == 7){
        [tableView registerNib:[UINib nibWithNibName:@"SLsdSendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdSendCell"];
        SLsdSendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdSendCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
        
    }
    
    NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}
-(UITableViewCell *)loadNormalOderCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdFightInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdFightInfoCell"];
        SLsdFightInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdFightInfoCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    if (indexPath.section == 1) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdTGQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTGQCell"];
        SLsdTGQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTGQCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    if (indexPath.section == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdCell"];
        SLsdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdCell"];
        cell.mLb_title.text = self.mDataSoure[indexPath.section][indexPath.row];
        if (self.mOderDetialModel) {
            NSString *mTripPurpose = @"";
            if (self.mOderDetialModel.mTripPurpose) {
                mTripPurpose = self.mOderDetialModel.mTripPurpose;
            }
            
            NSString *mOderId = @"";
            if (self.mOderModel.mOderId) {
                mOderId = [self.mOderModel.mOderId stringValue];
            }
            
            NSString *mTicketNum = @"还未出票";
            if (self.mOderDetialModel.mTicketNum) {
                mTicketNum = self.mOderDetialModel.mTicketNum;
            }
            
            NSString *mBookTime = @"";
            if (self.mOderModel.mBookTime) {
                mBookTime = [self.mOderModel.mBookTime stringByAppendingString:@"预定"];//[self.mOderDetialModel.mBookTime substringToIndex:15];
            }
            NSString *mBookStatus = @"";
            if (self.mOderDetialModel.mBookStatus) {
                
                
                mBookStatus = [self.mOderDetialModel.mBookStatus stringValue];
            }
            
            NSDictionary *_bookStatusDic = @{@"10":@"待审核",@"11":@"审核被拒",@"101":@"待支付",@"201":@"待出票",@"202":@"出票中",@"203":@"已出票",@"204":@"出票失败",@"301":@"待取消",@"302":@"取消中",@"303":@"已取消",@"304":@"取消失败",@"401":@"待退票",@"402":@"退票中",@"404":@"退票失败",@"501":@"待改签",@"502":@"改签中",@"503":@"已改签",@"504":@"改签失败"};
            
            NSArray *temp = @[mOderId,mTicketNum ,mBookTime,mTripPurpose,_bookStatusDic[mBookStatus]];
            
            cell.mlb_subTitle.text = [NSString stringWithFormat:@"%@",temp[indexPath.row]];
        }
        
        return cell;
    }
    
    if(indexPath.section == 3){
        [tableView registerNib:[UINib nibWithNibName:@"SLsdInsureCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdInsureCell"];
        SLsdInsureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdInsureCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
        
    }
    
    if(indexPath.section == 4){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"登机人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        NSDictionary *temp = self.mDataSoure[indexPath.section][indexPath.row];
        [cell loadCellInfoWithModel:temp];
        return cell;
        
    }
    
    if(indexPath.section == 5){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"联系人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        [cell loadLianCellInfoWithModel:self.mOderDetialModel];
        return cell;
    }
    
    
    if(indexPath.section == 6){
        [tableView registerNib:[UINib nibWithNibName:@"SLsdSendCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdSendCell"];
        SLsdSendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdSendCell"];
        [cell loadCellInfoWithModel:self.mOderDetialModel];
        return cell;
        
    }
    
    NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}


-(UITableViewCell *)loadTPGQOderCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdCell"];
        SLsdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdCell"];
        cell.mLb_title.text = self.mDataSoure[indexPath.section][indexPath.row];
        
        if (_TPinfos) {
            @try {
                cell.mlb_subTitle.text = [NSString stringWithFormat:@"%@",_TPinfos[indexPath.row]];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    
        return cell;
    }

    
    if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"登机人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        NSDictionary *temp = self.mDataSoure[indexPath.section][indexPath.row];
        [cell loadCellInfoWithModel:temp];
        return cell;
        
    }
    
    if (indexPath.section == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdTGQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTGQCell"];
        SLsdTGQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTGQCell"];
        [cell loadTPCellInfoWithModel:_TPReasonArray];
        if (indexPath.row == 0) {
            cell.mLb_title.text =  self.mDataSoure[indexPath.section][indexPath.row];
        }
      
        return cell;
    }
    

    
    NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}
-(UITableViewCell *)loadGQOderCellTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdCell"];
        SLsdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdCell"];
        cell.mLb_title.text = self.mDataSoure[indexPath.section][indexPath.row];
        
        if (_GQinfos) {
            @try {
                id temp = _GQinfos[indexPath.row];
              
                if (temp == [NSNull null]) {
                    cell.mlb_subTitle.text = @"无";
                }else{
                  cell.mlb_subTitle.text = [NSString stringWithFormat:@"%@",temp];
                }
            } @catch (NSException *exception) {
                
            }
        }
        
        return cell;
    }
    
    
    if(indexPath.section == 1){
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"SLsdTwoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTwoCell"];
            SLsdTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTwoCell"];
            cell.mLb_title.text = @"登机人";
            return cell;
        }
        
        [tableView registerNib:[UINib nibWithNibName:@"SLsdPopleInfoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdPopleInfoCell"];
        SLsdPopleInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdPopleInfoCell"];
        NSDictionary *temp = self.mDataSoure[indexPath.section][indexPath.row];
        [cell loadCellInfoWithModel:temp];
        return cell;
        
    }
    
    if (indexPath.section == 2) {
        [tableView registerNib:[UINib nibWithNibName:@"SLsdTGQCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLsdTGQCell"];
        SLsdTGQCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLsdTGQCell"];
        [cell loadTPCellInfoWithModel:_GQReasonArray];
        if (indexPath.row == 0) {
            cell.mLb_title.text =  self.mDataSoure[indexPath.section][indexPath.row];
        }
        
        return cell;
    }
    
    
    
    NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    return cell;
}
- (void)intervalSinceNow:(NSString *) theDate Btn:(UIButton *)sender{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:theDate];
    
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:CreateDate];
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    [adcomps setYear:0];
//    [adcomps setMonth:0];
//    [adcomps setDay:0];
//    [adcomps setMinute:+30];
//    NSDate *endDate = [calendar dateByAddingComponents:adcomps toDate:CreateDate options:0];
    
    if (endDate == nil) {
        return;
    }

    //    NSDate *endDate = theDate;
    NSDate *startDate = [NSDate date];
    //得到相差秒数
    NSTimeInterval timeInterval =[endDate timeIntervalSinceDate:startDate];
    
    if (timeInterval==0) {
    }else{
        
    }
    //    这里用到这个 dispatch_source_t _timer;
    //    把timer定义为全局的。
    
    if (_timer==nil) {
        __block int timeout = timeInterval; //倒计时时间
        
        if (timeout!=0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.mLB_mark setText:@"订单已超时"];
                        [sender setTitle:@"订单的已超时" forState:UIControlStateNormal];
                    });
                }else{
                    __block  NSString * daysStr;
                    __block  NSString * hoursStr;
                    __block  NSString * minuteStr;
                    __block  NSString * secondStr;
                    
                    int days = (int)(timeout/(3600*24));
                    if (days==0) {
                        daysStr = @"";
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (days==0) {
                            daysStr = @"";
                        }else{
                            daysStr = [NSString stringWithFormat:@"%d天",days];
                        }
                        
                        if (hours<10) {
                            hoursStr = [NSString stringWithFormat:@"0%d",hours];
                        }else{
                            hoursStr = [NSString stringWithFormat:@"%d",hours];
                        }
                        
                        if (minute<10) {
                            minuteStr = [NSString stringWithFormat:@"0%d",minute];
                        }else{
                            minuteStr = [NSString stringWithFormat:@"%d",minute];
                        }
                        
                        if (second<10) {
                            secondStr = [NSString stringWithFormat:@"0%d",second];
                        }else{
                            secondStr = [NSString stringWithFormat:@"%d",second];
                        }
                        
                        //  NSLog(@"asd ==== %@小时%@分%@秒",hoursStr,minuteStr,secondStr);
                        if ([self.mOderModel.mBookStatus intValue] == 101) {
                            [sender setTitle:[NSString stringWithFormat:@"请于%@小时%@分%@秒内完成支付，逾期将自动取消",hoursStr,minuteStr,secondStr] forState:UIControlStateNormal];
                        }else{
                         [sender setTitle:[NSString stringWithFormat:@"审核倒计时%@小时%@分%@秒",hoursStr,minuteStr,secondStr] forState:UIControlStateNormal];
                        }
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
        }
    }
    
}

#pragma mark event response
- (IBAction)onclickGoBackBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//退票
- (void)onclickSQBtn:(UIButton *)sender {
    
    [[CCActionSheet shareSheet]cc_actionSheetWithSelectArray:@[@"自愿退票",@"非自愿退票"] deltalArray:@[@"",@""] cancelTitle:@"取消"  delegate:self titile:@"选择退票类型"];
    
   
}
//改签
- (void)onclickGQBtn:(UIButton *)sender {
    SLTicketAlterationVC *mTempVC = [[SLTicketAlterationVC alloc]init];
    mTempVC.mOderDetialModel = self.mOderDetialModel;
    mTempVC.mOderModel = self.mOderModel;
    [self.navigationController pushViewController:mTempVC animated:YES];
}
//支付
- (void)onclickPayBtn:(UIButton *)sender {
    
    NSString *title = NSLocalizedString(@"选择支付方式", nil);
    NSString *message = NSLocalizedString(@"", nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *aliPayButtonTitle = NSLocalizedString(@"支付宝", nil);
    NSString *wxButtonTitle = NSLocalizedString(@"微信", nil);
    NSString *otherButtonTitle = NSLocalizedString(@"司账户支付", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //取消
    }];
    UIAlertAction *AliAction = [UIAlertAction actionWithTitle:aliPayButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //支付宝
    }];
    
    UIAlertAction *wxAction = [UIAlertAction actionWithTitle:wxButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //微信
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
       //公司
        [SVProgressHUD show];
        [HttpApi checkUseCompanyAccountPay:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
            if ([responseBody[@"isUsed"] integerValue ]== 1) {
                [SVProgressHUD dismiss];
                
                UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"请输入密码" message:message preferredStyle:UIAlertControllerStyleAlert];
                
              // __block NSString *passWord;
                
                // Create the actions.
                UIAlertAction *cancelAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                }];
                
                UIAlertAction *otherAction1 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
                    if (passWord== nil || passWord.length ==0) {
                        ShowMSG(@"密码不能为空");
                        return ;
                    }
                    
                    NSDictionary *paraDic = @{@"userId":sl_userID,@"dataType":@"1",@"orderNo":self.mOderDetialModel.mOrderNo,@"password":[MyFounctions md5:passWord]};
                    [SVProgressHUD show];
                    [HttpApi payCompanyAccount:paraDic SuccessBlock:^(id responseBody) {
                        [SVProgressHUD showSuccessWithStatus:@"支付成功"];

                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:YES];
                        });
                    } FailureBlock:^(NSError *error) {
                        
                    }];
                }];
                
                // Add the actions.
                [alertController1 addAction:cancelAction1];
                [alertController1 addAction:otherAction1];
                
                [alertController1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    // 可以在这里对textfield进行定制，例如改变背景色
                    //textField.backgroundColor = [UIColor orangeColor];
                    textField.secureTextEntry = YES;
                   [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                }];
                
                [self presentViewController:alertController1 animated:YES completion:nil];
            }else{
                [SVProgressHUD dismiss];
                ShowMSG(@"您的账户不支持公司支付");
                
               
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [alertController addAction:AliAction];
    [alertController addAction:wxAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)textFieldDidChange:(UITextField *)sender{
    passWord = sender.text;
}
- (void)cc_actionSheetDidSelectedIndex:(NSInteger)index SelectBtn:(UIButton *)sender{
    if (index == 0) {
        return;
    }
    
    SLReturnTicketVC *mTempVC = [[SLReturnTicketVC alloc]init];
    mTempVC.mOderDetialModel = self.mOderDetialModel;
    mTempVC.mOderModel = self.mOderModel;
    [self.navigationController pushViewController:mTempVC animated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if(section == self.mDataSoure.count - 1){
        return 120.0f;
    }
    
     return 5.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [self.mDataSoure[section] count];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (_TPinfos || _GQinfos) {
        return nil;
    }
    
    if(section == self.mDataSoure.count - 1){
        
        if (mFootterView == nil) {
            mFootterView = [UIView new];
            [mFootterView setBackgroundColor:SL_GRAY];
        }
        
        
        if ([self.mOderModel.mBookStatus intValue] == 10) {
            
            if (mPayTime == nil) {
                mPayTime = [UIButton buttonWithType:UIButtonTypeCustom];
                [mPayTime setBackgroundColor:[UIColor whiteColor]];
                // [mPayTime setTitle:@"申请改签" forState:UIControlStateNormal];
                [mPayTime.titleLabel setFont:DEFAULT_FONT(14)];
                [mPayTime setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                // [mPayTime addTarget:self action:@selector(onclickGQBtn:) forControlEvents:UIControlEventTouchUpInside];
                [mFootterView addSubview:mPayTime];
                [mPayTime mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(8);
                    make.left.mas_equalTo(13);
                    make.right.mas_equalTo(-13);
                    make.height.mas_equalTo(35);
                }];
                
            }
            
            [self intervalSinceNow:self.mOderDetialModel.mPaytimeout Btn:mPayTime];
            
            return mFootterView;
        }
        
        
        if ([self.mOderModel.mBookStatus intValue] == 101) {
           
            if (mPayTime == nil) {
                mPayTime = [UIButton buttonWithType:UIButtonTypeCustom];
                [mPayTime setBackgroundColor:[UIColor whiteColor]];
               // [mPayTime setTitle:@"申请改签" forState:UIControlStateNormal];
                [mPayTime.titleLabel setFont:DEFAULT_FONT(14)];
                [mPayTime setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
               // [mPayTime addTarget:self action:@selector(onclickGQBtn:) forControlEvents:UIControlEventTouchUpInside];
                [mFootterView addSubview:mPayTime];
                [mPayTime mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(25);
                    make.left.mas_equalTo(13);
                    make.right.mas_equalTo(-13);
                    make.height.mas_equalTo(35);
                }];

            }
            
            if (mSQBtn == nil) {
                mSQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                mSQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [mSQBtn setBackgroundColor:SL_BULE];
                [mSQBtn setTitle:@"去支付" forState:UIControlStateNormal];
                [mSQBtn.titleLabel setFont:DEFAULT_FONT(14)];
                [mSQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [mSQBtn addTarget:self action:@selector(onclickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
                [mFootterView addSubview:mSQBtn];
                [mSQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(mPayTime.mas_bottom).with.offset(8);
                    make.left.mas_equalTo(13);
                    make.right.mas_equalTo(-13);
                    make.height.mas_equalTo(35);
                }];
                
            }
            
            [self intervalSinceNow:self.mOderDetialModel.mPaytimeout Btn:mPayTime];
            
             return mFootterView;
        }
        
        if ([self.mOderModel.mBookStatus intValue] == 203) {
//            UIView *mFootterView = [UIView new];
            if (mSQBtn == nil) {
                mSQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            }
            
            [mSQBtn setBackgroundColor:SL_BULE];
            [mSQBtn setTitle:@"申请退票" forState:UIControlStateNormal];
            [mSQBtn.titleLabel setFont:DEFAULT_FONT(14)];
            [mSQBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [mSQBtn addTarget:self action:@selector(onclickSQBtn:) forControlEvents:UIControlEventTouchUpInside];
            [mFootterView addSubview:mSQBtn];
            [mSQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(25);
                make.left.mas_equalTo(13);
                make.right.mas_equalTo(-13);
                make.height.mas_equalTo(35);
            }];
            
            UIButton *mGQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [mGQBtn setBackgroundColor:[UIColor whiteColor]];
            [mGQBtn setTitle:@"申请改签" forState:UIControlStateNormal];
            [mGQBtn.titleLabel setFont:DEFAULT_FONT(14)];
            [mGQBtn setTitleColor:SL_GRAY_BLACK forState:UIControlStateNormal];
            [mGQBtn addTarget:self action:@selector(onclickGQBtn:) forControlEvents:UIControlEventTouchUpInside];
            [mFootterView addSubview:mGQBtn];
            [mGQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(70);
                make.left.mas_equalTo(13);
                make.right.mas_equalTo(-13);
                make.height.mas_equalTo(35);
            }];
            
            return mFootterView;
        }
        
    }
    
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_TPinfos) {
      return   [self loadTPGQOderCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }else if(_GQinfos){
      return   [self loadGQOderCellTableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        if (self.mOderDetialModel.illegalReasons && self.mOderDetialModel.illegalReasons.count>0 && [self.mOderDetialModel.mBookStatus integerValue] == 10) {
            return [self loadNormalWGOderCellTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        return  [self loadNormalOderCellTableView:tableView cellForRowAtIndexPath:indexPath];
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
