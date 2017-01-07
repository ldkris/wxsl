//
//  SLSearchCityVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/30.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSearchCityVC.h"
#import "SLFlightTrackVC.h"
@interface SLSearchCityVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(strong,nonatomic)NSMutableArray *mSearchReslut;
@property(nonatomic,retain)UISearchBar *mSearchBar;

@end

@implementation SLSearchCityVC
#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = SL_GRAY;
    [self.navigationController.navigationBar addSubview:self.mSearchBar];
    self.mInfoTableView.tableFooterView = [UIView new];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mSearchBar removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
-(UISearchBar *)mSearchBar{
    if (_mSearchBar == nil) {
        _mSearchBar = [[UISearchBar alloc]init];
        [_mSearchBar setFrame:CGRectMake(40, 0, MainScreenFrame_Width - 66, 45)];
        [_mSearchBar setSearchBarStyle:UISearchBarStyleMinimal];
        _mSearchBar.placeholder = @"请输入城市名称或者拼音";
        _mSearchBar.delegate = self;
//        UITextField *searchField = [_mSearchBar valueForKey:@"_searchField"];
        // Change search bar text color
        //searchField.textColor = [UIColor blackColor];
        // Change the search bar placeholder text color
       // [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    return _mSearchBar;
}
-(NSMutableArray *)mSearchReslut{
    if (_mSearchReslut == nil) {
        _mSearchReslut = [NSMutableArray array];
    }
    return _mSearchReslut;
}

#pragma mark prvate
- (NSString *)Charactor:(NSString *)aString getFirstCharactor:(BOOL)isGetFirst
{
    if(aString == nil){
        return @"";
    }
    //转成了可变字符串
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
-(BOOL)IsChinese:(NSString *)str {
    if (str == nil) {
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
#pragma mark UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //[SVProgressHUD show];
    return YES;
}
-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   
    [self.mSearchReslut removeAllObjects];
    
    NSString *mPinYinStr = searchText;
    if ([self IsChinese:searchText]){
        mPinYinStr = [self Charactor:searchText getFirstCharactor:NO];
    }
   
    mPinYinStr = [mPinYinStr lowercaseString];
    
    if ([mPinYinStr isEqualToString:@"pek"]) {
        mPinYinStr = @"bjs";
    }
    
    for (int i = 0; i <self.mALLDataArray.count; i++) {
        NSDictionary *tempDic = self.mALLDataArray[i];
        NSArray *tempArray = tempDic[@"citys"];
        for (int j = 0;j<tempArray.count;j++) {
            NSDictionary *cityDIC = tempArray[j];
            
            NSString *cityCode = [cityDIC[@"cityCode"] lowercaseString];
            NSString *cityPYjc = [cityDIC[@"cityPyjc"] lowercaseString];
            NSString *cityPY = [cityDIC[@"cityPy"] lowercaseString];
            
            if ([cityPYjc containsString:mPinYinStr] || [cityPY containsString:mPinYinStr] || [cityCode containsString:mPinYinStr]) {
                [self.mSearchReslut addObject:cityDIC];
            }
        }
    }
    //刷新表格
    [self.mInfoTableView reloadData];
    //return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mSearchReslut.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    [cell.textLabel setText:self.mSearchReslut[indexPath.row][@"city"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *mSelectCityDic = self.mSearchReslut[indexPath.row];
    SLFlightTrackVC *mTempVC;
    for (id temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SLFlightTrackVC class]]) {
            mTempVC = temp;
            if (self.Type == SLSearchCityVC_Form) {
                //出发城市
                mTempVC.mSelectFormCityDIC = mSelectCityDic;
            }else{
                //目的地城市
                mTempVC.mSelectToCityDIC = mSelectCityDic;
            }
        }
    }
    
    
    NSArray *city = [[NSUserDefaults standardUserDefaults]objectForKey:@"CityHistory"];
    NSMutableArray *history = [NSMutableArray arrayWithArray:city];
    if (history == nil || [history count] == 0) {
        [history addObject: mSelectCityDic];
    }else{
        if ([history containsObject:mSelectCityDic]) {
            return;
        }
        if (history.count == 8) {
            [history replaceObjectAtIndex:0 withObject:mSelectCityDic];
        }else{
            [history addObject: mSelectCityDic];
        }
    }
    [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"CityHistory"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.navigationController popToViewController:mTempVC animated:YES];
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
