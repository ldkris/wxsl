//
//  ZFChooseTimeViewController.m
//  slyjg
//
//  Created by 王小腊 on 16/3/9.
//  Copyright © 2016年 王小腊. All rights reserved.
//



#import "ZFChooseTimeViewController.h"
#import "ZFChooseTimeCollectionViewCell.h"
#import "ZFTimerCollectionReusableView.h"
#import "SVProgressHUD.h"

static NSString * const reuseIdentifier = @"ChooseTimeCell";
static NSString * const headerIdentifier = @"headerIdentifier";



@interface ZFChooseTimeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDateComponents *comps;
@property (nonatomic, strong) NSCalendar *calender;
@property (nonatomic, strong) NSArray * weekdays;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, strong) NSArray *OutDateArray;
//@property (nonatomic, strong) NSArray *selectedData;

@property(nonatomic,retain)UIView *mNaviView;
@property(nonatomic,retain)UILabel *mTitleLable;
@property(nonatomic,retain)UIButton *mBackBtn;
@end

@implementation ZFChooseTimeViewController

@synthesize date = newDate;
@synthesize collectionView = datecollectionView;

#pragma mark life cycle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.mNaviView];
    [self.mNaviView addSubview:self.mTitleLable];
    [self.mNaviView addSubview:self.mBackBtn];
    
    self.view.backgroundColor = SL_GRAY;
    newDate =[NSDate date];
    
    self.title = @"日期选择";
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mNaviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    [self.mTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(8);
    }];
    [self.mBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(11);
        make.width.height.mas_equalTo(50);
    }];
    
    
    float cellw =kDeviceWidth/7;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(cellw, cellw*4/3)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    [flowLayout setHeaderReferenceSize:CGSizeMake(kDeviceWidth, 50)];
    [flowLayout setMinimumInteritemSpacing:0]; //设置 y 间距
    [flowLayout setMinimumLineSpacing:0]; //设置 x 间距
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 10, 0);//设置其边界
    //UIEdgeInsetsMake(设置上下cell的上间距,设置cell左距离,设置上下cell的下间距,设置cell右距离);
    
    //其布局很有意思，当你的cell设置大小后，一行多少个cell，由cell的宽度决定
    datecollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight) collectionViewLayout:flowLayout];
    datecollectionView.dataSource = self;
    datecollectionView.delegate = self;
    datecollectionView.backgroundColor = [UIColor whiteColor];
    
    //    注册cell
    [datecollectionView registerNib:[UINib nibWithNibName:@"ZFTimerCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [datecollectionView registerNib:[UINib nibWithNibName:@"ZFChooseTimeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:datecollectionView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark getter
-(UIButton *)mBackBtn{
    if (_mBackBtn == nil) {
        _mBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // [_mBackBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_mBackBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [_mBackBtn.titleLabel setFont:DEFAULT_FONT(15)];
        [_mBackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [_mBackBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_mBackBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mBackBtn;
}
-(UILabel *)mTitleLable{
    if (_mTitleLable == nil) {
        _mTitleLable = [[UILabel alloc]init];
        [_mTitleLable setText:@"日期选择"];
        [_mTitleLable setFont:DEFAULT_BOLD_FONT(18)];
        [_mTitleLable setTextColor:[UIColor whiteColor]];
    }
    return _mTitleLable;
}
-(UIView *)mNaviView{
    if (_mNaviView == nil) {
        _mNaviView = [[UIView alloc]init];
        [_mNaviView setBackgroundColor:SL_BULE];
    }
    return _mNaviView;
}
- (NSTimeZone*)timeZone
{
    
    if (_timeZone == nil) {
        [UIColor blueColor];
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}


- (NSArray*)weekdays
{
    
    if (_weekdays == nil) {
        
        _weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
        
    }
    return _weekdays;
}
- (NSCalendar*)calender
{
    
    if (_calender == nil) {
        
        _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    
    return _calender;
}
- (NSDateComponents*)comps
{
    
    if (_comps == nil) {
        
        _comps = [[NSDateComponents alloc] init];
        
    }
    
    return _comps;
}
- (NSDateFormatter*)formatter
{
    
    if (_formatter == nil) {
        
        _formatter =[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return _formatter;
}


#pragma mark private
/**
 *  根据当前月获取有多少天
 *
 *  @param dayDate 但前时间
 *
 *  @return 天数
 */
- (NSInteger)getNumberOfDays:(NSDate *)dayDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:dayDate];
    
    return range.length;
    
}
/**
 *  根据前几月获取时间
 *
 *  @param date  当前时间
 *  @param month 第几个月 正数为前  负数为后
 *
 *  @return 获得时间
 */
- (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month

{
    [self.comps setMonth:month];
    
    NSDate *mDate = [self.calender dateByAddingComponents:self.comps toDate:date options:0];
    return mDate;
    
}

/**
 *  根据时间获取周几
 *
 *  @param inputDate 输入参数是NSDate，
 *
 *  @return 输出结果是星期几的字符串。
 */
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    [self.calender setTimeZone: self.timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [self.calender components:calendarUnit fromDate:inputDate];
    
    return [self.weekdays objectAtIndex:theComponents.weekday];
    
}
/**
 *  获取第N个月的时间
 *
 *  @param currentDate 当前时间
 *  @param index 第几个月 正数为前  负数为后
 *
 *  @return @“2016年3月”
 */
- (NSArray*)timeString:(NSDate*)currentDate many:(NSInteger)index;
{
    
    NSDate *getDate =[self getPriousorLaterDateFromDate:currentDate withMonth:index];
    
    NSString  *str =  [self.formatter stringFromDate:getDate];
    
    return [str componentsSeparatedByString:@"-"];
}

/**
 *  根据时间获取第一天周几
 *
 *  @param dateStr 时间
 *
 *  @return 周几
 */
- (NSString*)getMonthBeginAndEndWith:(NSDate *)dateStr{
    
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:dateStr];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    
    return   [self weekdayStringFromDate:beginDate];
}

#pragma mark --- <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size={kDeviceWidth,50};
    return size;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSDate *dateList = [self getPriousorLaterDateFromDate:newDate withMonth:section];
    
    NSString *timerNsstring = [self getMonthBeginAndEndWith:dateList];
    NSInteger p_0 = [timerNsstring integerValue];
    NSInteger p_1 = [self getNumberOfDays:dateList] + p_0;
    
    return p_1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZFChooseTimeCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDate*dateList = [self getPriousorLaterDateFromDate:newDate withMonth:indexPath.section];
    
    NSArray*array = [self timeString:newDate many:indexPath.section];
    
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    
    NSString *str;

    if (p<10)
    {
        
        str = p > 0 ? [NSString stringWithFormat:@"0%ld",(long)p]:[NSString stringWithFormat:@"-0%ld",(long)-p];

    }
    else
    {
        
        str = [NSString stringWithFormat:@"%ld",(long)p];
    }
    
    
    NSArray *list = @[array[0], array[1], str];
    
    [cell updateDay:list outDate:self.OutDateArray selected:0 currentDate:[self timeString:newDate many:0]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDate*dateList = [self getPriousorLaterDateFromDate:newDate withMonth:indexPath.section];
    NSInteger p = indexPath.row -[self getMonthBeginAndEndWith:dateList].intValue+1;
    NSArray *array = [self timeString:newDate many:indexPath.section];
    
    NSString *str = p < 10 ? [NSString stringWithFormat:@"0%ld",(long)p]:[NSString stringWithFormat:@"%ld",(long)p];
    
    if (self.OutDateArray.count == 0)
    {
        /**
         *  选择出团
         */
        self.OutDateArray =@[array[0],array[1],str];
        [self.collectionView reloadData];;
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            if (_OutDateArray.count > 0) {
                
                if (self.selectedDate) {
                    
                    self.selectedDate(_OutDateArray);
                }
                
            }
            
        }];
        
    }
    else
    {
        /**
         *  选择反团
         */
//        NSArray *listArray = @[ array[0], array[1], str];
//        NSInteger p_0 = [listArray componentsJoinedByString:@""].intValue;
//        NSInteger p_1 = [_OutDateArray componentsJoinedByString:@""].intValue;
//        
//        if (p_0 < p_1)
//        {
//            
//            [SVProgressHUD showErrorWithStatus:@"选择返团时间不能小于出团时间!"];
//            return;
//            
//        }
//        else
//        {
//            
//            self.selectedData = listArray;
//            [self.collectionView reloadData];
//            
//        }
        
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        ZFTimerCollectionReusableView * headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        
        [headerCell updateTimer:[self timeString:newDate many:indexPath.section]];
        
        return headerCell;
    }
    return nil;
}


#pragma mark --- publick
- (void)backDate:(chooseDate)listDate;
{
    
    self.selectedDate = listDate;
    
}

#pragma mark ---
#pragma mark --- 提示框
- (void)showAlertController
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"是否选择返团时间?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        //self.selectedData =self.OutDateArray;
        [self.collectionView reloadData];
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
    }];
    
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

/**
 *  返回时间
 */
- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com