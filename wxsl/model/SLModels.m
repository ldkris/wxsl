//
//  SLModels.m
//  wxsl
//
//  Created by 刘冬 on 16/7/15.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLModels.h"

@implementation SLModels
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return nil;
}
@end

@implementation SLUserInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mChineseName": @"zname",
             @"mEnglishName": @"ename",
             @"mHeadimgurl": @"headimgurl",
             @"mEmail": @"email",
             @"mSex": @"sex",
             @"mCompanyName": @"company",
             @"mDid": @"did",
             @"mDName": @"dname",
             @"mDocTypes": @"docTypes",
             @"mBirthday":@"birthday",
             @"mScore":@"score"
             };
}
@end

@implementation SLCheckFightModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mFormTime": @"depTime",
             @"mArriveTime": @"arrTime",
             @"mFormAirport": @"depAirport",
             @"mArriveAirport": @"arrAirport",
             @"mPrice": @"minPrice",
             @"mUseTime": @"flightTime",
             @"mAirlineName": @"airline",
             @"mCabinfos": @"cabins",
             @"mFlightDate": @"flightDate",
             @"mAirCode":@"air",
             @"mAirModel":@"model",
             @"mformTerm":@"depTerm",
             @"mformAirportCode":@"depAirportCode",
             @"marrTerm":@"arrTerm",
             @"marrAirportCode":@"arrAirportCode",
             @"mAirlines":@"airlines",
             @"mAirports":@"airports",
             @"mAirrax":@"mcCost",
             @"mFlightno":@"flightno",
             @"mStop":@"stop",
             @"mShare":@"share",
             };
}
@end

@implementation SLRBDModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mRBDName": @"name",
             @"mRBDCode": @"code",
             @"mRBDDiscount": @"discount",
             @"mRBDPrice": @"price",
             @"mRBDSalePrice": @"salePrice",
             @"mRBDRefund": @"refund",
             @"mRBDCdate": @"cdate",
             @"mRBDTransfer": @"transfer",
             @"mSeat":@"seat"
             };
}
@end


@implementation SLPassengerModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mName":@"name",
             @"mID":@"no",
             @"mDname":@"dname",
             @"mIdcard":@"idcard",
             @"mIDType":@"idtype",
             @"mAudit":@"audit",
             @"mPolicy":@"policy",
             @"mPolicyId":@"policyId",
             @"mDID":@"did",
             };
}

@end

@implementation SLContactModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mName":@"name",
             @"mID":@"no",
             @"mMobile":@"mobile",
             };
}

@end


@implementation SLAddressModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mName":@"name",
             @"mID":@"no",
             @"mMobile":@"contact",
             @"mAddress":@"address",
             @"mShipMethod":@"shipMethod"
             };
}

@end

@implementation SLOrderModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mOderId":@"orderId",
             @"mDepTime":@"depTime",
             @"mArrTime":@"arrTime",
             @"mDepAirport":@"depAirport",
             @"mArrAirport":@"arrAirport",
             @"mDepTerm":@"depTerm",
             @"mArrTerm":@"arrTerm",
             @"mFlightDate":@"flightDate",
             @"mFlightTime":@"flightTime",
             @"mAirline":@"airline",
             @"mAirlineNo":@"airlineNo",
             @"mFlight":@"flight",
             @"mCabin":@"cabin",
             @"mBookTime":@"bookTime",
             @"mgrade":@"grade",
             @"mFlight":@"address",
             @"mTicketPrice":@"ticketPrice",
             @"mBookStatus":@"bookStatus",
             @"passengers":@"passengers",
             @"mDstCity":@"dstCity",
             @"mOrgCity":@"orgCity",
             @"mStop":@"stop"
             };
}
@end


@implementation SLOrderDetialModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"mOrderNo":@"orderNo",
             @"mDepTime":@"depTime",
             @"mArrTime":@"arrTime",
             @"mDepAirport":@"depAirport",
             @"mArrAirport":@"arrAirport",
             @"mDepTerm":@"depTerm",
             @"mArrTerm":@"arrTerm",
             @"mFlightDate":@"flightDate",
             @"mFlightTime":@"flightTime",
             @"mAirline":@"airline",
             @"mDiscount":@"discount",
             @"mFlight":@"flight",
             @"mCabin":@"cabin",
             @"mBookTime":@"bookTime",
             @"mgrade":@"grade",
             @"mFlight":@"address",
             @"mTicketPrice":@"ticketPrice",
             @"mBookStatus":@"bookStatus",
             @"passengers":@"passengers",
             @"mDiscount":@"discount",
             @"mMcCost":@"mcCost",
             @"mTgqDesc":@"tgqDesc",
             @"mTicketNum":@"ticketNum",
             @"mTripPurpose":@"reason",
             @"mContacts":@"contacts",
             @"mMobile":@"mobile",
             @"mDistribution":@"distribution",
             @"mDmobile":@"dmobile",
             @"mDname":@"dname",
             @"insurances":@"insurances",
             @"mReason":@"reason",
             @"illegalReasons":@"illegalReasons",
             @"mCreateTime":@"createTime",
             @"mPaytimeout":@"paytimeout"
             };
}
@end

@implementation SLHotWifiList
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mPid":@"productid",
             @"mName":@"name",
             @"mPrice":@"price",
             @"mImageUrl":@"pic",
             };
}
@end

@implementation SLWifiListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mPid":@"productid",
             @"mName":@"name",
             @"mPrice":@"price",
             @"mObtainType":@"obtainType",
             @"mNetwork":@"network",
             @"mInday":@"minday",
             @"mRange":@"range",
             @"mDate":@"useDate"
             };
}
@end

@implementation SLHotWifiDetial
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mPid":@"product.productid",
             @"mName":@"product.name",
             @"mPrice":@"product.price",
             @"mObtainType":@"product.obtainType",
             @"mNetwork":@"product.network",
             @"mInday":@"product.minday",
             @"mRange":@"product.range",
             @"mDate":@"product.date",
             @"mDeposit":@"product.deposit",
             @"mParts":@"product.parts",
             @"mperformance":@"product.performance",
             @"mPlaces":@"places"
             };
}
@end
@implementation SLWifiOderListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mOrderNo":@"orderNo",
             @"mName":@"productName",
             @"mPrice":@"price",
             @"mUseDate":@"useDate",
             @"mStatus":@"status",
             @"mStatusDesc":@"statusDesc",
             @"mTripType":@"tripType",
             @"mTripTypeDesc":@"tripTypeDesc",
             @"mCreateTime":@"createTime",
             @"mCount":@"count"
             };
}
@end

@implementation SLWifiOderDetial
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mOrderNo":@"orderNo",
             @"mName":@"productName",
             @"mPrice":@"price",
             @"mUseDate":@"useDate",
             @"mStatus":@"status",
             @"mStatusDesc":@"statusDesc",
             @"mUseEndDate":@"useEndDate",
             @"mDeposit":@"deposit",
             @"mDepositMode":@"depositMode",
             @"mCount":@"count",
             @"mReturnAddress":@"returnAddress",
             @"mTakeAddress":@"takeAddress",
             @"mWorktime":@"worktime",
             @"mContactMobile":@"createTime",
             @"mContactName":@"contactName",
             @"mContactMobile":@"contactMobile",
             @"mReserveDate":@"reserveDate",
             @"mPayType":@"payType",
             @"mPayTime":@"payTime",
             @"mContactMobile1":@"contactMobile",
             @"mAmount":@"amount",
             @"mCancelCount":@"cancelCount",
             @"mCancelAmount":@"cancelAmount",
             @"mCancelTime":@"cancelTime",
             @"mCharge":@"charge"
             };
}
@end
@implementation SLTTListModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"mdepTime":@"depTime",
             @"marrTime":@"arrTime",
             @"mdepStation":@"depStation",
             @"marrStation":@"arrStation",
             @"mtrainDate":@"trainDate",
             @"mtrainCode":@"trainCode",
             @"mtype":@"type",
             @"mminPrice":@"minPrice",
             @"mseats":@"seats",
             @"mtrainCode":@"trainCode",
             @"mcostTime":@"costTime"
             };
}
@end
