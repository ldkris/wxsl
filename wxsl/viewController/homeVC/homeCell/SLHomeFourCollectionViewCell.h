//
//  SLHomeFourCollectionViewCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLHomeFourCollectionViewCellDelegate;
@interface SLHomeFourCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *mBtn_huoche;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_qiche;
@property(nonatomic,assign)id<SLHomeFourCollectionViewCellDelegate>delegate;
@end
@protocol SLHomeFourCollectionViewCellDelegate <NSObject>

-(void)SLHomeFourCollectionViewCellDelegate:(SLHomeFourCollectionViewCell *)cell onclickHCPBtn:(UIButton *)sender;

-(void)SLHomeFourCollectionViewCellDelegate:(SLHomeFourCollectionViewCell *)cell onclickQCPBtn:(UIButton *)sender;

@end