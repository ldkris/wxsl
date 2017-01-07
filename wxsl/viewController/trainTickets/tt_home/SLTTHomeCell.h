//
//  SLTTHomeCell.h
//  wxsl
//
//  Created by 刘冬 on 2016/10/25.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SLTTHomeCellDelegate;
@interface SLTTHomeCell : UITableViewCell
@property(nonatomic,assign)id<SLTTHomeCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *btn_backTime;
@property (weak, nonatomic) IBOutlet UIButton *btn_formTime;

@property (weak, nonatomic) IBOutlet UIButton *btn_formCity;
@property (weak, nonatomic) IBOutlet UIButton *btn_toCity;
@property (weak, nonatomic) IBOutlet UIButton *btn_lookUpBtn;

-(void)loadCityInfo:(NSDictionary *)formCity toCity:(NSDictionary *)toCity;
@end
@protocol SLTTHomeCellDelegate <NSObject>

-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickLookUpBtn:(UIButton *)sender;
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclikFromCityBtn:(UIButton *)sender;
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclicktoCityBtn:(UIButton *)sender;
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickfromTimeBtn:(UIButton *)sender;
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickToTimeBtn:(UIButton *)sender;
-(void)SLTTHomeCell:(SLTTHomeCell *)cell onclickChangeBtn:(UIButton *)sender;

@end
