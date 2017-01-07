//
//  SLWiFiHomeVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/3.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWiFiHomeVC.h"
#import "WiFiHomeCell.h"
#import "SLWifiHomeHeaderView.h"
#import "SLWifiHomeFootView.h"

#import "SLWifiHelperVC.h"
#import "SLWifiListVC.h"
#import "SLWifiDetailVC.h"
@interface SLWiFiHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,SLWifiHomeHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollertionView;
@property(nonatomic,retain) SLWifiHomeHeaderView *mResusableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

@end

@implementation SLWiFiHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"出境WIFI";
    
    
    UIView *mBtnsView = [[UIView alloc]init];
    [mBtnsView setFrame:CGRectMake(0, 0, 100, 44)];
    
    UIButton *mSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mSearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [mSearchBtn setImage:[UIImage imageNamed:@"wifi_search"]  forState:UIControlStateNormal];
    [mSearchBtn addTarget:self action:@selector(onclickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtnsView addSubview:mSearchBtn];
    [mSearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    UIButton *mMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [mMoreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [mMoreBtn setImage:[UIImage imageNamed:@"wifi_more"]  forState:UIControlStateNormal];
    [mMoreBtn addTarget:self action:@selector(onclickMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtnsView addSubview:mMoreBtn];
    [mMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(60);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mBtnsView];
    
    [self getHotList];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.mResusableView deallocImageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark netWorking
-(void)getHotList{
    [[SLNetWorkingHelper shareNetWork] getHotWifiList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[SLHotWifiList class] fromJSONArray:responseBody[@"products"] error:&error];
//        LDLOG(@"%@",temp);
        
        self.mDataSoure = [NSMutableArray arrayWithArray:temp];
        [self.mInfoCollertionView reloadData];
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark response event
-(void)onclickSearchBtn:(UIButton *)sender{

}
-(void)onclickMoreBtn:(UIButton *)sender{
    
    [PopoverView showPopoverAtPoint:CGPointMake(MainScreenFrame_Width - 40, 55) inView:self.navigationController.view  withStringArray:@[@"我的订单",@"立即分享"] delegate:nil];
}
#pragma mark SLWifiHomeHeaderView
-(void)SLWifiHomeHeaderView:(SLWifiHomeHeaderView *)view onclickHelperBtn:(UIButton *)sender{
    SLWifiHelperVC *tempVC = [[SLWifiHelperVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];

}
-(void)SLWifiHomeHeaderView:(SLWifiHomeHeaderView *)view onclickHotBtn:(UIButton *)sender{

}

#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"WiFiHomeCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"WiFiHomeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"WiFiHomeCell"];
    
    WiFiHomeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell loadCellInfoWith:self.mDataSoure[indexPath.row]];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(MainScreenFrame_Width, 209);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(MainScreenFrame_Width, 50);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader){
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLWifiHomeHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"SLWifiHomeHeaderView"];
        
        _mResusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind             withReuseIdentifier:@"SLWifiHomeHeaderView" forIndexPath:indexPath];
        _mResusableView.delegate = self;
        [_mResusableView setImagePlayViews:nil];
        return _mResusableView;
    }else if (kind == UICollectionElementKindSectionFooter){
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLWifiHomeFootView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"SLWifiHomeFootView"];
        
        SLWifiHomeFootView *mFootResusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SLWifiHomeFootView" forIndexPath:indexPath];
         __typeof(self)weakSelf = self;
        [mFootResusableView SLWifiHomeFootViewOnclickMoreBtnBlock:^(UIButton *sender) {
           
            SLWifiListVC *tempVC = [[SLWifiListVC alloc]init];
            tempVC.title = @"wifi列表";
            [weakSelf.navigationController pushViewController:tempVC animated:YES];

        }];
        
        return mFootResusableView;
    }
    
    return nil;

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(MainScreenFrame_Width/3, 85);
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SLWifiDetailVC *temp = [[SLWifiDetailVC alloc]init];
    SLHotWifiList *model = self.mDataSoure[indexPath.row];
    temp.mCurrModel = model;
    [self.navigationController pushViewController:temp animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
