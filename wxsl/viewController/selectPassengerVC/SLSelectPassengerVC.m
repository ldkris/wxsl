//
//  SLSelectPassengerVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectPassengerVC.h"
#import "SLAddTripPopleVC.h"
#import "SLSelectpolicVC.h"

#import "SLSelectPopleCell.h"
@interface SLSelectPassengerVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mBtn_cylxr;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_yg;
@property (weak, nonatomic) IBOutlet UIView *mMarkChangeType;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableDictionary *mDataSoureDic;

@property (weak, nonatomic) IBOutlet UIButton *btn_ADD;
@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组

//已选择的乘客
@property(nonatomic,retain)NSMutableArray *mSelectedPassengers;
@end

@implementation SLSelectPassengerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SL_GRAY;
    self.title = @"请选择乘客";
    [self.mMarkChangeType setFrame:CGRectMake(65, 99, 100, 1)];
    
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self getEmployeeList];
    
     self.PassengerType = yuangong ;
    
    UIBarButtonItem *mRightBarBtn = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onclickRightBarBtn:)];
    self.navigationItem.rightBarButtonItem = mRightBarBtn;
    
    self.btn_ADD.hidden = YES;
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    [self.mMarkChangeType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(55);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mSelectedPassengers{
    if(_mSelectedPassengers == nil){
        _mSelectedPassengers = [NSMutableArray array];
    }
    return _mSelectedPassengers;
}
-(NSMutableDictionary *)mDataSoureDic{
    if (_mDataSoureDic == nil) {
        _mDataSoureDic = [NSMutableDictionary dictionary];
    }
    return _mDataSoureDic;
}
-(NSMutableArray *)sectionTitlesArray{
    if (_sectionTitlesArray == nil) {
        _sectionTitlesArray = [NSMutableArray array];
    }
    return _sectionTitlesArray;
}
#pragma mark NetWorking

-(void)getTravelPeopleList{
    [SVProgressHUD show];
    [HttpApi getTravelPeopleList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLPassengerModel class] fromJSONArray:responseBody[@"peoples"] error:&error];
        
        [self.sectionTitlesArray removeAllObjects];
        
        NSMutableDictionary *PYarray = [NSMutableDictionary dictionary];
        
        NSMutableArray *mAllModels = [NSMutableArray arrayWithArray:temp];
        NSMutableArray *mSameArray =  [NSMutableArray array];
        
        for (SLPassengerModel *tempModel in mAllModels) {
            if (tempModel.mName.length>0 && tempModel.mName) {
                NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
                NSMutableArray *mAllModels1 = [NSMutableArray arrayWithArray:temp];
                [mAllModels1 removeObjectAtIndex:[mAllModels indexOfObjectIdenticalTo:tempModel]];
                
                for (SLPassengerModel *tempModel1 in mAllModels1) {
                    NSString *tempFirst1 = [self Charactor:tempModel1.mName getFirstCharactor:YES];
                    if ([tempFirst1 isEqualToString:tempFirst]) {
                        [mSameArray addObject:tempModel];
                        [PYarray setObject:mSameArray forKey:tempFirst];
                        break;
                    }
                    
                }
            }
           
        }
        
        if (mSameArray.count == 0) {
            for (SLPassengerModel *tempModel in mAllModels) {
                NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
                [PYarray setObject:@[tempModel] forKey:tempFirst];
            }
        }else{
            for (SLPassengerModel *tempModel in mAllModels) {
                NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
                for (SLPassengerModel *tempModel1 in mSameArray) {
                    NSString *tempFirst1 = [self Charactor:tempModel1.mName getFirstCharactor:YES];
                    if (![tempFirst1 isEqual:tempFirst]) {
                        [PYarray setObject:@[tempModel] forKey:tempFirst];
                    }
                }
                
            }
        }
        
        self.mDataSoureDic = PYarray;
        NSArray * allKeys = [PYarray allKeys];
        [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];

        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
-(void)getEmployeeList{
     [SVProgressHUD show];
    [HttpApi getEmployeeList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        [SVProgressHUD dismiss];
        [self.sectionTitlesArray removeAllObjects];
        
        NSArray *tempEmployees = responseBody[@"employees"];
        
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLPassengerModel class] fromJSONArray:tempEmployees error:&error];
        
        
        NSMutableDictionary *PYarray = [NSMutableDictionary dictionary];
        
        NSMutableArray *mAllModels = [NSMutableArray arrayWithArray:temp];
        NSMutableArray *mSameArray =  [NSMutableArray array];
        
        for (SLPassengerModel *tempModel in mAllModels) {
            NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
            NSMutableArray *mAllModels1 = [NSMutableArray arrayWithArray:temp];
            [mAllModels1 removeObjectAtIndex:[mAllModels indexOfObjectIdenticalTo:tempModel]];
            
            for (SLPassengerModel *tempModel1 in mAllModels1) {
                NSString *tempFirst1 = [self Charactor:tempModel1.mName getFirstCharactor:YES];
                if ([tempFirst1 isEqualToString:tempFirst]) {
                    [mSameArray addObject:tempModel];
                    [PYarray setObject:mSameArray forKey:tempFirst];
                    break;
                }
                
            }
        }
        
        if (mSameArray.count == 0) {
            for (SLPassengerModel *tempModel in mAllModels) {
                NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
                [PYarray setObject:@[tempModel] forKey:tempFirst];
            }
        }else{
            for (SLPassengerModel *tempModel in mAllModels) {
                NSString *tempFirst = [self Charactor:tempModel.mName getFirstCharactor:YES];
                for (SLPassengerModel *tempModel1 in mSameArray) {
                    NSString *tempFirst1 = [self Charactor:tempModel1.mName getFirstCharactor:YES];
                    if (![tempFirst1 isEqual:tempFirst]) {
                        [PYarray setObject:@[tempModel] forKey:tempFirst];
                    }
                }
                
            }
        }
        
        self.mDataSoureDic = PYarray;
        NSArray * allKeys = [PYarray allKeys];
        [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
        
        [self.mInfoTableView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];

}
#pragma mark privtae
- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    //转成了可变字符串
    if(aString == nil){
        return @"";
    }
    
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    //转化为大写拼音
    if(isGetFirst)
    {
        //获取并返回首字母
        return [pinYin substringToIndex:1];
    }
    else
    {
        return pinYin;
    }
}
#pragma mark event response
-(void)onclickRightBarBtn:(UIButton *)sender{
  //  LDLOG(@"确定 ====== ");
    
    if (self.mSelectedPassengers.count == 0) {
        ShowMSG(@"请至少选择一名乘客");
        return;
    }
    
    SLSelectpolicVC *tempVC = [[SLSelectpolicVC alloc]init];
    tempVC.mSelectedPassengers = self.mSelectedPassengers;
    tempVC.mFlightInfoDIC = self.mFlightInfoDIC;
    tempVC.mSelectRBDModel = self.mSelectRBDModel;
    tempVC.fightMode = self.fightMode;
    tempVC.mBackFlightInfoDIC = self.mBackFlightInfoDIC;
    tempVC.mQSelectRBDModel = self.mQSelectRBDModel;
    tempVC.QTicketType = self.QTicketType;
    tempVC.QReasonType = self.QReasonType;
    tempVC.PassengerType = self.PassengerType;
    [self.navigationController pushViewController:tempVC animated:YES];
}
- (IBAction)onclickAddBtn:(id)sender {
    SLAddTripPopleVC *mTempVC =[[SLAddTripPopleVC alloc]init];
    [self.navigationController pushViewController:mTempVC animated:YES];
}
- (IBAction)onclickYgBtn:(UIButton *)sender {
    
    self.btn_ADD.hidden = YES;
    [self.mSelectedPassengers removeAllObjects];
    [self getEmployeeList];
    self.PassengerType = yuangong ;
    
    [self.mMarkChangeType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(55);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
}
- (IBAction)onclickCYLXRBtn:(UIButton *)sender {
    [self.mSelectedPassengers removeAllObjects];
    [self getTravelPeopleList];
    self.PassengerType = common ;
    self.btn_ADD.hidden = NO;
    [self.mMarkChangeType mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-55);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(1);
    }];
}
#pragma  mark UITableViewDataSource && UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitlesArray.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitlesArray[section];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *temp = self.mDataSoureDic[self.sectionTitlesArray[section]];
    return [temp count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"SLSelectPopleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLSelectPopleCell"];
    SLSelectPopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SLSelectPopleCell"];
    cell.isSelect = YES;
    [cell loadCellInfoWithModel:self.mDataSoureDic[self.sectionTitlesArray[indexPath.section]][indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SLSelectPopleCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    NSArray *temp = self.mDataSoureDic[self.sectionTitlesArray[indexPath.section]];
    SLPassengerModel *tempModel = temp[indexPath.row];
    if ([self.mSelectedPassengers containsObject:tempModel]) {
        [cell.mBtn_mark setImage:[UIImage imageNamed:@"hotel_icon_fan"]];
        [self.mSelectedPassengers removeObject:tempModel];
    }else{
        [cell.mBtn_mark setImage:[UIImage imageNamed:@"hotel_icon_fan_select"]];
        [self.mSelectedPassengers addObject:tempModel];
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
