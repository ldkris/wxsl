//
//  SLCheckFlightInfoView.m
//  wxsl
//
//  Created by 刘冬 on 16/7/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLCheckFlightInfoView.h"
@interface SLCheckFlightInfoView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet UIView *mContentView;
@property(nonatomic,retain)NSArray *mDataSoure;

@property(nonatomic,retain)NSIndexPath *mSelectIndexs;
@end
@implementation SLCheckFlightInfoView

-(void)awakeFromNib{
    [super awakeFromNib];
    //_selectMeum = 0;
    
    self.mInfoTableView.delegate = self;
    self.mInfoTableView.dataSource = self;
    [self.mInfoTableView setBackgroundColor:SL_GRAY];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.mInfoTableView.tableFooterView = [UIView new];
}

-(void)show{
    
    //LDLOG(@"%ld",(long)_mSelectIndexs.row);
    
    [self showDialogView:self.mContentView];
    [self.mInfoTableView reloadData];
}
#pragma mark getter
-(NSArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = @[@"00:00--06:00",@"06:00--12:00",@"12:00--18:00",@"18:00--24:00"];
    }
    return _mDataSoure;
}
#pragma mark private
-(void)showDialogView:(UIView *) view
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:300.00f];;
    animation.toValue=[NSNumber numberWithFloat:0.0f];;
    animation.duration=0.2;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
    
}
#pragma mark public
-(void)dismissDialogView:(UIView *)view
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];;
    animation.toValue=[NSNumber numberWithFloat:300.00f];;
    animation.duration=0.2;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
#pragma mark event response
//不限
- (void)onclickBXbtn:(UIButton *)sender {
    [self dismissDialogView:self.mContentView];
}
- (IBAction)onclickCancelBtn:(UIButton *)sender {
    [self dismissDialogView:self.mContentView];
}
//确定
- (IBAction)onclickComfirBtn:(UIButton *)sender {
    [self dismissDialogView:self.mContentView];
}
//排除经停
- (IBAction)onclickStopsBtn:(UIButton *)sender {
    [self dismissDialogView:self.mContentView];
    if (_delegate && [_delegate respondsToSelector:@selector(SLCheckFlightInfoView:onclickStopsBtn:)]) {
        [_delegate SLCheckFlightInfoView:self onclickStopsBtn:sender];
        
    }
}
//隐藏航班
- (IBAction)onclickHideFightBtn:(UIButton *)sender {
    [self dismissDialogView:self.mContentView];
    if (_delegate && [_delegate respondsToSelector:@selector(SLCheckFlightInfoView:onclickStopsBtn:)]) {
        [_delegate SLCheckFlightInfoView:self onclickHideFightBtn:sender];
        
    }
}
- (IBAction)onclickMenuBtn:(UIButton *)sender {
   
    for (int i = 0; i<15; i++) {
        UIButton *msender = (UIButton *)[self viewWithTag:i];
        [msender setBackgroundColor:SL_GRAY];
    }
    
    self.mSelectIndexs = nil;
    
    switch (sender.tag) {
        case 10:
            //起飞时间
            [sender setBackgroundColor:[UIColor whiteColor]];
            self.ENUM_ActionType = ENUM_ActionTypeTime;
            
            self.mDataSoure = @[@"00:00--06:00",@"06:00--12:00",@"12:00--18:00",@"18:00--24:00"];

            break;
        case 11:{
            //机场
            [sender setBackgroundColor:[UIColor whiteColor]];
            self.ENUM_ActionType = ENUM_ActionTypeAirport;
            
            NSMutableArray *mQF = [NSMutableArray array];
            NSMutableArray *mJL = [NSMutableArray array];
            
            for (NSDictionary *temp in self.mAirports) {
                if ([temp[@"type"] isEqual:@"1"]) {
                    [mQF addObject:temp];
                }else{
                    [mJL addObject:temp];
                }
            }
            
            self.mDataSoure = @[mQF,mJL];
            break;}
        case 12:
            //机型
            [sender setBackgroundColor:[UIColor whiteColor]];
            self.ENUM_ActionType = ENUM_ActionTypeFlyType;
            
            self.mDataSoure = @[@"大机型",@"中机型",@"小机型"];
            break;
        case 13:
            //舱位
            [sender setBackgroundColor:[UIColor whiteColor]];
            self.ENUM_ActionType = ENUM_ActionTypeRBD;
            self.mDataSoure = @[@"经济舱",@"公务舱/头等舱"];
            break;
            
        case 14:
            //航空公司
            [sender setBackgroundColor:[UIColor whiteColor]];
            self.ENUM_ActionType = ENUM_ActionTypeAirline;
            self.mDataSoure = self.mAirlines;
            break;
            
        default:
            break;
    }
    
    [self.mInfoTableView reloadData];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
}

#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        //机场
        return 2;
    }else{
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        //机场
        return [self.mDataSoure[section] count] + 1;
    }
    return self.mDataSoure.count + 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        //机场
        return 30.0f;
    }else{
        return 0.0001f;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        UIView *mHeadView = [UIView new];
        [mHeadView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *mLabel = [[UILabel alloc]init];
        [mLabel setFont:DEFAULT_FONT(13)];
        [mLabel setTextColor:SL_GRAY_Hard];
        [mHeadView addSubview:mLabel];
        [mLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.top.mas_equalTo(7);
        }];
        
        if (section == 0) {
            mLabel.text = @"起飞机场";
        }else{
            mLabel.text = @"落地机场机场";
        }
        
        return mHeadView;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell.textLabel setTextColor:SL_GRAY_BLACK];
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIButton *mAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [mAddBtn setFrame:CGRectMake(0, 0, 20, 18)];
    [mAddBtn addTarget:self action:@selector(onclickBXbtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = mAddBtn;
    
    if (self.mSelectIndexs.section == indexPath.section && self.mSelectIndexs.row == indexPath.row && self.mSelectIndexs) {
        [mAddBtn setBackgroundImage:[UIImage imageNamed:@"hotel_icon_fan_select"] forState:UIControlStateNormal];
    }else{
        if(self.mSelectIndexs == nil){
            if (indexPath.row == 0) {
            [mAddBtn setBackgroundImage:[UIImage imageNamed:@"hotel_icon_fan_select"] forState:UIControlStateNormal];
            }
        }else{
          [mAddBtn setBackgroundImage:[UIImage imageNamed:@"hotel_icon_fan"] forState:UIControlStateNormal];
        }
    }
    
    if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        //机场
        if (indexPath.row == 0) {
            //不限
            cell.textLabel.text = @"不限";
            [cell.textLabel setTextColor:SL_BULE];
           
        }else{
          cell.textLabel.text = self.mDataSoure[indexPath.section][indexPath.row - 1][@"name"];
        }
    }else{
        if (indexPath.row == 0) {
            //不限
            cell.textLabel.text = @"不限";
            [cell.textLabel setTextColor:SL_BULE];
        }else{
            cell.imageView.image = nil;
            
            switch (self.ENUM_ActionType) {
                case ENUM_ActionTypeTime:
                    //起飞时间
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1];
                    cell.imageView.image = nil;
                    break;
                    
                case ENUM_ActionTypeFlyType:
                    //机型
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1];
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1];
                    cell.imageView.image = nil;
                    break;
                    
                case ENUM_ActionTypeRBD:
                    //舱位
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1];
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1];
                    cell.imageView.image = nil;
                    break;
                case ENUM_ActionTypeAirline:{
                    //航空公司
                    cell.textLabel.text = self.mDataSoure[indexPath.row - 1][@"name"];
                    if(indexPath.row >0){
                        NSString *path = [[NSBundle mainBundle] pathForResource:[self.mDataSoure[indexPath.row - 1][@"code"] lowercaseString] ofType:@"png"];
//                        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
                        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
                        UIImage *icon =[UIImage imageWithContentsOfFile:path];
                        CGSize itemSize = CGSizeMake(20, 20);
                        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
                        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                        [icon drawInRect:imageRect];
                        
                        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                    }
                    break;}
                    
                default:
                    break;
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    self.mSelectIndexs = indexPath;
    
    [self dismissDialogView:self.mContentView];
    
    if (_delegate && [_delegate respondsToSelector:@selector(SLCheckFlightInfoView:currentActionType:selctInfo:selectIndex:)]) {
        
        
        if (self.ENUM_ActionType == ENUM_ActionTypeAirport) {
        
            [_delegate SLCheckFlightInfoView:self currentActionType:self.ENUM_ActionType selctInfo:self.mDataSoure[indexPath.section] selectIndex:indexPath];
            
        }else{
            if (indexPath.row == 0) {
                [_delegate SLCheckFlightInfoView:self currentActionType:self.ENUM_ActionType selctInfo:self.mDataSoure[indexPath.row] selectIndex:indexPath];
            }else{
                [_delegate SLCheckFlightInfoView:self currentActionType:self.ENUM_ActionType selctInfo:self.mDataSoure[indexPath.row - 1] selectIndex:indexPath];
            }
        }
    }
}
#pragma mark UITouch
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissDialogView:self.mContentView];
}
@end
