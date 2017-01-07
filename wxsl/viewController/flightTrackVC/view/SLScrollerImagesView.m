//
//  SLScrollerImagesView.m
//  wxsl
//
//  Created by 刘冬 on 16/7/8.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLScrollerImagesView.h"

@implementation SLScrollerImagesView


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.backgroundColor = [UIColor whiteColor];
    [self.mbackBtn removeFromSuperview];
    [self addSubview:self.mbackBtn];
}

-(void)addImgaeViews:(NSArray *)imageViews{
    if (imageViews.count ==0 || imageViews ==nil) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *mTempScrollerView = [[UIScrollView alloc]initWithFrame:self.frame];
    mTempScrollerView = [[UIScrollView alloc]init];
    mTempScrollerView.showsVerticalScrollIndicator = NO;
    mTempScrollerView.showsHorizontalScrollIndicator = NO;
    [mTempScrollerView setPagingEnabled:YES];
    [self addSubview:mTempScrollerView];
    
    
    [mTempScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(210);
    }];
    
    //self.mPageControl.numberOfPages = self.mADImageArray.count;
    
    UIView *container = [[UIView alloc]init];
    //[container setBackgroundColor:[UIColor blueColor]];
    [mTempScrollerView addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mTempScrollerView);
        make.height.mas_equalTo(210);
        make.top.equalTo(self.mas_top);
    }];
    
    UIView *lastView = nil;
    
    for (int i = 0; i<imageViews.count; i++) {
        UIImageView *subImageView = [[UIImageView alloc]init];
        [container addSubview:subImageView];
        [subImageView setImage:[UIImage imageNamed:imageViews[i]]];
        //        subImageView.backgroundColor = [UIColor colorWithHue:( arc4random() % 256 / 256.0 )
        //                                                  saturation:( arc4random() % 128 / 256.0 ) + 0.5
        //                                                  brightness:( arc4random() % 128 / 256.0 ) + 0.5
        //                                                       alpha:1];
        [subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(container);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(MainScreenFrame_Width);
            if (lastView == nil ){
                make.left.mas_equalTo(container.mas_left);
            }
            else
            {
                make.left.mas_equalTo(lastView.mas_right);
            }
        }];
        
        lastView = subImageView;
    }
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
        //  make.top.equalTo(self.mScrollerView.mas_top);
    }];

}

@end
