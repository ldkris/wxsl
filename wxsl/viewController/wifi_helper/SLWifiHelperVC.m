//
//  SLWifiHelperVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiHelperVC.h"

@interface SLWifiHelperVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;

@end

@implementation SLWifiHelperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"新手指南";
    
    UIImage *mHleperImage = [UIImage imageNamed:@"wifi_helper"];
//    mHleperImage.size
    self.mScrollView.contentSize = CGSizeMake(MainScreenFrame_Width, mHleperImage.size.height);
    
    UIImageView *mConTenView = [[UIImageView alloc]initWithImage:mHleperImage];
    [mConTenView setFrame:CGRectMake(0, 0, mHleperImage.size.width, mHleperImage.size.height)];
    [self.mScrollView addSubview:mConTenView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
