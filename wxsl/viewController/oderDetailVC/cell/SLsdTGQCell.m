//
//  SLsdTGQCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLsdTGQCell.h"
@interface SLsdTGQCell ()
@property (weak, nonatomic) IBOutlet UILabel *mLb_content;


@end
@implementation SLsdTGQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}
-(void)loadwgCellInfoWithModel:(NSArray *)model{
    if (model== nil && model.count == 0) {
        return;
    }
    
    
    NSMutableString *contentStr = [NSMutableString string];
    // NSArray *temp = @[@"退票说明"];
    for (int i = 0; i<model.count; i++) {
        NSDictionary *info = model[i];
        NSString *tempStr = [NSString stringWithFormat:@"违规原因：%@\n违规理由：%@\n",info[@"illegalDesc"],info[@"illegalReason"]];
        [contentStr appendString:tempStr];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12]
                    range:NSMakeRange(0, contentStr.length)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:SL_GRAY_Hard
                    range:NSMakeRange(0, contentStr.length)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //段落间距
    paragraph.paragraphSpacing = 8;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, [contentStr length])];
    
    self.mLb_content.attributedText = attrStr;
    //自动换行
    self.mLb_content.numberOfLines = 0;
    //label高度自适应
    [self.mLb_content sizeToFit];
}

-(void)loadTPCellInfoWithModel:(NSArray *)model{
    if (model== nil && model.count == 0) {
        return;
    }
    
    
    NSMutableString *contentStr = [NSMutableString string];
   // NSArray *temp = @[@"退票说明"];
    for (int i = 0; i<model.count; i++) {
        NSString *tempStr = [NSString stringWithFormat:@"%@\n",model[i]];
        [contentStr appendString:tempStr];
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:11]
                    range:NSMakeRange(0, contentStr.length)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:SL_GRAY_Hard
                    range:NSMakeRange(0, contentStr.length)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //段落间距
    paragraph.paragraphSpacing = 8;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, [contentStr length])];
    
    self.mLb_content.attributedText = attrStr;
    //自动换行
    self.mLb_content.numberOfLines = 0;
    //label高度自适应
    [self.mLb_content sizeToFit];
}
-(void)loadCellInfoWithModel:(SLOrderDetialModel *)model{

//    NSString *contentStr = @"航班起飞前，退票手续费为票面价的50%;航班起飞后，只退机建和燃油。\n航班起飞前，改期手续费为票面价的30%;航班起飞后，改期手续费为票面价的50%。\n不可签转";
    
    if (model == nil) {
        return;
    }
    
    NSString *contentStr = model.mTgqDesc;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:11]
                    range:NSMakeRange(0, contentStr.length)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:SL_GRAY_Hard
                    range:NSMakeRange(0, contentStr.length)];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //段落间距
    paragraph.paragraphSpacing = 8;
    //对齐方式
    paragraph.alignment = NSTextAlignmentLeft;
    
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, [contentStr length])];
    
    self.mLb_content.attributedText = attrStr;
    //自动换行
    self.mLb_content.numberOfLines = 0;
    //label高度自适应
    [self.mLb_content sizeToFit];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
