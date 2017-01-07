//
//  SLNetWorkingHelper.m
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLNetWorkingHelper.h"
#define TIMEOUT 30
#define BaseUrl @"http://www.mytourmall.com:8083/"
//#define BaseUrl @"http://192.168.31.239:8080/trip_interf/"
//#define BaseUrl @"http://112.74.68.26/"
@interface SLNetWorkingHelper ()

@end
@implementation SLNetWorkingHelper

+(SLNetWorkingHelper *)shareNetWork{
    static SLNetWorkingHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SLNetWorkingHelper alloc]init];
    });
    return _sharedClient;
}

-(instancetype)init{
    self = [super init];
    if (self) {
    
    }
    return self;
}

-(NSString *)sign:(NSDictionary *)param{

    NSArray * sortedKeys =
    [[param allKeys] sortedArrayUsingComparator:^(id string1, id string2)
     {
         return [((NSString *)string1) compare:((NSString *)string2)
                                       options:NSNumericSearch];
     }];
    
    
    NSMutableArray *ary=[NSMutableArray array];
    NSInteger i=0;
    while (i<sortedKeys.count)
    {
        NSString *str1=[sortedKeys objectAtIndex:i];
        if (![str1 isEqualToString:@"action"])
        {
            NSString *str=[NSString stringWithFormat:@"%@%@",str1,[param objectForKey:str1]];
            [ary addObject:str];
        }
        i++;
    }
    
    NSMutableArray *newary=[NSMutableArray arrayWithArray:ary];
    [newary insertObject:@"trip" atIndex:0];
    [newary addObject:@"trip"];
    
    //array to string
    NSMutableString *sign=[NSMutableString string];
    for (NSString *item in newary)
    {
        [sign appendString:item];
    }
    NSString *signEncode= [sign stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSLog(@"signEncode :%@",signEncode);
    //md5
    
    
    NSString *signResult=[MyFounctions md5:signEncode];
    
    return signResult;
}
#pragma mark base
-(AFHTTPSessionManager *)baseHtppRequest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    //header 设置
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json",@"application/x-www-form-urlencoded",@"multipart/form-data",@"image/webp",@"text/json",nil];
    return manager;
}

-(AFHTTPSessionManager *)testbaseHtppRequest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    //header 设置
    //    [manager.requestSerializer setValue:K_PASS_IP forHTTPHeaderField:@"Host"];
    //    [manager.requestSerializer setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    //    [manager.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3" forHTTPHeaderField:@"Accept-Language"];
    //    [manager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    //    [manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:35.0) Gecko/20100101 Firefox/35.0" forHTTPHeaderField:@"User-Agent"];
    
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json",@"application/x-www-form-urlencoded",@"multipart/form-data",@"image/webp",@"text/json",nil];
    return manager;
}
-(void)basePostUrl:(NSString *)url param:(NSDictionary *)param isShowLoadingView:(BOOL)isShow Success:(SuccessBlock)success failure:(FailureBlock)faileure{
    
    if (isShow) {
      //  [SVProgressHUD setMinimumDismissTimeInterval:0.02];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//        [SVProgressHUD show];
        
        [SLNetWorkingStatusView show];
    }

    AFHTTPSessionManager *manager = [self baseHtppRequest];
    //公共参数
    NSMutableDictionary *mTempDic;
    if (param == nil) {
        mTempDic = [NSMutableDictionary dictionary];
    }
    mTempDic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *timestamp=[MyFounctions getTimeStamp];
    NSString *apptype=@"2";
    
    [mTempDic setValue:v forKey:@"v"];
    [mTempDic setValue:timestamp forKey:@"timestamp"];
    [mTempDic setValue:apptype forKey:@"apptype"];
    NSString *SingStr = [self sign:mTempDic];
    [mTempDic setObject:SingStr forKey:@"sign"];
    
//    NSMutableString * str_log = [[NSMutableString alloc]init];
//    int i = 0;
//    for (NSString * key in [mTempDic allKeys])
//    {
//       [str_log appendFormat:@"%@=%@",key,[mTempDic objectForKey:key]];
//        i++;
//    }
    
    [manager POST:url parameters:mTempDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success && [responseObject[@"respCode"] integerValue]==0){
             //成功回调
             if (isShow) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SLNetWorkingStatusView dismiss];
                     [SVProgressHUD dismiss];
//                     [SVProgressHUD showSuccessWithStatus:responseObject[@"respMsg"]];
                 });
             }
             success(responseObject);
         }else{
             //成功回调
//             if (isShow) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SLNetWorkingStatusView dismiss];
                     [SVProgressHUD showErrorWithStatus:responseObject[@"respMsg"]];
                 });
//             }
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (faileure) {
            //失败回调
             dispatch_async(dispatch_get_main_queue(), ^{
               // [SVProgressHUD setMinimumDismissTimeInterval:0.2];
                 LDLOG(@"网络错误 %@",error.userInfo[@"NSDebugDescription"] );
                 
                 NSString *errorStr = error.userInfo[@"NSLocalizedDescription"];
                 if (errorStr) {
                     [SLNetWorkingStatusView dismiss];
                     [SVProgressHUD showErrorWithStatus:errorStr];
                     return ;
                 }
                 [SLNetWorkingStatusView dismiss];
                 [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSDebugDescription"]];
             });
             faileure(error);
         }
     }];
}

-(void)TESTbasePostUrl:(NSString *)url param:(NSDictionary *)param isShowLoadingView:(BOOL)isShow Success:(SuccessBlock)success failure:(FailureBlock)faileure{
    
    if (isShow) {
        //  [SVProgressHUD setMinimumDismissTimeInterval:0.02];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [SVProgressHUD show];
    }
    
    AFHTTPSessionManager *manager = [self testbaseHtppRequest];
    //公共参数
    NSMutableDictionary *mTempDic;
    if (param == nil) {
        mTempDic = [NSMutableDictionary dictionary];
    }
    mTempDic = [NSMutableDictionary dictionaryWithDictionary:param];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *v = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *timestamp=[MyFounctions getTimeStamp];
    NSString *apptype=@"2";
    
    [mTempDic setValue:v forKey:@"v"];
    [mTempDic setValue:timestamp forKey:@"timestamp"];
    [mTempDic setValue:apptype forKey:@"apptype"];
    [mTempDic setObject:[self sign:mTempDic] forKey:@"sign"];
    
    [manager POST:url parameters:mTempDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         if (success && [responseObject[@"respCode"] integerValue]==0){
             //成功回调
             if (isShow) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD showSuccessWithStatus:responseObject[@"respMsg"]];
                 });
             }
             success(responseObject);
         }else{
             //成功回调
             if (isShow) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD showErrorWithStatus:responseObject[@"respMsg"]];
                 });
             }
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (faileure) {
             //失败回调
             dispatch_async(dispatch_get_main_queue(), ^{
                 // [SVProgressHUD setMinimumDismissTimeInterval:0.2];
                 LDLOG(@"网络错误 %@",error.userInfo[@"NSDebugDescription"] );
                 [SVProgressHUD showErrorWithStatus:error.userInfo[@"NSDebugDescription"] ];
             });
             faileure(error);
         }
     }];
}
#pragma mark ------------------------------------------- 机票以及用户信息接口
#pragma mark Login
-(void)login:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/login.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark getMobileVcode
-(void)getMobileVcode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/getMobileVcode.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
   [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 用户忘记密码前信息校验
-(void)validateInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/validateInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
   [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 用户忘记密码
-(void)forgetPwd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/forgetPwd.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取用户信息
-(void)getUserInfo:(NSDictionary *)dic isShowLoadingView:(BOOL)isShow SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/my/getMyInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:isShow Success:Success failure:falie];
}
#pragma mark 修改用户信息
-(void)putMyInfo:(NSDictionary *)dic  SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/my/putMyInfo.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取城市列表
-(void)getCityList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getCityList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
   [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 查询航班
-(void)searchFlightList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/searchFlightList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 修改绑定手机
-(void)putBindMobile:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/putBindMobile.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 修改密码
-(void)putModifyPwd:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/my/putModifyPwd.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取企业公告
-(void)getEnterpriseNoticeList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getEnterpriseNoticeList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 检查航班价格变动
-(void)checkPriceChanges:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/checkPriceChanges.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
//    [self TESTbasePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取员工列表
-(void)getEmployeeList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getEmployeeList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
//     [self TESTbasePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取联系人列表
-(void)getContactList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getContactList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 删除联系人
-(void)delContact:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/delContact.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 删除地址
-(void)delDeliverAddr:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/delDeliverAddr.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 删除出行人
-(void)delTravelPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/delTravelPeople.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 新增联系人
-(void)putNewContact:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/putNewContact.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取常用出行人
-(void)getTravelPeopleList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getTravelPeopleList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 新增出席人
-(void)putTravelPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/putTravelPeople.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取部门列表
-(void)getDepartList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getDepartList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取地址
-(void)getDeliverAddrList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/getDeliverAddrList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 新增地址
-(void)putDeliverAddr:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/putDeliverAddr.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 提交订单
-(void)putFlightOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/putFlightOrder.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取的我的商旅政策
-(void)getMyTravelPolicyList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/my/getMyTravelPolicyList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];

}
#pragma mark 获取订单列表
-(void)getMyOrderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/getMyOrderList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 检查用户是否违规预定
-(void)checkWhetherIllegalBook:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/checkWhetherIllegalBook.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取订单详情
-(void)getMyOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/getMyOrderDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 获取订单详情
-(void)refundTicket:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/refundTicket.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 改签
-(void)changeTicket:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/changeTicket.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 支付
-(void)payFlightOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/payFlightOrder.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark 是否可以公司支付
-(void)checkUseCompanyAccountPay:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/checkUseCompanyAccountPay.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 公司支付
-(void)payCompanyAccount:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/payCompanyAccount.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];

}
#pragma mark 我的退票详情订单
-(void)getMyReturnOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/getMyReturnOrderDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 我的改签订单
-(void)getMyChangeOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/flight/getMyChangeOrderDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 提交极光用户注册ID接口
-(void)putRegJpush:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/user/putRegJpush.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 获取七牛云上传uptoeken
-(void)getUptoken:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getUptoken.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getTrafficInsuranceList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getTrafficInsuranceList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
-(void)getVersionUpdate:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/common/getVersionUpdate.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:NO Success:Success failure:falie];
}
#pragma mark 测试
-(void)testPostUrl:(NSString *)url SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    LDLOG(@"网络测试");
   // [self basePostUrl:nil param:dic isShowLoadingView:YES Success:Success failure:falie];
}


#pragma mark ------------------------------------------- WIFI接口
-(void)getHotWifiList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/getHotProductList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getWifiList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"/wifi/getProductList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)getWifiDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/getProductDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
-(void)putWifiOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/putWifiOrder.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getWifiOrderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/getWifiOrderList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)getWifiOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/getWifiOrderDetail.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}

-(void)cancelOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"wifi/cancelOrder.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
#pragma mark -------------------------------------------火车票
-(void)searchTrainTicketsList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie{
    NSString *mActionStr = @"train/searchTrainList.sl";
    NSString *mUrlStr = [BaseUrl stringByAppendingString:mActionStr];
    [self basePostUrl:mUrlStr param:dic isShowLoadingView:YES Success:Success failure:falie];
}
@end
