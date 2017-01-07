//
//  SLUserVCTableViewCell.m
//  wxsl
//
//  Created by 刘冬 on 16/6/28.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLUserVCTableViewCell.h"
#import "SLUserVCCollectionViewCell.h"
@interface SLUserVCTableViewCell()
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property(nonatomic,retain)NSArray *mDataSoure;
@property(nonatomic,retain)NSArray *mImageDataSoure;
@end

@implementation SLUserVCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.mInfoCollectionView setBackgroundColor:[UIColor clearColor]];
    [self.mInfoCollectionView setDelegate:(id)self];
    [self.mInfoCollectionView setDataSource:(id)self];
    [self.mInfoCollectionView setScrollEnabled:NO];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"机票订单",@"酒店订单",@"用车订单",@"火车票订单",@"汽车票订单",@"签证订单",@"会议订单",@"WIFI订单"];
    }
    return _mDataSoure;
}
-(NSArray *)mImageDataSoure{
    if (_mImageDataSoure == nil) {
        _mImageDataSoure = @[@"order_jp",@"order_jd",@"order_yc",@"order_hc",@"order_qc",@"order_qz",@"order_hy",@"order_WIFI"];
    }
    return _mImageDataSoure;
}
#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int CellW = MainScreenFrame_Width /5;
    
    return CGSizeMake(CellW, 70);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * SLCellIdentifier = @"SLUserVCCollectionViewCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"SLUserVCCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SLCellIdentifier];
    
    SLUserVCCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    
    //[cell setBackgroundColor:[UIColor redColor]];
    
    [cell.mImageView setImage:[UIImage imageNamed:self.mImageDataSoure[indexPath.row]]];
    cell.mLB_title.text = self.mDataSoure[indexPath.row];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(SLUserVCTableViewCell:didSelectItemAtIndexPath:)]) {
        [_delegate SLUserVCTableViewCell:self didSelectItemAtIndexPath:indexPath];
    }
   
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
