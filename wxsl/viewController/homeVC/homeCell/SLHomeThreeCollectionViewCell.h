//
//  SLHomeThreeCollectionViewCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLHomeThreeCollectionViewCellDelegate;
@interface SLHomeThreeCollectionViewCell : UICollectionViewCell
@property(nonatomic,assign)id<SLHomeThreeCollectionViewCellDelegate>delegate;
@end

@protocol SLHomeThreeCollectionViewCellDelegate <NSObject>

-(void)SLHomeThreeCollectionViewCellDelegate:(SLHomeThreeCollectionViewCell *)cell onclickQZBtn:(UIButton *)sender;

-(void)SLHomeThreeCollectionViewCellDelegate:(SLHomeThreeCollectionViewCell *)cell onclickJDBtn:(UIButton *)sender;

@end