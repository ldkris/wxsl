//
//  SLWifiDtailCell_three.m
//  wxsl
//
//  Created by 刘冬 on 2016/10/5.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "SLWifiDtailCell_three.h"

@implementation SLWifiDtailCell_three

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString *htmlString = @"<p><span style=color:#CCCCCC>流量公平原则</span></p>为了保证您全程享受高速网速，请关闭软件备份，避免长时间观看电影等，短时间内用过过大流量将被当地运营商减速或断网<br>";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    self.lab_content.attributedText = attrStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCellInfoWithModel:(SLHotWifiDetial *)model{
    if (model == nil) {
        return;
    }
    NSString *htmlString = [NSString stringWithFormat:@"<span style=color:#CCCCCC>网络类型</span> %@<br> <br><span style=color:#CCCCCC>机器性能</span> %@<br><br><span style=color:#CCCCCC>标准配置</span> %@<br><br><span style=color:#CCCCCC>获取方式</span> %@<br>",model.mNetwork,model.mperformance,model.mParts,model.mObtainType];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:0];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];

     self.lab_content.attributedText = attrStr;
}

-(void)loadCellAirInfoWithModel:(NSArray *)model{
    if (model == nil) {
        return;
    }
    NSMutableString * str = [NSMutableString string];
    for (NSDictionary *tempAirDic in model) {
        if ([model indexOfObject:tempAirDic] == 0) {
             [str appendFormat:@"%@",tempAirDic[@"name"]];
        }else{
            [str appendFormat:@",%@",tempAirDic[@"name"]];
        }
    }
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    self.lab_content.attributedText = attrStr;
}
-(void)loadCellFYInfoWithModel{
  
    NSString *htmlString = @"<p><span style=color:#99cccc>费用明细 = 租金 + 押金</span></p><span style=color:#99cccc>● 租金</span><br>租金=每日单价 x 出行天数 x 台数<p> 出行天数为WiFi设备领取日到归还日之间的天数差（含领取日、归还日)</p> <span style=color:#99cccc>● 押金</span><br> <p>押金仅支持在机场领取设备的柜台支付，归还设备时退还押金。 WiFi设备主体丢失将扣除全部押金，部分零件丢失按柜台标准扣除相应费用</p> <span style=color:#99cccc>● 续租费</span><br>领取设备后如需续租，请在原定归还日期前一天16:00点前致电客 服023-63634555，由客服为您确认安排续租事宜；过时客服将无法申请续租。如未按时归还设备，将柜台价收取滞纳金。";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    self.lab_content.attributedText = attrStr;
}
-(void)loadCellTGQInfoWithModel{
    
    NSString *htmlString = @"该产品支持取消。如需取消，请在WiFi订单页面中提交申请。<br>使用日期前1天12：00（含）之前申请取消，不收取违约金。<br>使用日期前1天12：00之后申请取消，收取20元/份违约金。<br>如需改期，请申请取消后重新预订。<br>";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.length)];
    
    self.lab_content.attributedText = attrStr;
}
@end
