//
//  WiFiHomeCell.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "WiFiHomeCell.h"

@implementation WiFiHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)loadCellInfoWith:(SLHotWifiList *)model{
    if (model == nil) {
        return;
    }
    [self.img_flg sd_setImageWithURL:[NSURL URLWithString:model.mImageUrl]];
    [self.lab_city setText:model.mName];
    self.lab_price.text = [model.mPrice stringValue] ;
    
}
@end
