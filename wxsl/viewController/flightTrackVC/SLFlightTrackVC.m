//
//  SLFlightTrackVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLFlightTrackVC.h"
#import "SLCheckFlightVC.h"
#import "ZFChooseTimeViewController.h"
#import "SLWebViewController.h"
#import "SLSelectCityVC.h"

#import "SLFlightTrackCell.h"
#define NAVBAR_CHANGE_POINT 50
@interface SLFlightTrackVC ()<UITableViewDelegate,UITableViewDataSource,ImagePlayerViewDelegate,SLFlightTrackCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain) ImagePlayerView * mImagePlayerView;

@property(nonatomic,retain)NSMutableDictionary *mFlightInfoDIC;

@property(nonatomic,retain) UIView *mTempBtnView;

@property(nonatomic,retain) UIButton *mDCBtn;

@property(nonatomic,retain) UIButton *mWFBtn;

@property(nonatomic,retain)UIButton *mbackBtn;
@end

@implementation SLFlightTrackVC

#pragma mark life cycle
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
//     [self.navigationController.navigationBar lt_setBackgroundColor:[SL_BULE colorWithAlphaComponent:0]];
    self.mImagePlayerView.imagePlayerViewDelegate = self;
    
    if (self.mSelectFormCityDIC) {
        SLFlightTrackCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.btn_formCity setTitle:self.mSelectFormCityDIC[@"city"] forState:UIControlStateNormal];
        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"cityCode"] forKey:@"fromCity"];
        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"city"] forKey:@"fromCityStr"];
    }
    
    if (self.mSelectToCityDIC) {
        SLFlightTrackCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.btn_toCity setTitle:self.mSelectToCityDIC[@"city"] forState:UIControlStateNormal];
        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"cityCode"] forKey:@"toCity"];
        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"city"] forKey:@"toCityStr"];
    }
   
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
//    [self.navigationController.navigationBar lt_setBackgroundColor:[SL_BULE colorWithAlphaComponent:1]];
    self.mImagePlayerView.imagePlayerViewDelegate = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
 //   [self.mInfoTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(UIButton *)mbackBtn{
    if (_mbackBtn == nil) {
        _mbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mbackBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_mbackBtn addTarget:self action:@selector(onclickLifeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mbackBtn;
}

-(void)onclickLifeBtn:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
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
-(NSMutableDictionary *)mFlightInfoDIC{
    if (_mFlightInfoDIC == nil) {
        _mFlightInfoDIC = [NSMutableDictionary dictionary];
        [_mFlightInfoDIC setObject:@"CKG" forKey:@"fromCity"];
        [_mFlightInfoDIC setObject:@"重庆" forKey:@"fromCityStr"];
        [_mFlightInfoDIC setObject:@"PEK" forKey:@"toCity"];
        [_mFlightInfoDIC setObject:@"北京" forKey:@"toCityStr"];
        [_mFlightInfoDIC setObject:@"1" forKey:@"tripType"];
        [_mFlightInfoDIC setObject:sl_userID forKey:@"userId"];
        NSString *DateStr = [MyFounctions getCurrentDateWithDateFormatter:@"YYYY-MM-dd"];
        [_mFlightInfoDIC setObject:DateStr forKey:@"fromDate"];
    }
    return _mFlightInfoDIC;
}
-(UIView *)mTempBtnView{
    if (_mTempBtnView == nil) {
        _mTempBtnView = [[UIView alloc]init];
        [_mTempBtnView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
        [_mTempBtnView.layer setCornerRadius:3];
        [_mTempBtnView.layer setMasksToBounds:YES];
    }
    return _mTempBtnView;
}
-(UIButton *)mDCBtn{
    if (_mDCBtn == nil) {
        _mDCBtn= [UIButton buttonWithType:UIButtonTypeCustom];
       // [_mDCBtn setTitle:@"单程" forState:UIControlStateNormal];
        [_mDCBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mDCBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mDCBtn.titleLabel setFont:DEFAULT_FONT(15)];
        [_mDCBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [_mDCBtn setImage:[UIImage imageNamed:@"check_dc"] forState:UIControlStateNormal];
        [_mDCBtn addTarget:self action:@selector(onclickDCBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mDCBtn;
}
-(UIButton *)mWFBtn{
    if (_mWFBtn == nil) {
        _mWFBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mWFBtn setTitle:@"往返" forState:UIControlStateNormal];
        [_mWFBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mWFBtn.titleLabel setFont:DEFAULT_FONT(15)];
        [_mWFBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [_mWFBtn addTarget:self action:@selector(onclickWFBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mWFBtn;
}
#pragma mark event response
-(void)onclickWFBtn:(UIButton *)sender{
    SLFlightTrackCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self.mDCBtn setTitle:@"单程" forState:UIControlStateNormal];
    [self.mWFBtn setTitle:@"" forState:UIControlStateNormal];
    
    NSDate *date=[NSDate date];
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] + 24*3600)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:newDate];
    [cell.btn_backTime setTitle:destDateString forState:UIControlStateNormal];
    cell.btn_backTime.hidden = NO;
    
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateStr = [dateFormatter stringFromDate:newDate];
    [self.mFlightInfoDIC setObject:DateStr forKey:@"backDate"];
    
    [sender setImage:[UIImage imageNamed:@"check_wf"] forState:UIControlStateNormal];
    [self.mDCBtn setImage:nil forState:UIControlStateNormal];
    
    [self.mFlightInfoDIC setObject:@"2" forKey:@"tripType"];
}
-(void)onclickDCBtn:(UIButton *)sender{
    [self.mDCBtn setTitle:@"" forState:UIControlStateNormal];
    [self.mWFBtn setTitle:@"往返" forState:UIControlStateNormal];
    SLFlightTrackCell *cell = [self.mInfoTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.btn_backTime.hidden = YES;
    
    [sender setImage:[UIImage imageNamed:@"check_dc"] forState:UIControlStateNormal];
    [self.mWFBtn setImage:nil forState:UIControlStateNormal];
    
    [self.mFlightInfoDIC setObject:@"1" forKey:@"tripType"];
}
-(void)onclockGoBack:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  SLFlightTrackCellDelegate 查询
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickLookUpBtn:(UIButton *)sender{
    SLCheckFlightVC * mTempVC = [[SLCheckFlightVC alloc]init];
    mTempVC.mFlightInfoDIC = self.mFlightInfoDIC;
    [self.navigationController pushViewController:mTempVC animated:YES];

}
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickChangeBtn:(UIButton *)sender{
    NSString *mTempStr;
    NSString *mTempStr1;
    
    NSString *mTempCodeStr;
    NSString *mTempCodeStr1;
    
    if (self.mFlightInfoDIC && [self.mFlightInfoDIC allKeys].count>0) {
        mTempStr = self.mFlightInfoDIC[@"fromCityStr"];
        mTempStr1 = self.mFlightInfoDIC[@"toCityStr"];
        mTempCodeStr = self.mFlightInfoDIC[@"fromCity"];
        mTempCodeStr1 = self.mFlightInfoDIC[@"toCity"];
        
        [cell.btn_toCity setTitle:mTempStr forState:UIControlStateNormal];
        [cell.btn_formCity setTitle:mTempStr1 forState:UIControlStateNormal];
        
        [self.mFlightInfoDIC setObject:mTempStr1 forKey:@"fromCityStr"];
        [self.mFlightInfoDIC setObject:mTempStr forKey:@"toCityStr"];
        
        [self.mFlightInfoDIC setObject:mTempCodeStr1 forKey:@"fromCity"];
        [self.mFlightInfoDIC setObject:mTempCodeStr forKey:@"toCity"];
    }
}
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclikFromCityBtn:(UIButton *)sender{
    SLSelectCityVC *mSeletVC = [[SLSelectCityVC alloc]init];
    mSeletVC.Type = SLSearchCityVC_Form;
    mSeletVC.title = @"选择出发城市";
    [self.navigationController pushViewController:mSeletVC animated:YES];
    [mSeletVC bakcInfoBlock:^(NSDictionary *cityInfo) {
        [cell.btn_formCity setTitle:cityInfo[@"city"] forState:UIControlStateNormal];
        
        if (cityInfo) {
            self.mSelectFormCityDIC = cityInfo;
        }
        
        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"cityCode"] forKey:@"fromCity"];
        [self.mFlightInfoDIC setObject:self.mSelectFormCityDIC[@"city"] forKey:@"fromCityStr"];
    }];


}
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclicktoCityBtn:(UIButton *)sender{
    
    SLSelectCityVC *mSeletVC = [[SLSelectCityVC alloc]init];
    mSeletVC.title = @"选择目的地城市";
    mSeletVC.Type = SLSearchCityVC_TO;
    [self.navigationController pushViewController:mSeletVC animated:YES];
    
    [mSeletVC bakcInfoBlock:^(NSDictionary *cityInfo) {
        [cell.btn_toCity setTitle:cityInfo[@"city"] forState:UIControlStateNormal];
        
        if (cityInfo) {
            self.mSelectToCityDIC = cityInfo;
        }
        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"cityCode"] forKey:@"toCity"];
        [self.mFlightInfoDIC setObject:self.mSelectToCityDIC[@"city"] forKey:@"toCityStr"];
    }];

}
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickfromTimeBtn:(UIButton *)sender{
    
    __weak typeof(SLFlightTrackCell) *weakCell = cell;
    
    ZFChooseTimeViewController * vc =[ZFChooseTimeViewController new];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    [vc backDate:^(NSArray *selectArray) {
     
        
//        NSString *mSelectTime = [selectArray componentsJoinedByString:@""];
       // LDLOG(@"选择的时间 ===== %@",mSelectTime);
        [self.mFlightInfoDIC setObject:[NSString stringWithFormat:@"%@-%@-%@",selectArray[0],selectArray[1],selectArray[2]] forKey:@"fromDate"];
        [weakCell.btn_formTime setTitle:[NSString stringWithFormat:@"%@月%@日",selectArray[1],selectArray[2]] forState:UIControlStateNormal];
    }];

}
-(void)SLFlightTrackCell:(SLFlightTrackCell *)cell onclickToTimeBtn:(UIButton *)sender{
    
     __weak typeof(SLFlightTrackCell) *weakCell = cell;
    
    ZFChooseTimeViewController * vc =[ZFChooseTimeViewController new];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
    
    [vc backDate:^(NSArray *selectArray) {
//        NSString *mSelectTime = [selectArray componentsJoinedByString:@""];
     //   LDLOG(@"选择的时间 ===== %@",mSelectTime);
        [self.mFlightInfoDIC setObject:[NSString stringWithFormat:@"%@-%@-%@",selectArray[0],selectArray[1],selectArray[2]] forKey:@"backDate"];
        [weakCell.btn_backTime setTitle:[NSString stringWithFormat:@"%@月%@日",selectArray[1],selectArray[2]] forState:UIControlStateNormal];
    }];

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 240.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    [self.mImagePlayerView addSubview:self.mbackBtn];
    [self.mbackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.height.with.mas_equalTo(70);
    }];

    
    [self.mImagePlayerView addSubview:self.mTempBtnView];
    [self.mTempBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(39);
    }];
   
    [self.mTempBtnView addSubview:self.mDCBtn];
    [self.mDCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.mTempBtnView.mas_left).with.offset(-15);
        make.right.equalTo(self.mTempBtnView.mas_centerX).with.offset(15);
    }];

    [self.mTempBtnView addSubview:self.mWFBtn];
    [self.mWFBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.equalTo(self.mTempBtnView.mas_right).with.offset(10);
        make.left.equalTo(self.mTempBtnView.mas_centerX).with.offset(-18);
    }];

    return self.mImagePlayerView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"SLFlightTrackCell";
    [tableView registerNib:[UINib nibWithNibName:@"SLFlightTrackCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIndentifier];
    SLFlightTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    cell.btn_backTime.hidden = YES;
    [cell loadCityInfo:self.mSelectFormCityDIC toCity:self.mSelectToCityDIC];
    cell.delegate = self;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  
}
#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return 3;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    
    if ([SLSimpleInterest shareNetWork].TicketType == SLFlightTrackVC_TicketTrip_Air) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"trip_flightBG"]];
    }else{
         [imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"trip_trainBG"]];
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    SLWebViewController *mTemp = [[SLWebViewController alloc]init];
    mTemp.urlStr = @"https://www.pgyer.com/ymVU";
    [self.navigationController pushViewController:mTemp animated:YES];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    UIColor * color = SL_BULE;
//    CGFloat offsetY = scrollView.contentOffset.y;
//    if (offsetY > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//    } else {
//        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
//    }
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
