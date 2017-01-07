//
//  SLSettingVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSettingVC.h"
#import "SLLoginVC.h"
@interface SLSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *mDataSoure;

@end

@implementation SLSettingVC
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark gtter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@[@"显示语言",@"检查更新"],@[@"退出登录"]];
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return (MainScreenFrame_Height-64)/3;
    }
    return 10.00f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *mTempView = [[UIView alloc]init];
       // [mTempView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *mLogoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_logo"]];
        [mTempView addSubview:mLogoImageView];
        [mLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-20);
            make.width.height.mas_equalTo(70);
        }];
        
        UILabel *mTempLable = [[UILabel alloc]init];
        [mTempLable setFont:DEFAULT_FONT(15)];
        [mTempLable setTextColor:SL_GRAY_BLACK];
        [mTempLable setText:[NSString stringWithFormat:@"%@%@",@"无线商旅",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]]];
        [mLogoImageView addSubview:mTempLable];
        [mTempLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(mLogoImageView.mas_bottom).with.offset(15);
            make.centerX.mas_equalTo(0);
        }];
    
        return mTempView;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row];
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    
    [cell.detailTextLabel setFont:DEFAULT_FONT(15)];
    [cell.detailTextLabel setTextColor:SL_GRAY_BLACK];
    
    cell.detailTextLabel.text = @"已经是最新";
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"跟随系统";
    }
    
    if (indexPath.section == 1) {
        [cell.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        [cell.textLabel setTextColor:SL_BULE];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [MyFounctions removeUserInfo];
        [MyFounctions removeUserDetailInfo];
        SLLoginVC *mLoginVC = [[SLLoginVC alloc]initWithNibName:@"SLLoginVC" bundle:[NSBundle mainBundle]];
        UINavigationController *mNav = [[UINavigationController alloc]initWithRootViewController:mLoginVC];
        [self presentViewController:mNav animated:YES completion:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }else{
        [self checkNewVersion];
    }
}
#pragma mark private
-(void)checkNewVersion{
    if (sl_userID) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
        [SVProgressHUD show];
        [[SLNetWorkingHelper shareNetWork]getVersionUpdate:@{@"userId":sl_userID,@"version":v} SuccessBlock:^(id responseBody) {
            
            [SVProgressHUD dismiss];
            
            UIAlertController *alertController;
            NSString *mTitle = responseBody[@"content"];
            
            if([mTitle isEqual:[NSNull null]]){
                return ;
            }
            
            if (mTitle == nil || mTitle.length == 0) {
                mTitle = [[NSUserDefaults standardUserDefaults]objectForKey:@"vv"];
            }
            
            NSInteger tempIsforce = [responseBody[@"isforce"] integerValue];
            
            if (tempIsforce == 0) {
                alertController = [UIAlertController alertControllerWithTitle:APPName message:mTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSString *urlStr = responseBody[@"downloadUrl"];
                    if([urlStr isEqual:[NSNull null]]){
                        return ;
                    }
                    if (urlStr && urlStr.length>0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                    
                    
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
            }else if(tempIsforce == 1){
                //强制更新
                alertController = [UIAlertController alertControllerWithTitle:APPName message:mTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
                    NSString *urlStr = responseBody[@"downloadUrl"];
                    if([urlStr isEqual:[NSNull null]]){
                        return ;
                    }
                    if (urlStr && urlStr.length>0) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
                    }
                }];
                [alertController addAction:okAction];
                
            }
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        } FailureBlock:^(NSError *error) {
            
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
