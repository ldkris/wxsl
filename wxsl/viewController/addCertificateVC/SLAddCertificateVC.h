//
//  SLAddCertificateVC.h
//  wxsl
//
//  Created by 刘冬 on 16/6/29.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^chooseDate)(NSDictionary*IDInfoDIc);
@interface SLAddCertificateVC : BaseViewController

@property(nonatomic,copy) chooseDate mIDInfoDIcBlock;

-(void)backIdInfo:(chooseDate)block;
@end
