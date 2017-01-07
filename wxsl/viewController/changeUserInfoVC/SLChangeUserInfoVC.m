//
//  SLChangeUserInfoVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLChangeUserInfoVC.h"
#import "SLCUHeadImageCell.h"
#import "SLChangeDataVC.h"
#import "SLCUIdCardCell.h"
#import "SLAddCertificateVC.h"

#import "SLDataPickerView.h"
#import "SLDatePickerView.h"

#import <QiniuSDK.h>
@interface SLChangeUserInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,SLDataPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property(nonatomic,retain)NSMutableArray *mUserInfo;
@property(nonatomic,retain)NSIndexPath* mSelectIndex;
/**
 *  用户信息
 */
@property(nonatomic,retain) SLUserInfoModel *mUserInfoModel;
/**
 *  不猛
 */
@property(nonatomic,retain)NSArray *mDeparts;
@end

@implementation SLChangeUserInfoVC{
    NSString * _chinsesName;
    NSString * _englishName;
    NSString * _email;
    NSString * _sex;
    NSString * _birthday;
    NSString * _DId;
    NSString * _cost;
    NSMutableArray *_docInfos;
    
    NSString *_headImageStr;
    
}
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _headImageStr = @"";
    self.title = @"修改个人信息";
    self.mInfoTableView.separatorColor = SL_GRAY;
    
    [self addSaveBarBtn];
    
    [self getUserInfoNetWroking];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mInfoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSArray *)mDeparts{
    if (_mDeparts == nil) {
       //_mDeparts = @[@{@"no":@"23",@"name":@"售后部"}];
        _mDeparts = @[];
    }
    
    return _mDeparts;
}
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithArray:@[@[@"头像",@"中文名字",@"英文名",@"邮箱"],@[@"性别",@"出生日期",@"费用归属"],[NSMutableArray arrayWithArray:@[@"证件类型"]]]];
    }
    return _mDataSoure;
}
-(NSMutableArray *)mUserInfo{
    if (_mUserInfo == nil) {
        _mUserInfo = [NSMutableArray arrayWithArray:@[@[@"",@"",@"",@""],@[@"",@"",@""],@[@"",@{@"IDtype":@"身份证",@"IDNum":@"500231********1852",@"IDtime":@"2014.1.1"}]]];
    }
    return _mUserInfo;
}
#pragma mark netWorking

-(void)getDepartList{
    [HttpApi getDepartList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
//        LDLOG(@"部门列表%@",responseBody);
        self.mDeparts = responseBody[@"departs"];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
-(void)getUserInfoNetWroking{

    [HttpApi getUserInfo:@{@"userId":sl_userID} isShowLoadingView:NO SuccessBlock:^(id responseBody) {
       // LDLOG(@"用户信息 ==== %@",responseBody);
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:responseBody];
        
        [MyFounctions saveDetailUserInfo:userInfo];
        
        [self getDepartList];
        
        NSError *error;
        self.mUserInfoModel = [MTLJSONAdapter modelOfClass:[SLUserInfoModel class] fromJSONDictionary:responseBody error:&error];
        
        NSString *sexStr;
        if ([self.mUserInfoModel.mSex integerValue] == 1) {
            sexStr =@"男";
        }else{
            sexStr =@"女";
        }
    
        _chinsesName = self.mUserInfoModel.mChineseName;
        _englishName = self.mUserInfoModel.mEnglishName;
        _email = self.mUserInfoModel.mEmail;
        _sex = [self.mUserInfoModel.mSex stringValue];
        _birthday = self.mUserInfoModel.mBirthday;
        _DId = [self.mUserInfoModel.mDid stringValue];
        _docInfos = [NSMutableArray arrayWithObjects:@"证件类型", nil];
        if(self.mUserInfoModel.mDocTypes && self.mUserInfoModel.mDocTypes.count>0){
            for (NSDictionary *mDic in self.mUserInfoModel.mDocTypes) {
                [_docInfos insertObject:mDic atIndex:1];
            }
        }
        
        NSString*headUrl = @"";
        if (self.mUserInfoModel.mHeadimgurl) {
            headUrl = self.mUserInfoModel.mHeadimgurl;
        }
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:@[@[headUrl,self.mUserInfoModel.mChineseName,self.mUserInfoModel.mEnglishName,self.mUserInfoModel.mEmail],@[sexStr,self.mUserInfoModel.mBirthday,self.mUserInfoModel.mDName],[NSMutableArray arrayWithArray:_docInfos]]];
        
        self.mUserInfo = temp;
        
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        NSMutableDictionary *userInfoDic = [MyFounctions getUserDetailInfo];
        if (userInfoDic && [userInfoDic allKeys]>0) {
            
            [self getDepartList];
            
            NSError *error;
            self.mUserInfoModel = [MTLJSONAdapter modelOfClass:[SLUserInfoModel class] fromJSONDictionary:userInfoDic error:&error];
            
            NSString *sexStr;
            if ([self.mUserInfoModel.mSex integerValue] == 1) {
                sexStr =@"男";
            }else{
                sexStr =@"女";
            }
            
            _chinsesName = self.mUserInfoModel.mChineseName;
            _englishName = self.mUserInfoModel.mEnglishName;
            _email = self.mUserInfoModel.mEmail;
            _sex = [self.mUserInfoModel.mSex stringValue];
            _birthday = self.mUserInfoModel.mBirthday;
            _DId = [self.mUserInfoModel.mDid stringValue];
            _docInfos = [NSMutableArray arrayWithArray:self.mUserInfoModel.mDocTypes];
            
            NSMutableArray *temp = [NSMutableArray arrayWithArray:@[@[@"",self.mUserInfoModel.mChineseName,self.mUserInfoModel.mEnglishName,self.mUserInfoModel.mEmail],@[sexStr,self.mUserInfoModel.mBirthday,self.mUserInfoModel.mDName],[NSMutableArray arrayWithArray:@[@"证件类型"]]]];
            
            self.mUserInfo = temp;
            
            [self.mInfoTableView reloadData];
            
        }

    }];
}
#pragma mark private
-(void)upHeadImage:(NSData *)imageData{
    [HttpApi getUptoken:@{@"type":@"1",@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        _headImageStr= responseBody[@"fname"];
        NSString *uptokenStr = responseBody[@"uptoken"];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        QNUploadOption *upoPtion = [[QNUploadOption alloc]initWithProgressHandler:^(NSString *key, float percent) {
             [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [SVProgressHUD showProgress:percent maskType:SVProgressHUDMaskTypeGradient ];
        }];
        [upManager putData:imageData key:_headImageStr token:uptokenStr complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@"%@", info);
            NSLog(@"%@", resp);
            [SVProgressHUD showSuccessWithStatus:@"成功"];
        } option:upoPtion];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)addSaveBarBtn{
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mBtn setTitle:@"保存" forState:UIControlStateNormal];
    mBtn.frame = CGRectMake(0, 0, 50, 50);
    [mBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [mBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mBtn.titleLabel setTextColor:SL_GRAY_BLACK];
    [mBtn addTarget:self action:@selector(onclickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mSaveBtn = [[UIBarButtonItem alloc]initWithCustomView:mBtn];
    self.navigationItem.rightBarButtonItem = mSaveBtn;
}
#pragma mark event response
-(void)onclickSaveBtn:(UIButton *)sender{
    if (_chinsesName == nil || _chinsesName.length == 0) {
        ShowMSG(@"请输入中文名字");
        return;
    }
    
    if (_englishName == nil || _englishName.length == 0) {
        ShowMSG(@"请输入英文名字");
        return;
    }
    
    if (_email == nil || _email.length == 0) {
        ShowMSG(@"请输入邮箱");
        return;
    }
    
    if (_sex == nil || _sex.length == 0) {
        ShowMSG(@"请输入性别");
        return;
    }
    
    if (_birthday == nil || _birthday.length == 0) {
        ShowMSG(@"请输入出生年月");
        return;
    }
    
    if (_DId == nil || _DId.length == 0) {
        ShowMSG(@"请输入费用归属");
        return;
    }
    
    if (_docInfos== nil || _docInfos.count == 1) {
        ShowMSG(@"请添加证件");
        return;
    }
    NSMutableArray *mdocTypes = [NSMutableArray array];
    
    for (NSDictionary *temoDic in _docInfos) {
        if([temoDic isKindOfClass:[NSDictionary class]]){
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:temoDic];
            [dic removeObjectForKey:@"IDname"];
            
            NSString *mtempkey = dic[@"type"];
            NSDictionary *tempDci1 = @{@"身份证":@"1",@"护照":@"2",@"军人证":@"3",@"回乡证":@"4",@"港澳通行证":@"5",@"台胞证":@"6",@"其他":@"0"};
            if ([[tempDci1 allKeys]containsObject:mtempkey]) {
                [dic setObject:tempDci1[mtempkey] forKey:@"type"];
                
            }
            [mdocTypes addObject:dic];
        }
    }
    
    if (mdocTypes.count == 0 || mdocTypes == nil) {
        return;
    }
    
    NSData *mData = [NSJSONSerialization dataWithJSONObject:mdocTypes options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc]initWithData:mData encoding:NSUTF8StringEncoding];
    
    
    NSDictionary *mParamDic = @{@"userId":sl_userID,@"ename":_englishName,@"headimgurl":_headImageStr,@"zname":_chinsesName,@"email":_email,@"sex":_sex,@"birthday":_birthday,@"docTypes":string};
    [SVProgressHUD show];
    [HttpApi putMyInfo:mParamDic SuccessBlock:^(id responseBody) {
        [SVProgressHUD showSuccessWithStatus:@"成功"];
        
        [MyFounctions removeUserDetailInfo];
        
        [self getUserInfoNetWroking];
        
        //[self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
-(void)onclickAddIdCard:(UIButton *)sender{
    LDLOG(@"增加证件");
    SLAddCertificateVC *mAddCerVC = [[SLAddCertificateVC alloc]init];
    [self.navigationController pushViewController:mAddCerVC animated:YES];
    
    [mAddCerVC backIdInfo:^(NSDictionary *IDInfoDIc) {
        if (_docInfos == nil) {
            _docInfos  =[NSMutableArray arrayWithObject:IDInfoDIc];
        }else{
            [_docInfos addObject:IDInfoDIc];
        }
        
        NSMutableArray *temp = self.mUserInfo[2];
        [temp insertObject:IDInfoDIc atIndex:1];
        
        [self.mInfoTableView reloadSections:[[NSIndexSet alloc]initWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }];
}
#pragma mark SLDataPickerViewDelegate
-(void)SLDataPickerView:(SLDataPickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    LDLOG(@"%@",str);
    if (self.mSelectIndex.row == 0) {
        if ([str isEqualToString:@"男"]) {
            _sex = @"1";
        }else{
            _sex = @"2";
        }
    }
    if ([str isKindOfClass:[NSDictionary class]]) {
        NSDictionary *temp = (NSDictionary *)str;
        UITableViewCell *cell = [self.mInfoTableView cellForRowAtIndexPath:self.mSelectIndex];
        cell.detailTextLabel.text = temp[@"name"];
        _DId = temp[@"no"];
        return;
    }
    
    UITableViewCell *cell = [self.mInfoTableView cellForRowAtIndexPath:self.mSelectIndex];
    cell.detailTextLabel.text = str;
}
#pragma mark SLDatePickerViewDelegate
-(void)SLDatePickerView:(SLDatePickerView *)view onclickCompleBtn:(UIButton *)sender SelectedStr:(NSString *)str{
    LDLOG(@"%@",str);
    _birthday = str;
    UITableViewCell *cell = [self.mInfoTableView cellForRowAtIndexPath:self.mSelectIndex];
    cell.detailTextLabel.text = str;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataSoure.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 2 && self.mUserInfo.count>=2 && self.mUserInfo){
        return [self.mUserInfo[section] count];
    }
    
    NSArray *mTemp = self.mDataSoure[section];
    return mTemp.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 75;
    }
    return 45.00f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.00f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        static NSString *cellIndetifier = @"SLCUHeadImageCell";
        [tableView registerNib:[UINib nibWithNibName:@"SLCUHeadImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndetifier];
        SLCUHeadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        [cell.mImg_head setBackgroundColor:SL_BULE];
        NSURL *tempUrl = [NSURL URLWithString:self.mUserInfo [indexPath.section][indexPath.row]];
        [cell.mImg_head sd_setImageWithURL:tempUrl placeholderImage:nil options:SDWebImageRefreshCached];
        cell.mLB_title.text = self.mDataSoure[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 2 && indexPath.row > 0) {
        //证件
        static NSString *cellIndetifier = @"SLCUIdCardCell";
        [tableView registerNib:[UINib nibWithNibName:@"SLCUIdCardCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndetifier];
        SLCUIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        [cell loadCellInfoWithModel:self.mUserInfo[indexPath.section][indexPath.row]];
        return cell;
    }
    
    static NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndetifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row];
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    cell.detailTextLabel.text = self.mUserInfo[indexPath.section][indexPath.row];
    [cell.detailTextLabel setFont:DEFAULT_FONT(15)];
    [cell.detailTextLabel setTextColor:SL_GRAY_Hard];
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 2 && indexPath.row == 0) {
        //增加证件
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mAddBtn setFrame:CGRectMake(0, 0, 25, 25)];
        [mAddBtn setBackgroundImage:[UIImage imageNamed:@"cu_add"] forState:UIControlStateNormal];
        [mAddBtn addTarget:self action:@selector(onclickAddIdCard:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = mAddBtn;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.mSelectIndex = indexPath;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIActionSheet *mActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
        [mActionSheet showInView:self.view];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row != 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
        SLChangeDataVC *mTempVC = [[ SLChangeDataVC alloc]init];
        mTempVC.title = cell.textLabel.text;
        [self.navigationController pushViewController:mTempVC animated:YES];
        
        [mTempVC changeDataBlock:^(NSString *str) {
            
            cell.detailTextLabel.text = str;
            
            if (indexPath.row == 1) {
                //中文名
                _chinsesName = str;
//                LDLOG(@"中文名%@",str);
            }else if(indexPath.row == 2){
                //英文名字
                _englishName = str;
//                LDLOG(@"英文名%@",str);
                
            }else{
                _email = str;
//                LDLOG(@"邮箱%@",str);
                
            }
        }];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = @[@"男",@"女"];
            mPickerView.mLB_title.text = @"选择性别";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
        
        if (indexPath.row == 1) {
            SLDatePickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDatePickerView" owner:nil options:nil][0];
            mPickerView.delegate = (id)self;
            mPickerView.mLB_title.text = @"选择出生日期";
            mPickerView.mPicker.datePickerMode = UIDatePickerModeDate;
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
        
        if (indexPath.row == 2) {
            SLDataPickerView *mPickerView = [[NSBundle mainBundle]loadNibNamed:@"SLDataPickerView" owner:nil options:nil][0];
            mPickerView.delegate = self;
            mPickerView.mPickerDataSoure = self.mDeparts;;
            mPickerView.mLB_title.text = @"选择费用归属";
            [self.navigationController.view addSubview:mPickerView];
            [mPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.left.right.mas_equalTo(0);
            }];
        }
    }
   
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:{
            //相册
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                ShowMSG(@"您的设备不支持图库");
            }
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
            {
                ShowMSG(@"您的设备不支持相册");
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            mImagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypePhotoLibrary;
            mImagePickerVC.delegate = (id)self;
            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            break;}
            
        case 1:{
            if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                ShowMSG(@"您的设备不支持相机");
                return;
            }
            UIImagePickerController *mImagePickerVC = [[UIImagePickerController alloc]init];
            mImagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            mImagePickerVC.delegate = (id)self;
            mImagePickerVC.allowsEditing = YES;
            [self presentViewController:mImagePickerVC animated:YES completion:nil];
            //相机
            break;}
            
        default:
            break;
    }
}
#pragma mark UIImagePickerControllerDelegate
//成功获得相片还是视频后的回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //通过UIImagePickerControllerMediaType判断返回的是照片还是视频
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    //如果返回的type等于kUTTypeImage，代表返回的是照片,并且需要判断当前相机使用的sourcetype是拍照还是相册
    if (([type isEqualToString:(NSString*)kUTTypeImage]&&picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary) | UIImagePickerControllerSourceTypeSavedPhotosAlbum ) {
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        NSData *imageData = UIImagePNGRepresentation(edit);

        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:YES completion:^{
            SLCUHeadImageCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.mImg_head setImage:[UIImage imageWithData:imageData]];

            [self upHeadImage:imageData];
        }];
    }else{
        //获取图片裁剪的图
        UIImage* edit = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果是拍照的照片，则需要手动保存到本地，系统不会自动保存拍照成功后的照片
        UIImageWriteToSavedPhotosAlbum(edit, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        NSData *imageData = UIImagePNGRepresentation(edit);
        
        //模态方式退出uiimagepickercontroller
        [picker dismissViewControllerAnimated:YES completion:^{
            SLCUHeadImageCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.mImg_head setImage:[UIImage imageWithData:imageData]];
            [self upHeadImage:imageData];
            
        }];
    }
}

//取消照相机的回调
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //模态方式退出uiimagepickercontroller
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//保存照片成功后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    NSLog(@"saved..");
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
