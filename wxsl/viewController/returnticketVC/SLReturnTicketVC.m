//
//  SLReturnTicketVC.m
//  wxsl
//
//  Created by 刘冬 on 16/7/14.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLReturnTicketVC.h"
#import "PlaceholderTextView.h"
@interface SLReturnTicketVC ()<UITextViewDelegate>
@property (nonatomic, strong) PlaceholderTextView * textView;
@property (weak, nonatomic) IBOutlet UIButton *mBtn_comfire;

@end

@implementation SLReturnTicketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:SL_GRAY];
    if(self.mOderModel){
        self.title = @"申请退票";
    }else{
        self.title = @"违规理由";
    }
    

    self.mBtn_comfire.layer.masksToBounds = YES;
    self.mBtn_comfire.layer.cornerRadius = 5.0f;
    
    
    [self.view addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    
    if (self.textView.text == nil || self.textView.text.length == 0) {
        if(self.mOderModel ==nil){
            ShowMSG(@"请输违规理由");
            return;
        }
        ShowMSG(@"请输入退票理由");
        return;
    }
    
    NSMutableArray  *pids = [NSMutableArray array];
    for (NSDictionary *dic in self.mOderDetialModel.passengers) {
        NSString *pid = dic[@"pid"];
        [pids addObject:pid];
    }
    NSData *mData2 = [NSJSONSerialization dataWithJSONObject:pids options:NSJSONWritingPrettyPrinted error:nil];
    NSString *passString1 = [[NSString alloc]initWithData:mData2 encoding:NSUTF8StringEncoding];
    
    NSDictionary *paramDic = @{@"userId":sl_userID,@"orderId":self.mOderModel.mOderId,@"reason":self.textView.text,@"pids":passString1};
    
    [HttpApi refundTicket:paramDic SuccessBlock:^(id responseBody) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, MainScreenFrame_Width, 220)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:13.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        if(self.mOderModel ==nil){
            _textView.placeholder = @"请填写您违规的理由。。。";
        }else{
            _textView.placeholder = @"请填写您退票的理由。。。";
        }
        
    }
    
    return _textView;
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
