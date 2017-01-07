//
//  SLHomeReusableView.m
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLHomeReusableView.h"
#define SL_GRAY    RGBACOLOR(240, 240, 240, 1)
@interface SLHomeReusableView ()<ImagePlayerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *asda;

@property(nonatomic,retain)NSArray *images;
@end
@implementation SLHomeReusableView

-(void)awakeFromNib{
    
    self.mLB_title.text = @"无";
    self.mLB_subTitle.text = @"无";
    
    //[self.mPageControl br]
}

#pragma mark public

-(void)loadNoticeInfo:(NSDictionary *)info{
    if (info == nil || [info allKeys]==0) {
         self.mLB_title.text  = @"无";
         self.mLB_subTitle.text = @"无";
        return;
    }
    
    self.mLB_title.text = info[@"title"];
    NSString *contentStr = info[@"content"];
    
     NSAttributedString * attrStr1 = [[NSAttributedString alloc] initWithData:[contentStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.mLB_subTitle.attributedText = attrStr1;
    //自动换行
//    self.mLB_subTitle.numberOfLines = 0;
    //label高度自适应
//    [self.mLB_subTitle sizeToFit];
}

-(void)setImagePlayViews:(NSArray *)imageArray{

    if (imageArray.count == 0 || imageArray == nil) {
        return;
    }
    
   self.images = imageArray;
    
    ImagePlayerView * temp =[[ImagePlayerView alloc] init];
    temp.scrollInterval = 3.0f;
    // adjust pageControl position
    [temp setImagePlayerViewDelegate:self];
    temp.pageControlPosition = ICPageControlPosition_BottomRight;
    temp.hidePageControl = NO;
    temp.endlessScroll = YES;
    [temp.pageControl setCurrentPageIndicatorTintColor:SL_BULE];
    [temp.pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
    [temp reloadData];
    [self addSubview:temp];
    [temp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        
        if (MainScreenFrame_Width >= 414) {
             make.height.mas_equalTo(200);
        }else{
            make.height.mas_equalTo(150);
        }
       
    }];
    
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mBtn.selected = YES;
    mBtn.layer.masksToBounds = YES;
    mBtn.layer.cornerRadius = 2.0;
    mBtn.tag = 10;
    [mBtn addTarget:self action:@selector(onclickReasonGongBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtn setBackgroundColor:[UIColor whiteColor]];
    [mBtn setTitle:@"因公" forState:UIControlStateNormal];
    [mBtn.titleLabel setFont:DEFAULT_FONT(14)];
    [mBtn setTitleColor:SL_BULE forState:UIControlStateNormal];
  
    [temp addSubview:mBtn];
    [mBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(temp.mas_centerX);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    UIButton *mBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    mBtn1.tag = 11;
    mBtn1.selected = NO;
    [mBtn1 addTarget:self action:@selector(onclickReasonSiBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mBtn1 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [mBtn1 setTitle:@"因私" forState:UIControlStateNormal];
    [mBtn1.titleLabel setFont:DEFAULT_FONT(14)];
    [mBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [temp addSubview:mBtn1];
    [mBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(temp.mas_centerX).with.offset(-1);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
}
#pragma mark event response
-(void)onclickReasonGongBtn:(UIButton *)sender{
    
    UIButton *  tempBtn = (UIButton *)[self viewWithTag:11];
   
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:SL_BULE forState:UIControlStateNormal];
    
    [tempBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeReusableView:changeRasonBtn:)]) {
        [_delegate SLHomeReusableView:self changeRasonBtn:sender];
    }
    
}
-(void)onclickReasonSiBtn:(UIButton *)sender{
    UIButton *  tempBtn = (UIButton *)[self viewWithTag:10];
    
    [sender setBackgroundColor:[UIColor whiteColor]];
    [sender setTitleColor:SL_BULE forState:UIControlStateNormal];
    
    [tempBtn setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [tempBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeReusableView:changeRasonBtn:)]) {
        [_delegate SLHomeReusableView:self changeRasonBtn:sender];
    }
}
- (IBAction)onclickNoticeBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeReusableView:onclickNoticeBtn:)]) {
        [_delegate SLHomeReusableView:self onclickNoticeBtn:nil];
    }
}

#pragma mark - ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.images.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    if (index == 1) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.images[index]] placeholderImage:[UIImage imageNamed:@"home_ad"]];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.images[index]] placeholderImage:[UIImage imageNamed:@"home_ad_two"]];
    }
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
{
    NSLog(@"did tap index = %d", (int)index);
    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeReusableView:imagePlayerView:didTapAtIndex:)]) {
        [_delegate SLHomeReusableView:self imagePlayerView:imagePlayerView didTapAtIndex:index];
    }
}
#pragma mark getter

@end
