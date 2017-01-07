//
//  SLTripPopleCell.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLTripPopleCell : UITableViewCell
-(void)loadCellInfoWithModel:(id )model;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_status;
@end
