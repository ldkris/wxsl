//
//  SLHomeTwoCollectionViewCell.h
//  wxsl
//
//  Created by 刘冬 on 16/6/27.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLHomeTwoCollectionViewCellDelegate;
@interface SLHomeTwoCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn_wifi;
@property (weak, nonatomic) IBOutlet UIButton *btn_yongche;

@property(nonatomic,assign)id<SLHomeTwoCollectionViewCellDelegate>delegate;
@end

@protocol SLHomeTwoCollectionViewCellDelegate <NSObject>

-(void)SLHomeTwoCollectionViewCell:(SLHomeTwoCollectionViewCell *)cell onclickWifiBtn:(UIButton *)sender;

-(void)SLHomeTwoCollectionViewCell:(SLHomeTwoCollectionViewCell *)cell onclickYCbtn:(UIButton *)sender;

@end