//
//  SLWifiHomeHeaderView.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiHomeHeaderView.h"
@interface SLWifiHomeHeaderView()<ImagePlayerViewDelegate>
@property(nonatomic,retain)ImagePlayerView *mImagesView;
@property(nonatomic,retain)NSArray *imageURLs;
@end
@implementation SLWifiHomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    
}
#pragma makr public
-(void)deallocImageView{
    self.mImagesView.imagePlayerViewDelegate = nil;
    self.mImagesView =  nil;
}
-(void)setImagePlayViews:(NSArray *)imageArray{
    [self addSubview:self.mImagesView];
    [self.mImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
}
#pragma mark getter
-(ImagePlayerView *)mImagesView{
    if (_mImagesView == nil) {
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
        _mImagesView = temp;
    }
    return _mImagesView;
}
-(NSArray *)imageURLs{
    if (_imageURLs == nil) {
        _imageURLs = @[@""];
        }
    return _imageURLs;
}
#pragma mark ImagePlayerViewDelegate
- (NSInteger)numberOfItems
{
    return self.imageURLs.count;
}

- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView loadImageForImageView:(UIImageView *)imageView index:(NSInteger)index
{
    // recommend to use SDWebImage lib to load web image
    if (index == 1) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[index]] placeholderImage:[UIImage imageNamed:@"wifi_home_ad"]];
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[index]] placeholderImage:[UIImage imageNamed:@"wifi_home_ad"]];
    }
}
#pragma mark event response
- (IBAction)onclickHelperBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLWifiHomeHeaderView:onclickHelperBtn:)]) {
        [_delegate SLWifiHomeHeaderView:self onclickHelperBtn:sender];
    }
}
- (IBAction)onclickHotBtn:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(SLWifiHomeHeaderView:onclickHotBtn:)]) {
        [_delegate SLWifiHomeHeaderView:self onclickHotBtn:sender];
    }
}

//- (void)imagePlayerView:(ImagePlayerView *)imagePlayerView didTapAtIndex:(NSInteger)index
//{
//    NSLog(@"did tap index = %d", (int)index);
//    if (_delegate && [_delegate respondsToSelector:@selector(SLHomeReusableView:imagePlayerView:didTapAtIndex:)]) {
//        [_delegate SLHomeReusableView:self imagePlayerView:imagePlayerView didTapAtIndex:index];
//    }
//}
@end
