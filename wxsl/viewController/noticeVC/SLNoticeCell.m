//
//  SLNoticeCell.m
//  wxsl
//
//  Created by 刘冬 on 16/8/17.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLNoticeCell.h"

@implementation SLNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)loadNotceInfo:(NSDictionary *)info{
    if (info == nil || [info allKeys] == 0) {
        return;
    }
    self.mLB_title.text = info[@"title"];
    
    NSString *contentStr = info[@"content"];
    
    NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[contentStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    self.mLB_subTitle.attributedText = attrStr1;
    //自动换行
    self.mLB_subTitle.numberOfLines = 0;
    //label高度自适应
    [self.mLB_subTitle sizeToFit];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
