//
//  SLModels.h
//  wxsl
//
//  Created by 刘冬 on 16/7/15.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface SLModels : MTLModel<MTLJSONSerializing>

@end



@interface SLUserInfoModel : MTLModel<MTLJSONSerializing>
/**
 *  中文名字
 */
@property (nonatomic,copy   ) NSString                 * mChineseName;
/**
 *  英文名字
 */
@property (nonatomic,copy   ) NSString                 * mEnglishName;
/**
 *  头像
 */
@property (nonatomic,copy   ) NSString                 * mHeadimgurl;
/**
 *  邮箱
 */
@property (nonatomic,copy   ) NSString                 * mEmail;
/**
 *  性别 1男 2女
 */
@property (nonatomic,copy   ) NSNumber                 * mSex;

/**
 *  生日
 */
@property (nonatomic,copy   ) NSString                 * mBirthday;
/**
 *  公司名字
 */
@property (nonatomic,copy   ) NSString                 * mCompanyName;
/**
 *  部门
 */
@property (nonatomic,copy   ) NSNumber                 * mDid;
/**
 *  部门名字
 */
@property (nonatomic,copy   ) NSString                 * mDName;
/**
 *  积分
 */
@property (nonatomic,copy   ) NSNumber                 * mScore;
/**
 *  证件
 */
@property (nonatomic,copy   ) NSArray                  * mDocTypes;
@end




@interface SLCheckFightModel : MTLModel<MTLJSONSerializing>
/**
 *  起飞时间
 */
@property (nonatomic,copy   ) NSString                 * mFormTime;
/**
 *  到达时间
 */
@property (nonatomic,copy   ) NSString                 * mArriveTime;
/**
 *  起飞机场
 */
@property (nonatomic,copy   ) NSString                 * mFormAirport;
/**
 *  到达机场
 */
@property (nonatomic,copy   ) NSString                 * mArriveAirport;
/**
 *  价格
 */
@property (nonatomic,copy   ) NSNumber                 * mPrice;

/**
 *  机建
 */
@property (nonatomic,copy   ) NSNumber                 * mAirrax;
/**
 *  用时
 */
@property (nonatomic,copy   ) NSNumber                 * mUseTime;
/**
 *  航空公司名字
 */
@property (nonatomic,copy   ) NSString                 * mAirlineName;
/**
 *  航班日期
 */
@property (nonatomic,copy   ) NSString                 * mFlightDate;
/**
 *  航空公司编码
 */
@property(nonatomic,copy    )NSString *mAirCode;
/**
 *  机型
 */
@property(nonatomic,copy    )NSString *mAirModel;
/**
 *  起飞航站楼
 */
@property(nonatomic,copy    )NSString *mformTerm;
/**
 *  起飞机场 编码
 */
@property(nonatomic,copy    )NSString *mformAirportCode;
/**
 *  到达航站楼
 */
@property(nonatomic,copy    )NSString *marrTerm;
/**
 *  到达机场 编码
 */
@property(nonatomic,copy    )NSString *marrAirportCode;
/**
 *  舱位信息列表
 */
@property (nonatomic,copy   ) NSArray                  * mCabinfos;
/**
 *  航司列表
 */
@property (nonatomic,copy   ) NSArray                  * mAirlines;
/**
 *  机场列表
 */
@property (nonatomic,copy   ) NSArray                  * mAirports;
/**
 *  航班号
 */
@property (nonatomic,copy   ) NSString                  * mFlightno;

/**
 *  退改签ID
 */
@property (nonatomic,copy   ) NSString                  * mTgqid;
/**
 *  是否经停
 */
@property (nonatomic,copy   ) NSNumber                  * mStop;
/**
 *  是否为共享航班
 */
@property (nonatomic,copy   ) NSNumber                  * mShare;
@end

@interface SLRBDModel : MTLModel<MTLJSONSerializing>
/**
 *  舱位名字
 */
@property (nonatomic,copy   ) NSString                 * mRBDName;
/**
 *  舱位编码
 */
@property (nonatomic,copy   ) NSString                 * mRBDCode;
/**
 *  折扣
 */
@property (nonatomic,copy   ) NSNumber                 * mRBDDiscount;
/**
 *  官方价格
 */
@property (nonatomic,copy   ) NSNumber                 * mRBDPrice;
/**
 *  售价
 */
@property (nonatomic,copy   ) NSNumber                 * mRBDSalePrice;
/**
 *  退票描述
 */
@property (nonatomic,copy   ) NSString                 * mRBDRefund;
/**
 *  改期描述
 */
@property (nonatomic,copy   ) NSString                 * mRBDCdate;
/**
 *  签转说明
 */
@property (nonatomic,copy   ) NSString                 * mRBDTransfer;
/**
 *  座位数
 */
@property (nonatomic,copy   ) NSString                 * mSeat;
@end


@interface SLPassengerModel : MTLModel<MTLJSONSerializing>
/**
 *  姓名
 */
@property (nonatomic,copy   ) NSString                 * mName;
/**
 *  员工ID
 */
@property (nonatomic,copy   ) NSString                 * mID;
/**
 *  证件类型
 */
@property (nonatomic,copy   ) NSString                 * mIDType;
/**
 *  部门名称
 */
@property (nonatomic,copy   ) NSString                 * mDname;
/**
 *  部门名称
 */
@property (nonatomic,copy   ) NSNumber                 * mDID;
/**
 *  证件号
 */
@property (nonatomic,copy   ) NSString                 * mIdcard;
/**
 *  审批类型 1免审 2出行审批 3违规审批
 */
@property (nonatomic,copy   ) NSNumber                 * mAudit;
/**
 *  差旅政策
 */
@property (nonatomic,copy   ) NSString                 * mPolicy;
/**
 *  差旅政策ID
 */
@property (nonatomic,copy   ) NSNumber                 * mPolicyId;

@end


@interface SLContactModel : MTLModel<MTLJSONSerializing>
/**
 *  姓名
 */
@property (nonatomic,copy   ) NSString                 * mName;
/**
 *  联系人ID
 */
@property (nonatomic,copy   ) NSString                 * mID;
/**
 *  手机号码
 */
@property (nonatomic,copy   ) NSString                 * mMobile;
@end


@interface SLAddressModel : MTLModel<MTLJSONSerializing>
/**
 *  姓名
 */
@property (nonatomic,copy   ) NSString                 * mName;
/**
 *  联系人ID
 */
@property (nonatomic,copy   ) NSNumber                 * mID;
/**
 *  手机号码
 */
@property (nonatomic,copy   ) NSString                 * mMobile;
/**
 *  地址
 */
@property (nonatomic,copy   ) NSString                 * mAddress;
/**
 *  配送方式 1：自取  2：快递
 */
@property (nonatomic,copy   ) NSString                 * mShipMethod;
@end

@interface SLOrderModel: MTLModel<MTLJSONSerializing>
/**
 *  姓名
 */
@property (nonatomic,copy   ) NSNumber                 * mOderId;
/**
 *  出发时间
 */
@property (nonatomic,copy   ) NSString                 * mDepTime;

/**
 *  到达时间
 */
@property (nonatomic,copy   ) NSString                 * mArrTime;
/**
 *  出发机场
 */
@property (nonatomic,copy   ) NSString                 * mDepAirport;

/**
 *  到达机场
 */
@property (nonatomic,copy   ) NSString                 * mArrAirport;
/**
 *  出发机场
 */
@property (nonatomic,copy   ) NSString                 * mDepTerm;

/**
 *  到达机场
 */
@property (nonatomic,copy   ) NSString                 * mArrTerm;

/**
 *  航班日期
 */
@property (nonatomic,copy   ) NSString                 * mFlightDate;

/**
 *  总飞行时间（单位：秒）
 */
@property (nonatomic,copy   ) NSNumber                 * mFlightTime;
/**
 *  航司名称
 */
@property (nonatomic,copy   ) NSString                 * mAirline;

/**
 *  航司二字码
 */
@property (nonatomic,copy   ) NSString                 * mAirlineNo;

/**
 *  航班号
 */
@property (nonatomic,copy   ) NSString                 * mFlight;

/**
 *  舱位
 */
@property (nonatomic,copy   ) NSString                 * mCabin;
/**
 * 舱位等级1头等舱  2经济舱  3商务舱
 */
@property (nonatomic,copy   ) NSString                 * mgrade ;

/**
 * 预定时间
 */
@property (nonatomic,copy   ) NSString                 * mBookTime;

/**
 * 总票价
 */
@property (nonatomic,copy   ) NSNumber                 * mTicketPrice ;

/**
 * 预定状态
 */
@property (nonatomic,copy   ) NSString                 * mBookStatus;
/**
 *  起飞城市
 */
@property (nonatomic,copy   ) NSString                 * mOrgCity;
/**
 *  到达城市
 */
@property (nonatomic,copy   ) NSString                 * mDstCity;
/**
 *  是否经停
 */
@property (nonatomic,copy   ) NSNumber                  * mStop;
/**
 *  乘客列表
 */
@property(nonatomic, copy) NSArray *passengers;
@end

@interface SLOrderDetialModel: MTLModel<MTLJSONSerializing>
/**
 *  出发时间
 */
@property (nonatomic,copy   ) NSString                 * mDepTime;

/**
 *  到达时间
 */
@property (nonatomic,copy   ) NSString                 * mArrTime;
/**
 *  出发机场
 */
@property (nonatomic,copy   ) NSString                 * mDepAirport;

/**
 *  到达机场
 */
@property (nonatomic,copy   ) NSString                 * mArrAirport;
/**
 *  出发机场
 */
@property (nonatomic,copy   ) NSString                 * mDepTerm;

/**
 *  到达机场
 */
@property (nonatomic,copy   ) NSString                 * mArrTerm;

/**
 *  航班日期
 */
@property (nonatomic,copy   ) NSString                 * mFlightDate;

/**
 *  总飞行时间（单位：秒）
 */
@property (nonatomic,copy   ) NSNumber                 * mFlightTime;
/**
 *  航司名称
 */
@property (nonatomic,copy   ) NSString                 * mAirline;

/**
 *  折扣
 */
@property (nonatomic,copy   ) NSNumber                 * mDiscount;

/**
 *  航班号
 */
@property (nonatomic,copy   ) NSString                 * mFlight;

/**
 *  舱位
 */
@property (nonatomic,copy   ) NSString                 * mCabin;
/**
 * 舱位等级1头等舱  2经济舱  3商务舱
 */
@property (nonatomic,copy   ) NSString                 * mgrade ;

/**
 * 预定时间
 */
@property (nonatomic,copy   ) NSString                 * mBookTime;

/**
 * 总票价
 */
@property (nonatomic,copy   ) NSNumber                 * mTicketPrice ;

/**
 * 预定状态
 */
@property (nonatomic,copy   ) NSNumber                 * mBookStatus;
/**
 * 预定状态
 */
@property (nonatomic,copy   ) NSString                 * mOrderNo;

/**
 * 机建
 */
@property (nonatomic,copy   ) NSNumber                 * mMcCost;

/**
 *  退改签描述
 */
@property (nonatomic,copy   ) NSString                 * mTgqDesc;

/**
 * 票号
 */
@property (nonatomic,copy   ) NSString                 * mTicketNum;
/**
 * 出行目的
 */
@property (nonatomic,copy   ) NSString                 * mTripPurpose;
/**
 * 联系人名称
 */
@property (nonatomic,copy   ) NSString                 * mContacts;

/**
 * 联系人电话
 */
@property (nonatomic,copy   ) NSString                 * mMobile;
/**
 * 配送地址
 */
@property (nonatomic,copy   ) NSString                 * mDistribution;
/**
 * 配送人电话
 */
@property (nonatomic,copy   ) NSString                 * mDmobile;
/**
 * 配送人电话
 */
@property (nonatomic,copy   ) NSString                 * mDname;
/**
 *  出行目的
 */
@property (nonatomic,copy   ) NSString                 * mReason;

/**
 *  乘客列表
 */
@property(nonatomic, copy) NSArray *passengers;

/**
 *  保险
 */
@property(nonatomic, copy) NSArray *insurances;

@property(nonatomic, copy) NSArray *illegalReasons;

@property (nonatomic,copy   ) NSString                 * mCreateTime;

@property (nonatomic,copy   ) NSString                 * mPaytimeout;
@end


@interface SLHotWifiList: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSNumber                 * mPid;
@property (nonatomic,copy   ) NSString                 * mName;
@property (nonatomic,copy   ) NSNumber                 * mPrice;
@property (nonatomic,copy   ) NSString                 * mImageUrl;
@end

@interface SLWifiListModel: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSNumber                 * mPid;
@property (nonatomic,copy   ) NSString                 * mName;
@property (nonatomic,copy   ) NSNumber                 * mPrice;
@property (nonatomic,copy   ) NSString                 * mObtainType;
@property (nonatomic,copy   ) NSString                 * mNetwork;
@property (nonatomic,copy   ) NSNumber                 * mInday;
@property (nonatomic,copy   ) NSString                 * mRange;
@property (nonatomic,copy   ) NSString                 * mDate;
@end

@interface SLHotWifiDetial: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSNumber                 * mPid;
@property (nonatomic,copy   ) NSString                 * mName;
@property (nonatomic,copy   ) NSNumber                 * mPrice;
@property (nonatomic,copy   ) NSString                 * mObtainType;
@property (nonatomic,copy   ) NSString                 * mperformance;
@property (nonatomic,copy   ) NSString                 * mNetwork;
@property (nonatomic,copy   ) NSNumber                 * mInday;
@property (nonatomic,copy   ) NSString                 * mRange;
@property (nonatomic,copy   ) NSString                 * mDate;
@property (nonatomic,copy   ) NSNumber                 * mDeposit;
@property (nonatomic,copy   ) NSString                 * mParts;
@property (nonatomic,copy   ) NSArray                  * mPlaces;
@end

@interface SLWifiOderListModel: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSString                 * mOrderNo;
@property (nonatomic,copy   ) NSString                 * mName;
@property (nonatomic,copy   ) NSNumber                 * mPrice;
@property (nonatomic,copy   ) NSString                 * mUseDate;
@property (nonatomic,copy   ) NSNumber                 * mStatus;
@property (nonatomic,copy   ) NSString                 * mStatusDesc;
@property (nonatomic,copy   ) NSNumber                 * mTripType;
@property (nonatomic,copy   ) NSString                 * mTripTypeDesc;
@property (nonatomic,copy   ) NSString                 * mCreateTime;
@property (nonatomic,copy   ) NSNumber                 * mCount;
@end

@interface SLWifiOderDetial: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSString                 * mOrderNo;
@property (nonatomic,copy   ) NSString                 * mName;
@property (nonatomic,copy   ) NSNumber                 * mPrice;
@property (nonatomic,copy   ) NSString                 * mUseDate;
@property (nonatomic,copy   ) NSString                 * mUseEndDate;
@property (nonatomic,copy   ) NSNumber                 * mStatus;
@property (nonatomic,copy   ) NSString                 * mStatusDesc;
@property (nonatomic,copy   ) NSNumber                 * mDeposit;
@property (nonatomic,copy   ) NSString                 * mDepositMode;
@property (nonatomic,copy   ) NSNumber                 * mCount;
@property (nonatomic,copy   ) NSString                 * mReturnAddress;
@property (nonatomic,copy   ) NSString                 * mTakeAddress;
@property (nonatomic,copy   ) NSString                 * mWorktime;
@property (nonatomic,copy   ) NSString                 * mContactName;
@property (nonatomic,copy   ) NSString                 * mContactMobile;
@property (nonatomic,copy   ) NSString                 * mContactMobile1;
@property (nonatomic,copy   ) NSString                 * mReserveDate;
@property (nonatomic,copy   ) NSString                 * mPayType;
@property (nonatomic,copy   ) NSString                 * mPayTime;
@property (nonatomic,copy   ) NSString                 * mAmount;
@property (nonatomic,copy   ) NSNumber                 * mCancelCount;
@property (nonatomic,copy   ) NSString                 * mCancelAmount;
@property (nonatomic,copy   ) NSString                 * mCancelTime;
@property (nonatomic,copy   ) NSString                 * mCharge;
@end
@interface SLTTListModel: MTLModel<MTLJSONSerializing>
@property (nonatomic,copy   ) NSString                 * mdepTime;
@property (nonatomic,copy   ) NSString                 * marrTime;
@property (nonatomic,copy   ) NSString                 * mdepStation;
@property (nonatomic,copy   ) NSString                 * marrStation;
@property (nonatomic,copy   ) NSString                 * mtrainDate;
@property (nonatomic,copy   ) NSString                 * mtrainCode;
@property (nonatomic,copy   ) NSString                 * mcostTime;
@property (nonatomic,copy   ) NSString                 * mtype;
@property (nonatomic,copy   ) NSString                 * mminPrice;
@property (nonatomic,copy   ) NSArray                  * mseats;
@end;
