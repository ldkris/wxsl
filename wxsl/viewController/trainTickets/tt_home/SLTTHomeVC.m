//
//  SLTTHomeVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/25.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLTTHomeVC.h"
#import "SLTTHomeCell.h"
#import "SLWebViewController.h"
#import "SLSelectCityVC.h"
#import "SLTTListVC.h"
#import "ZFChooseTimeViewController.h"
@interface SLTTHomeVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain) ImagePlayerView * mImagePlayerView;
@property(nonatomic,retain)UIButton *mbackBtn;
@property(nonatomic,retain)NSMutableDictionary *mFlightInfoDIC;
@end

@implementation SLTTHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.tableFooterView = [UIView new];
    self.mInfoTableView.estimatedRowHeight = 44.0f;
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.mImagePlayerView.imagePlayerViewDelegate = self;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    self.mImagePlayerView.imagePlayerViewDelegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(ImagePlayerView *)mImagePlayerView{
    if (_mImagePlayerView == nil) {
        _mImagePlayerView =[[ImagePlayerView alloc] init];
        _mImagePlayerView.scrollInterval = 3.0f;
        // adjust pageControl position
        [_mImagePlayerView setImagePlayerViewDelegate:self];
        _mImagePlayerView.pageControlPosition = ICPageControlPosition_BottomRight;
        _mImagePlayerView.hidePageControl = YES;
        _mImagePlayerView.endlessScroll = YES;
        
        [_mImagePlayerView.pageControl setCurrentPageIndicatorTintColor:SL_BULE];
        [_mImagePlayerView.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
        [_mImagePlayerView reloadData];
    }
    return _mImagePlayerView;
}
-(UIButton *)mbackBtn{
    if (_mbackBtn == nil) {
        _mbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mbackBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_mbackBtn addTarget:self action:@selector(onclickLifeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mbackBtn;
}
-(NSMutableDictionary *)mFlightInfoDIC{
    if (_mFlightInfoDIC == nil) {
        _mFlightInfoDIC = [NSMutableDictionary dictionary];
        [_mFlightInfoDIC setObject:@"重庆" forKey:@"fromCity"];
//        [_mFlightInfoDIC setObject:@"重庆" forKey:@"fromCityStr"];
        [_mFlightInfoDIC setObject:@"北京" forKey:@"toCity"];
//        [_mFlightInfoDIC setObject:@"北京" forKey:@"toCityStr"];
        [_mFlightInfoDIC setObject:@"1" forKey:@"tripType"];
        [_mFlightInfoDIC setObject:sl_userID forKey:@"userId"];
        [_mFlightInfoDIC setObject:@"2" forKey:@"trainType"];
        NSString *DateStr = [MyFounctions getCurrentDateWithDateFormatter:@"YYYY-MM-dd"];
        [_mFlightInfoDIC setObject:DateStr forKey:@"fromDate"];
    }
    return _mFlightInfoDIC;
}
#pragma mark event response
-(void)onclickLifeBtn:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 220.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    [self.mImagePlayerView addSubview:self.mbackBtn];
    [self.mbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.height.with.mas_equalTo(70);
    }];
    
    return self.mImagePlayerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"SLTTHomeCell";
    [tableView registerNib:[UINib nibWithNibName:@"SLTTHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    SLTTHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.delegate = self;
    [cell loadCityInfo:self.mSelectFormCityDIC toCity:self.mSelectToCityDIC];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
#pragma mark  SLFlightTrackCellDelegate 查询
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickLookUpBtn:(UIButton *)sender{
    SLTTListVC * mTempVC = [[SLTTListVC alloc]init];
    mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
    [self.navigationController pushViewController:mTempVC animated:YES];
    
}
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickChangeBtn:(UIButton *)sender{
    NSString *mTempStr;
    NSString *mTempStr1;
    
    NSString *mTempCodeStr;
    NSString *mTempCodeStr1;
    
    if (self.mFlightInfoDIC && [self.mFlightInfoDIC allKeys].count>0) {
        mTempStr = self.mFlightInfoDIC[@"fromCity"];
        mTempStr1 = self.mFlightInfoDIC[@"toCity"];
        mTempCodeStr = self.mFlightInfoDIC[@"fromCity"];
        mTempCodeStr1 = self.mFlightInfoDIC[@"toCity"];
        
        [cell.btn_toCity setTitle:mTempStr forState:UIControlStateNormal];
        [cell.btn_formCity setTitle:mTempStr1 forState:UIControlStateNormal];
        
//        [self.mFlightInfoDIC setObject:mTempStr1 forKey:@"fromCity"];
//        [self.mFlightInfoDIC setObject:mTempStr forKey:@"toCity"];
        
        [self.mFlightInfoDIC setObject:mTempCodeStr1 forKey:@"fromCity"];
        [self.mFlightInfoDIC setObject:mTempCodeStr forKey:@"toCity"];
    }
}
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclikFromCityBtn:(UIButton *)sender{
    SLSelectCityVC *mSeletVC = [[SLSelectCityVC alloc]init];
    mSeletVC.Type = SLSearchCityVC_Form;
    mSeletVC.title = @"选择出发城市";
    [self.navigationController pushViewController:mSeletVC animated:YES];
    [mSeletVC bakcInfoBlock:^(NSDictionary *cityInfo) {
        [cell.btn_formCity setTitle:cityInfo[@"city"] forState:UIControlStateNormal];
        
        if (cityInfo) {
            self.mSelectFormCityDIC = cityInfo;
        }
        
        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"city"] forKey:@"fromCity"];
//        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"city"] forKey:@"fromCityStr"];
    }];
    
    
}
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclicktoCityBtn:(UIButton *)sender{
    
    SLSelectCityVC *mSeletVC = [[SLSelectCityVC alloc]init];
    mSeletVC.title = @"选择目的地城市";
    mSeletVC.Type = SLSearchCityVC_TO;
    [self.navigationController pushViewController:mSeletVC animated:YES];
    
    [mSeletVC bakcInfoBlock:^(NSDictionary *cityInfo) {
        [cell.btn_toCity setTitle:cityInfo[@"city"] forState:UIControlStateNormal];
        
        if (cityInfo) {
            self.mSelectToCityDIC = cityInfo;
        }
        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"city"] forKey:@"toCity"];
//        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"city"] forKey:@"toCityStr"];
    }];
    
}
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickfromTimeBtn:(UIButton *)sender{
    
    __weak typeof(SLTTHomeCell) *weakCell = cell;
    
    ZFChooseTimeViewController * vc =[ZFChooseTimeViewController new];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    [vc backDate:^(NSArray *selectArray) {
        
        
        //        NSString *mSelectTime = [selectArray componentsJoinedByString:@""];
        // LDLOG(@"选择的时间 ===== %@",mSelectTime);
        [self.mFlightInfoDIC setObject:[NSString stringWithFormat:@"%@-%@-%@",selectArray[0],selectArray[1],selectArray[2]] forKey:@"fromDate"];
        [weakCell.btn_formTime setTitle:[NSString stringWithFormat:@"%@月%@日",selectArray[1],selectArray[2]] forState:UIControlStateNormal];
    }];
    
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return 3;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"trip_trainBG"]];
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    SLWebViewController *mTemp = [[SLWebViewController alloc]init];
    mTemp.urlStr = @"https://www.pgyer.com/ymVU";
    [self.navigationController pushViewController:mTemp animated:YES];
}

@end
