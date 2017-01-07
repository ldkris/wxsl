//
//  SLViolationCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLViolationCell.h"
@interface SLViolationCell()
/**
 *  违规原因
 */
@property (weak, nonatomic) IBOutlet UILabel *mLB_Violattion;

@end
@implementation SLViolationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.mLB_Violattion.text = @"";
}
-(void)loadCellInfoWithModel:(NSDictionary *)lsit{
    if (lsit ==nil || [lsit allKeys].count == 0) {
        return;
    }
    
    self.mLB_Violattion.text = lsit[@"illegalDesc"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
