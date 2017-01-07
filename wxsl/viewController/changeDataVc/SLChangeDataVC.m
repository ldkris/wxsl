//
//  SLChangeDataVC.m
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLChangeDataVC.h"

@interface SLChangeDataVC ()
@property (weak, nonatomic) IBOutlet UITextField *mTF_input;

@end

@implementation SLChangeDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:SL_GRAY];
    [self addSaveBarBtn];
    [self.mTF_input setPlaceholder:[NSString stringWithFormat:@"请输入%@",self.title]];
    self.title = [NSString stringWithFormat:@"修改%@",self.title];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.mTF_input becomeFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark public
-(void)changeDataBlock:(void (^)(NSString *))block{
    self.changeBlock = block;
}
#pragma mark private
-(void)addSaveBarBtn{
    UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mBtn setTitle:@"保存" forState:UIControlStateNormal];
    mBtn.frame = CGRectMake(0, 0, 50, 50);
    [mBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [mBtn.titleLabel setFont:DEFAULT_FONT(13)];
    [mBtn.titleLabel setTextColor:SL_GRAY_BLACK];
    [mBtn addTarget:self action:@selector(onclickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mSaveBtn = [[UIBarButtonItem alloc]initWithCustomView:mBtn];
    self.navigationItem.rightBarButtonItem = mSaveBtn;
}
#pragma mark event response
-(void)onclickSaveBtn:(UIButton *)sender{
    if (self.mTF_input.text == nil || self.mTF_input.text.length==0) {
        NSString *temp =[NSString stringWithFormat:@"请输入%@",self.title];
        ShowMSG(temp);
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.changeBlock) {
        self.changeBlock(self.mTF_input.text);
    }
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
