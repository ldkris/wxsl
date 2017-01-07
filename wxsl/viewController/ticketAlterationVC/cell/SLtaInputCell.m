//
//  SLtaInputCell.m
//  wxsl
//
//  Created by 刘冬 on 16/7/15.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLtaInputCell.h"
#import "PlaceholderTextView.h"
@interface SLtaInputCell ()

@end

@implementation SLtaInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mContentView addSubview:self.textView];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
}

-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, 220)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = (id)self;
        _textView.font = [UIFont systemFontOfSize:13.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.placeholder = @"可填写你的特殊服务入升舱要求。。。";
    }
    
    return _textView;
}
@end
