//
//  SLSimpleInterest.m
//  wxsl
//
//  Created by 刘冬 on 16/8/12.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLSimpleInterest.h"

@implementation SLSimpleInterest
+(SLSimpleInterest *)shareNetWork{
    static SLSimpleInterest *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SLSimpleInterest alloc]init];
    });
    return _sharedClient;
}
-(instancetype)init{
    self = [super init];

    if (self) {
        _mTrType = 10;
    }
    
    return self;
}
@end
