//
//  SLWifiOrderListCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLWifiOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_reason;
@property (weak, nonatomic) IBOutlet UIButton *mbtn_deleOder;
@property (weak, nonatomic) IBOutlet UIButton *mbtn_btn;
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property (weak, nonatomic) IBOutlet UILabel *mlab_name;
@property (weak, nonatomic) IBOutlet UILabel *mlab_time;
@property (weak, nonatomic) IBOutlet UILabel *mlab_staus;
@property (weak, nonatomic) IBOutlet UILabel *mlab_pirce;
@property(nonatomic,retain)void(^onclikCancelBlock)(UIButton *sender);
-(void)onclikCancelBlock:(void (^)(UIButton *sender ))block;

-(void)loadCellInfoWithModel:(SLWifiOderListModel *)model;
@end
