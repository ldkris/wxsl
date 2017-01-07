//
//  WiFiHomeCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WiFiHomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_flg;
@property (weak, nonatomic) IBOutlet UILabel *lab_city;
@property (weak, nonatomic) IBOutlet UILabel *lab_price;
-(void)loadCellInfoWith:(SLHotWifiList *)model;
@end
