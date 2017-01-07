//
//  SLWifiBZVC.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiBZVC.h"
#import "PlaceholderTextView.h"
@interface SLWifiBZVC ()
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfire;
@end

@implementation SLWifiBZVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"出行信息/备注/特殊要求";
    
    self.mBtn_comfire.layer.masksToBounds = YES;
    self.mBtn_comfire.layer.cornerRadius = 5.0f;
    
    [self.view setBackgroundColor:SL_GRAY];
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark getter
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, 220)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:13.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.placeholder = @"出行信息/备注/特殊要求";
    }
    
    return _textView;
}

-(void)backDataBlock:(void (^)(NSString *))block{
    self.backData = block;
}
- (IBAction)onclickComFirBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    self.backData(self.textView.text);
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
