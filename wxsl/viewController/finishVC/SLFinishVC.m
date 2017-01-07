//
//  SLFinishVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFinishVC.h"
#import "SLOrdersVC.h"
@interface SLFinishVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *mLB_mark;

@property (weak, nonatomic) IBOutlet UILabel *mLB_price;
@property(nonatomic,retain)NSArray *mDatasoure;
@property(nonatomic,retain)NSArray *mImgDatasoure;
@end

@implementation SLFinishVC{
      dispatch_source_t _timer;
    __block NSString *passWord;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *mRightBarBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(onclickBackBtn:)];
    self.navigationItem.leftBarButtonItem = mRightBarBtn;
    
    self.mLB_price.text = self.mPirceStr;
    
    if (self.paytimeout && self.paytimeout.length>0 && self.mCreateTime && self.mCreateTime.length>0) {

        [self intervalSinceNow:self.paytimeout];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark  getter
-(NSArray *)mDatasoure{
    if (_mDatasoure == nil) {
        if([self.audit intValue] == 2){
            _mDatasoure = @[@[@"查看订单"],@[@"支付方式",@"支付宝支付",@"微信支付",@"公司支付支付"]];
        }else{
            _mDatasoure = @[@[@"查看订单"],@[]];
        }
    }
    return _mDatasoure;
}
-(NSArray *)mImgDatasoure{
    if (_mImgDatasoure == nil) {
        _mImgDatasoure = @[@"alipay",@"wxpay",@"pay"];
    }
    return _mImgDatasoure;
}
#pragma mark response
-(void)onclickBackBtn:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)intervalSinceNow:(NSString *) theDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:theDate];
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
                        [self.mLB_mark setText:@"订单已超时"];
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
                        if([self.audit intValue] == 2){
                          [self.mLB_mark setText:[NSString stringWithFormat:@"请于%@小时%@分%@秒内完成支付，逾期将自动取消",hoursStr,minuteStr,secondStr]];
                        }else{
                         [self.mLB_mark setText:[NSString stringWithFormat:@"审核倒计时%@小时%@分%@秒",hoursStr,minuteStr,secondStr]];
                        }
                      
                    });
                    timeout--;
                    
                }
            });
            dispatch_resume(_timer);
        }
    }

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDatasoure.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.mDatasoure[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_Hard];
    [cell.textLabel setText:self.mDatasoure[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 1 && indexPath.row>0) {
        [cell.imageView setImage:[UIImage imageNamed:self.mImgDatasoure[indexPath.row - 1]]];
    }else{
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SLOrdersVC *mOderVC = [[SLOrdersVC alloc]init];
        [self.navigationController pushViewController:mOderVC animated:YES];
    }else{
        if (indexPath.row == 3) {
            [SVProgressHUD show];
            [HttpApi checkUseCompanyAccountPay:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
                if ([responseBody[@"isUsed"] integerValue ]== 1) {
                    [SVProgressHUD dismiss];
                    
                    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:@"请输入密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    
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
                        
                        NSDictionary *paraDic = @{@"userId":sl_userID,@"dataType":@"1",@"orderNo":self.orderNo,@"password":[MyFounctions md5:passWord]};
                        [HttpApi payCompanyAccount:paraDic SuccessBlock:^(id responseBody) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self.navigationController popToRootViewControllerAnimated:YES];
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
        }
    
    }

}

-(void)textFieldDidChange:(UITextField *)sender{
    passWord = sender.text;
}
@end
