//
//  SLSelectHeaderView.m
//  wxsl
//
//  Created by 刘冬 on 16/6/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSelectHeaderView.h"
#import "SLSelectCollectionViewCell.h"
#import "SLSelectCollectionReusableView.h"
@interface SLSelectHeaderView()<UICollectionViewDelegate>
@property(nonatomic,retain)UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)NSArray *mCityArray;
@end

@implementation SLSelectHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self addSubview:self.mInfoCollectionView];
    
}
-(void)layoutSubviews{
    self.backgroundColor  = [UIColor clearColor];
    self.mInfoCollectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.mInfoCollectionView];
    [self.mInfoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}
#pragma mark getter
-(NSArray *)mCityArray{
    if (_mCityArray == nil) {
        NSMutableArray *history = [[NSUserDefaults standardUserDefaults]objectForKey:@"CityHistory"];
        if(history  == nil){
            history = [NSMutableArray array];
        }
        
        _mCityArray = @[history,self.mHotCitys];
    }
    return _mCityArray;
}
-(NSArray *)mHotCitys{
    if (_mHotCitys == nil) {
        _mHotCitys = [NSArray array];
    }
    return _mHotCitys;
}
-(UICollectionView *)mInfoCollectionView{
    if (_mInfoCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setSectionInset:UIEdgeInsetsMake(10,10,0,15)];
        [layout setMinimumInteritemSpacing:0]; // 横向间距
        [layout setMinimumLineSpacing:5]; // 只是单行横向也要设置
        _mInfoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _mInfoCollectionView.delegate = self;
        _mInfoCollectionView.dataSource = (id)self;
        _mInfoCollectionView.showsHorizontalScrollIndicator = NO;
        _mInfoCollectionView.showsVerticalScrollIndicator = NO;
        _mInfoCollectionView.alwaysBounceVertical = NO;
        _mInfoCollectionView.scrollEnabled = NO;
    }
    return _mInfoCollectionView;
}

#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = MainScreenFrame_Width /4 - 20;
    
    return CGSizeMake(CellW, 35);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.mCityArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return [self.mCityArray[section] count];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(MainScreenFrame_Width, 20);
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader){
        [collectionView registerNib:[UINib nibWithNibName:@"SLSelectCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:kind withReuseIdentifier:@"SLSelectCollectionReusableView"];
        
        SLSelectCollectionReusableView *mResusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SLSelectCollectionReusableView" forIndexPath:indexPath];
        
        [mResusableView.mlb_title setText:@[@"历史记录",@"热门城市"][indexPath.section]];
        //[mResusableView setADImageViews:@[@"home_ad",@"home_ad",@"home_ad"]];
        return mResusableView;
    }
    return nil;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"SLSelectCollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"SLSelectCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SLSelectCollectionViewCell"];
    
    SLSelectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
   cell.mLb_title.text = self.mCityArray[indexPath.section][indexPath.row][@"city"];    
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *info = self.mCityArray[indexPath.section][indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLSelectHeaderView:didSelectItemAtIndexPath:WithSelectDic:)] && info) {
        
        SLSelectCollectionViewCell * cell = (SLSelectCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell.mLb_title setTextColor:[UIColor whiteColor]];
        [cell setBackgroundColor:SL_BULE];
    
        [_delegate SLSelectHeaderView:self didSelectItemAtIndexPath:indexPath WithSelectDic:info];
    }
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
