//
//  SLSelectCityVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectCityVC.h"
#import "SLSearchCityVC.h"
#import "SLSelectHeaderView.h"

#import "SLFlightTrackVC.h"
#define SL_Select_BGColor RGBACOLOR(238, 237, 244, 1)

@interface SLSelectCityVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,SLSelectHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mSearBar;

@property (nonatomic,retain)NSMutableArray *sectionTitlesArray; // 区头数组
@property (nonatomic,retain)NSMutableArray *dataArray;// cell数据源数组
@end

@implementation SLSelectCityVC{
    NSArray *_HotCitys;
    
    NSArray *_historyCity;
}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"allCity"];
    
    _historyCity = [[NSUserDefaults standardUserDefaults]objectForKey:@"CityHistory"];
    
    self.mInfoTableView.sectionIndexBackgroundColor= [UIColor clearColor];
    self.mInfoTableView.sectionIndexColor = [UIColor grayColor];
    
    [self.view setBackgroundColor:SL_Select_BGColor];
    NSDictionary *mParaDic;
    if ([SLSimpleInterest shareNetWork].TicketType == SLFlightTrackVC_TicketTrip_Air) {
        mParaDic=  @{@"userId":sl_userID,@"type":@"1"};
    }else{
        mParaDic=  @{@"userId":sl_userID,@"type":@"2"};
    }
    [HttpApi getCityList:mParaDic SuccessBlock:^(id responseBody) {
        
        NSArray *allCity = responseBody[@"cityInfos"];
        _HotCitys = responseBody[@"hotCitys"];
 
        [[NSUserDefaults standardUserDefaults]setObject:allCity forKey:@"allCity"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.dataArray addObjectsFromArray:allCity];
        
        NSMutableArray *allKeys = [NSMutableArray array];
        for (int i = 0; i<self.dataArray.count; i++) {
            NSDictionary *tempDic = self.dataArray[i];
            [allKeys addObject:tempDic[@"firstLetter"]];
        }
        
        [self.sectionTitlesArray addObjectsFromArray:[allKeys sortedArrayUsingSelector:@selector(compare:)]];
        
        [self.mInfoTableView reloadData];

        
    } FailureBlock:^(NSError *error) {
        
    }];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = YES;
    //[self.mSearBar resignFirstResponder];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // self.navigationController.navigationBar.hidden = NO;
    [self.mSearBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)bakcInfoBlock:(void (^)(NSDictionary *))block{
    self.BackInfo = block;
}
#pragma mark gtter
-(NSMutableArray *)sectionTitlesArray{
    if (_sectionTitlesArray == nil) {
        _sectionTitlesArray = [NSMutableArray array];
    }
    return _sectionTitlesArray;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y <= 44){
        [self.mInfoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-scrollView.contentOffset.y+108);
        }];
        
        [self.mSearBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-scrollView.contentOffset.y+108);
        }];
    }else{
        [self.mInfoTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-44);
        }];
        [self.mSearBar mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-108);
        }];
    }
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitlesArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section][@"citys"] count];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
   return  self.sectionTitlesArray;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return self.sectionTitlesArray[section];
//}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *mHeadView = [UIView new];
    if(section == 0){
        SLSelectHeaderView *mTempView= [[SLSelectHeaderView alloc]init];
        mTempView.mHotCitys = _HotCitys;
        mTempView.delegate = self;
        [mHeadView addSubview:mTempView];
        [mTempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-25);
        }];
    }
    [mHeadView setBackgroundColor:SL_Select_BGColor];
    UILabel *mTitleLabe = [[UILabel alloc]init];
    [mTitleLabe setFont:DEFAULT_FONT(15)];
    [mTitleLabe setText:self.sectionTitlesArray[section]];
    [mTitleLabe setTextColor:[UIColor grayColor]];
    [mHeadView addSubview:mTitleLabe];
    [mTitleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-3.5);
        make.left.mas_equalTo(13);
    }];
    return mHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        int i = _HotCitys.count%4;
        if(i == 0){
            if (_historyCity.count <=4) {
                return  _HotCitys.count/4 *40 +110;
            }else{
                return  _HotCitys.count/4 *40 +120;
            }
        }else{
            if (_historyCity.count <=4) {
                return  (_HotCitys.count/4+ 1) *40 +110;
            }else{
                return  (_HotCitys.count/4 + 1)/4 *40 +120;
            }
        }
    }
    return 25.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.section][@"citys"][indexPath.row][@"city"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *mSelectCityDic = self.dataArray[indexPath.section][@"citys"][indexPath.row];
    
    if (self.BackInfo && mSelectCityDic) {
        self.BackInfo(mSelectCityDic);
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
   
    SLSearchCityVC *mSearchVC = [[SLSearchCityVC alloc]init];
    mSearchVC.mALLDataArray = self.dataArray;
    mSearchVC.Type = self.Type;
    [self.navigationController pushViewController:mSearchVC animated:YES];
    
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

}
#pragma mark SLSelectHeaderViewDelegate
//选择热门城市 历史记录城市
-(void)SLSelectHeaderView:(SLSelectHeaderView *)view didSelectItemAtIndexPath:(NSIndexPath *)indexPath WithSelectDic:(NSDictionary *)info{
    
    if (self.BackInfo && info) {
        self.BackInfo(info);
    }

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
