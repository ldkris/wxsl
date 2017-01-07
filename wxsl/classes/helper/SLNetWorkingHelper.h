//
//  SLNetWorkingHelper.h
//  wxsl
//
//  Created by 刘冬 on 16/6/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  成功回调
 *
 *  @param responseBody responseBody
 */
typedef void(^SuccessBlock)(id  responseBody);
/**
 *  失败回调
 *
 *  @param error error
 */
typedef void(^FailureBlock)(NSError * error);


@interface SLNetWorkingHelper : NSObject

+(SLNetWorkingHelper *)shareNetWork;
/**
 *  登陆
 *
 *  @param url
 *  @param Success
 *  @param falie
 */
-(void)login:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取验证码
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)getMobileVcode:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  用户忘记密码前信息校验接口
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)validateInfo:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  忘记密码
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)forgetPwd:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取个人信息
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)getUserInfo:(NSDictionary *)dic isShowLoadingView:(BOOL)isShow SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  修改个人信息
 *
 *  @param dic
 *  @param isShow
 *  @param Success
 *  @param falie
 */
-(void)putMyInfo:(NSDictionary *)dic  SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取城市列表
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)getCityList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  查询航班
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)searchFlightList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  修改绑定手机
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putBindMobile:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  修改密码
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)putModifyPwd:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取企业公告列表
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getEnterpriseNoticeList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 * 检查航班价格变动
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)checkPriceChanges:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取员工列表
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getEmployeeList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取联系人列表
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getContactList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  新增联系人
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putNewContact:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取常用出行人
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getTravelPeopleList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  新增出行人
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putTravelPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取部门列表
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getDepartList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取地址
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getDeliverAddrList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  新增地址
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putDeliverAddr:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交订单
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putFlightOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取我的商旅政策
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getMyTravelPolicyList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取我的订单
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getMyOrderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  	检查用户是否违规预定
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)checkWhetherIllegalBook:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取订单详情
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getMyOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  退票
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)refundTicket:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  支付
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)payFlightOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  改签
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)changeTicket:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  检查用户是否可以用公司支付
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)checkUseCompanyAccountPay:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  公司支付
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)payCompanyAccount:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  我的退票信息
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getMyReturnOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  我的改期订单
 *
 *  @param dic
 *  @param Success
 *  @param falie    
 */
-(void)getMyChangeOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  提交极光用户注册ID接口
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)putRegJpush:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取七牛云上传uptoeken
 *
 *  @param dic
 *  @param Success
 *  @param falie   
 */
-(void)getUptoken:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  获取保险列表
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getTrafficInsuranceList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 *  删除联系人
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)delContact:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  删除出行人
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)delTravelPeople:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  删除地址
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)delDeliverAddr:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 *  检查版本
 *
 *  @param dic
 *  @param Success
 *  @param falie
 */
-(void)getVersionUpdate:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

-(void)testPostUrl:(NSString *)url SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 获取热门WIFI列表

 @param dic
 @param Success
 @param falie
 */
-(void)getHotWifiList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 获取WIFI列表

 @param dic
 @param Success
 @param falie
 */
-(void)getWifiList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
  获取WIFI详情

 @param dic
 @param Success
 @param falie
 */
-(void)getWifiDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 提交WIFI订单

 @param dic
 @param Success
 @param falie   
 */
-(void)putWifiOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 获取WFI订单列表

 @param dic
 @param Success
 @param falie   
 */
-(void)getWifiOrderList:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;

/**
 获取WIFI订单详情

 @param dic
 @param Success
 @param falie
 */
-(void)getWifiOrderDetail:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 退订WIfi
 
 @param dic
 @param Success
 @param falie
 */
-(void)cancelOrder:(NSDictionary *)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
/**
 查询火车票

 @param dic
 @param Success
 @param falie   
 */
-(void)searchTrainTicketsList:(NSDictionary*)dic SuccessBlock:(SuccessBlock)Success FailureBlock:(FailureBlock)falie;
@end
