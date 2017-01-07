//
//  SLWifiOderDetailCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiOderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_status;
@property (weak, nonatomic) IBOutlet UILabel *mlab_price;
@property (weak, nonatomic) IBOutlet UILabel *mlab_oderNo;
@property (weak, nonatomic) IBOutlet UILabel *mlab_reson;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_yd;
-(void)loadCellInfoWithInfo:(SLWifiOderDetial *)model andListModel:(SLWifiOderListModel *)listModel;
@property(nonatomic,retain)void(^onclikCancelBlock)(UIButton *sender);
-(void)onclikCancelBlock:(void (^)(UIButton *sender ))block;
@end
