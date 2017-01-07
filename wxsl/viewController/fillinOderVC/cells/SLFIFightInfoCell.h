//
//  SLFIFightInfoCell.h
//  wxsl
//
//  Created by 刘冬 on 16/7/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLFIFightInfoCell : UITableViewCell
/**
 *  单吃
 *
 *  @param model
 *  @param FModel
 */
-(void)loadCellInfo:(SLRBDModel *)model withFightModel:(SLCheckFightModel *)FModel;
/**
 *  往返
 *
 *  @param model
 *  @param FModel
 *  @param wfmodel
 *  @param wFModel 
 */
-(void)loadCellInfo:(SLRBDModel *)model withFightModel:(SLCheckFightModel *)FModel WFinfo:(SLRBDModel *)wfmodel withWFFightModel:(SLCheckFightModel *)wFModel;
@end
