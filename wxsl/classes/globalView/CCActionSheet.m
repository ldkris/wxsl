//
//  CCActionSheet.m
//  CCActionSheet
//
//  Created by maxmoo on 16/1/29.
//  Copyright © 2016年 maxmoo. All rights reserved.
//

#import "CCActionSheet.h"

#define CC_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CC_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define cellHeight 45

@interface CCActionSheet()

@property (nonatomic, strong) UIWindow *sheetWindow;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) NSArray *selectArray;
@property (nonatomic, strong) NSArray *detailArray;
@property (nonatomic, strong) NSString *cancelString;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *backView;


@property (nonatomic, strong) UIView *TGQView;

@end

@implementation CCActionSheet

+ (instancetype)shareSheet{
    static id shareSheet;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shareSheet = [[[self class] alloc] init];
    });
    return shareSheet;
}
#pragma mark public
-(void)cc_showTuiGaiQianView:(NSString *)title contentStr:(NSString *)contentStr cancelTitle:(NSString *)cancel delegate:(id<CCActionSheetDelegate>)delegate{
   
    if (!_sheetWindow) {
        [self initSheetWindow];
    }
    
    _backView.alpha = 0.2;
    _sheetWindow.hidden = NO;
    
    UIView *selectView = [self creatTGQView:title contentStr:contentStr cancelTitle:cancel];
    [_sheetWindow addSubview:selectView];
    
}

- (void)cc_actionSheetWithSelectArray:(NSArray *)array deltalArray:(NSArray *)detailArr cancelTitle:(NSString *)cancel delegate:(id<CCActionSheetDelegate>)delegate titile:(NSString *)titile{
    
    self.selectArray = [NSArray arrayWithArray:array];
    self.detailArray = [NSArray arrayWithArray:detailArr];
    self.cancelString = cancel;
    self.delegate = delegate;
    
    if (!_sheetWindow) {
        [self initSheetWindow];
    }
    UIView *selectView = [self creatSelectButton];
    [_sheetWindow addSubview:selectView];
    UIView *titleView = [self creatTitleViewTitile:titile];
    [_sheetWindow addSubview:titleView];
    
    _sheetWindow.hidden = NO;
    
    [self showSheetWithAnimation];
}

#pragma mark init
- (void)initSheetWindow{
    _sheetWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, CC_SCREEN_WIDTH, CC_SCREEN_HEIGHT)];
    _sheetWindow.windowLevel = UIWindowLevelStatusBar;
    _sheetWindow.backgroundColor = [UIColor clearColor];
    
    _sheetWindow.hidden = YES;

    //zhezhao
    _backView = [[UIView alloc] initWithFrame:_sheetWindow.bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.0;
    [_sheetWindow addSubview:_backView];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    _tapGesture.numberOfTapsRequired = 1;
    [_backView addGestureRecognizer:_tapGesture];
    
}

#pragma mark private
- (void)showSheetWithAnimation{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + 5 + (self.selectArray.count - 2) * 2;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sheetView.frame = CGRectMake(0, CC_SCREEN_HEIGHT - viewHeight, CC_SCREEN_WIDTH, viewHeight);
        _titleView.frame = CGRectMake(0, CC_SCREEN_HEIGHT - viewHeight -46, CC_SCREEN_WIDTH, 45);
        _backView.alpha = 0.2;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidSheetWithAnimation{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + 5 + (self.selectArray.count - 2) * 2;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sheetView.frame = CGRectMake(0, CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH, viewHeight);
        _titleView.frame = CGRectMake(0, CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH, 45);
        _backView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self hidActionSheet];
    }];
}

#pragma mark  创建View

- (UIView *)creatTGQView:(NSString *)title contentStr:(NSString *)contentStr cancelTitle:(NSString *)cancel{
    _TGQView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    [_TGQView setCenter:CGPointMake(CC_SCREEN_WIDTH/2, CC_SCREEN_HEIGHT/2-64)];
    [_TGQView setBackgroundColor:[UIColor whiteColor]];
    [_TGQView.layer setMasksToBounds:YES];
    [_TGQView.layer setCornerRadius:5.0f];
    
    UILabel *mtempLable = [[UILabel alloc]init];
    [mtempLable setFrame:CGRectMake(_TGQView.frame.size.width/2 - 40, 15, 80, 30)];
    [mtempLable setText:title];
    [mtempLable setFont:DEFAULT_FONT(15)];
    [_TGQView addSubview:mtempLable];
    
    
    UILabel *mcontentLable = [[UILabel alloc]init];
    [mcontentLable setFrame:CGRectMake(25, 50, _TGQView.frame.size.width -20,80)];
    //[mcontentLable setText:title];
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
    
    mcontentLable.attributedText = attrStr;
    //自动换行
    mcontentLable.numberOfLines = 0;
    //label高度自适应
    [mcontentLable sizeToFit];
   // [mcontentLable setFont:DEFAULT_FONT(15)];
    [_TGQView addSubview:mcontentLable];
    
    UIButton *exBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[exBtn setBackgroundColor:[UIColor redColor]];
    [exBtn setTitle:@"退出" forState:UIControlStateNormal];
    [exBtn.titleLabel setFont:DEFAULT_FONT(14)];
    [exBtn setTitleColor:SL_BULE forState:UIControlStateNormal];
    [exBtn setTitleEdgeInsets:UIEdgeInsetsMake(30, 20, 0, 0)];
    [exBtn setFrame:CGRectMake(_TGQView.frame.size.width - 60, _TGQView.frame.size.height - 60, 50, 50)];
   // [exBtn setFrame:CGRectMake(0, 0, 50, 50)];
    
    [exBtn addTarget:self action:@selector(hidActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [_TGQView addSubview:exBtn];
    
    return _TGQView;
    
}
- (UIView *)creatTitleViewTitile:(NSString *)titile{
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH, 45)];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel *mtempLable = [[UILabel alloc]init];
    [mtempLable setFrame:CGRectMake(CC_SCREEN_WIDTH/2 - 50, 0, 100, 50)];
    [mtempLable setText:titile];
    [mtempLable setFont:DEFAULT_FONT(15)];
    [_titleView addSubview:mtempLable];
    
    return _titleView;
}

- (UIView *)creatSelectButton{
    CGFloat viewHeight = cellHeight * (self.selectArray.count+1) + 5 + (self.selectArray.count - 2) * 2;
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, CC_SCREEN_HEIGHT, CC_SCREEN_WIDTH, viewHeight)];
    _sheetView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    
    for (int i = 0; i < self.selectArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UILabel *mtempLable = [[UILabel alloc]init];
        [mtempLable setFrame:CGRectMake(13, cellHeight/2, CC_SCREEN_WIDTH, 20)];
        //[mtempLable setText:@"选择预定类型"];
        [mtempLable setText:self.detailArray[i]];
        [mtempLable setFont:DEFAULT_FONT(10)];
        [mtempLable setTextColor:SL_GRAY_Hard];
        [button addSubview:mtempLable];
        
        
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;//设置文字位置，现设为居左，默认的是居中
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-15, 13, 0, 0)];
        button.frame = CGRectMake(0, i * (cellHeight+1), CC_SCREEN_WIDTH, cellHeight);
        [button setTitle:[NSString stringWithFormat:@"%@",self.selectArray[i]] forState:UIControlStateNormal];
        [button.titleLabel setFont:DEFAULT_BOLD_FONT(14)];
        [button .titleLabel setTextColor:[UIColor blackColor]];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1001+i;
        [_sheetView addSubview:button];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, viewHeight - cellHeight, CC_SCREEN_WIDTH, cellHeight);
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:[NSString stringWithFormat:@"%@",self.cancelString] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 1000;
    [_sheetView addSubview:cancelButton];
    
    return _sheetView;
}

- (void)buttonSelectAction:(UIButton *)btn{
    UIButton *button = (UIButton *)btn;
    NSInteger index = button.tag - 1000;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cc_actionSheetDidSelectedIndex: SelectBtn:)]) {
        [self.delegate cc_actionSheetDidSelectedIndex:index SelectBtn:btn];
    }
    [self hidSheetWithAnimation];
}

#pragma mark
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self hidSheetWithAnimation];
}

- (void)hidActionSheet{
    _sheetWindow.hidden = YES;
    _sheetWindow = nil;
}

@end
