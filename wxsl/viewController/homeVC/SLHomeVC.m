//
//  SLHomeVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/6.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLHomeVC.h"
#import "SLHomeCollectionCell.h"
#import "SLHomeTwoCollectionViewCell.h"
#import "SLHomeThreeCollectionViewCell.h"
#import "SLHomeFourCollectionViewCell.h"

#import "SLHomeReusableView.h"
#import "SLLoginVC.h"
#import "SLFlightTrackVC.h"
#import "SLUserViewController.h"
#import "SLSelectCityVC.h"
#import "ZFChooseTimeViewController.h"
#import "SLNoticeViewController.h"
#import "SLWebViewController.h"
#import "SLWiFiHomeVC.h"
#import "SLTTHomeVC.h"
@interface SLHomeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SLHomeTwoCollectionViewCellDelegate,SLHomeThreeCollectionViewCellDelegate,SLHomeFourCollectionViewCellDelegate,SLHomeReusableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;

@property(nonatomic,retain)  SLHomeReusableView *mResusableView;
@end

@implementation SLHomeVC{


}

#pragma mark life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mInfoCollectionView setBackgroundColor:[UIColor clearColor]];
    self.mInfoCollectionView.alwaysBounceVertical = YES;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    self.mInfoCollectionView.delegate = self;
    self.mInfoCollectionView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    self.navigationItem.title = [NSString stringWithFormat:@"欢迎您,%@", [MyFounctions getUserInfo][@"name"]];
    
    if (![MyFounctions getUserInfo]) {
        SLLoginVC *mLoginVC = [[SLLoginVC alloc]initWithNibName:@"SLLoginVC" bundle:[NSBundle mainBundle]];
        UINavigationController *mNav = [[UINavigationController alloc]initWithRootViewController:mLoginVC];
        [self presentViewController:mNav animated:NO completion:nil];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    if(sl_userID){
    
        [HttpApi getEnterpriseNoticeList:@{@"userId":sl_userID} SuccessBlock:^(id responseBody) {
            //  LDLOG(@"公告 ===== %@",responseBody);
            NSArray  *notices = responseBody[@"notices"];
            if (notices && notices.count>0) {
                [self.mResusableView loadNoticeInfo:notices[0]];
            }
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SLHomeReusableViewDelegate
-(void)SLHomeReusableView:(SLHomeReusableView *)view changeRasonBtn:(UIButton *)btn{
    [SLSimpleInterest shareNetWork].mTrType = btn.tag;
  
}
-(void)SLHomeReusableView:(SLHomeReusableView *)view onclickNoticeBtn:(UIButton *)btn{
    SLNoticeViewController *tempvc  = [[SLNoticeViewController alloc]init];
    [self.navigationController pushViewController:tempvc animated:YES];
}
-(void)SLHomeReusableView:(SLHomeReusableView *)view imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index{
    SLWebViewController *mTemp = [[SLWebViewController alloc]init];
    mTemp.urlStr = @"https://www.pgyer.com/ymVU";
    [self.navigationController pushViewController:mTemp animated:YES];
}
#pragma mark SLHomeTwoCollectionViewCellDelegate
//WIFI
-(void)SLHomeTwoCollectionViewCell:(SLHomeTwoCollectionViewCell *)cell onclickWifiBtn:(UIButton *)sender{
    SLWiFiHomeVC *tmpeVC = [[SLWiFiHomeVC alloc]init];
    tmpeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tmpeVC animated:YES];
}
//用车
-(void)SLHomeTwoCollectionViewCell:(SLHomeTwoCollectionViewCell *)cell onclickYCbtn:(UIButton *)sender{
}
#pragma mark SLHomeThreeCollectionViewCellDelegate
//酒店
-(void)SLHomeThreeCollectionViewCellDelegate:(SLHomeThreeCollectionViewCell *)cell onclickJDBtn:(UIButton *)sender{
}
//签证
-(void)SLHomeThreeCollectionViewCellDelegate:(SLHomeThreeCollectionViewCell *)cell onclickQZBtn:(UIButton *)sender{
}
#pragma mark SLHomeFourCollectionViewCellDelegate
//火车票
-(void)SLHomeFourCollectionViewCellDelegate:(SLHomeFourCollectionViewCell *)cell onclickHCPBtn:(UIButton *)sender{
    [SLSimpleInterest shareNetWork].TicketType = SLFlightTrackVC_TicketTrip_train;
    SLTTHomeVC *tempVC = [[SLTTHomeVC alloc]init];
    [self.navigationController pushViewController:tempVC animated:YES];
}
//汽车票
-(void)SLHomeFourCollectionViewCellDelegate:(SLHomeFourCollectionViewCell *)cell onclickQCPBtn:(UIButton *)sender{
}
#pragma mark UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 2 ){
        static NSString * SLCellIdentifier = @"SLHomeTwoCollectionViewCell";
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLHomeTwoCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SLCellIdentifier];
        
        SLHomeTwoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
        
        [cell.btn_wifi mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(70);
        }];
        
        cell.delegate = self;
        
        return cell;
    }
    
    if(indexPath.row == 3 ){
        static NSString * SLCellIdentifier = @"SLHomeThreeCollectionViewCell";
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLHomeThreeCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SLCellIdentifier];
        
        SLHomeThreeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
          cell.delegate = self;
        
        return cell;
    }
    
    if(indexPath.row == 4 ){
        static NSString * SLCellIdentifier = @"SLHomeFourCollectionViewCell";
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLHomeFourCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SLCellIdentifier];
        
        SLHomeFourCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
          cell.delegate = self;
        
        return cell;
    }
    
    
    static NSString * CellIdentifier = @"GradientCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"SLHomeCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"GradientCell"];
    
    SLHomeCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *mTempArray = @[@"home_airlineTicket",@"home_airlineTicketguoji",@"home_railwayTicket",@"home_busTicket",@"home_wifi",@"home_user",@"",];
    [cell.mConentImageView setImage:[UIImage imageNamed:mTempArray[indexPath.row]]];
//    [cell.mConentImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
   // LDLOG(@"aaaa === %f",MainScreenFrame_Width);
    if (MainScreenFrame_Width >= 414) {
        return CGSizeMake(MainScreenFrame_Width, 263);
    }else{
        return CGSizeMake(MainScreenFrame_Width, 203);
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader){
        
        [collectionView registerNib:[UINib nibWithNibName:@"SLHomeReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"SLHomeReusableView"];
        
        if (_mResusableView == nil) {
            _mResusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SLHomeReusableView" forIndexPath:indexPath];
        }
        _mResusableView.delegate = self;
        [_mResusableView setImagePlayViews:@[@"home_ad",@"home_ad_two",@"home_ad"]];
        return _mResusableView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = MainScreenFrame_Width /2 - 7;
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        return CGSizeMake(CellW, 90);
    }
    
    if (indexPath.row == 4 || indexPath.row == 5) {
        return CGSizeMake(CellW, 125);
    }
    
    if (indexPath.row == 6) {
       return CGSizeMake(5, 5);
    }

    
    return CGSizeMake(CellW, 165);
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //机票
        SLFlightTrackVC *mFlightTrackVC = [[SLFlightTrackVC alloc]init];
        [SLSimpleInterest shareNetWork].TicketType = SLFlightTrackVC_TicketTrip_Air;
        [self.navigationController pushViewController:mFlightTrackVC animated:YES];
        return;
    }
    
    if (indexPath.row == 5) {
        //会议
//         SLUserViewController*mFlightTrackVC = [[SLUserViewController alloc]init];
//        [self.navigationController pushViewController:mFlightTrackVC animated:YES];
//        return;
    }
    

    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.mScrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(-scrollView.contentOffset.y);
//    }];
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
