//
//  AlarmNewCellTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/4.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "AlarmNewCellTableViewCell.h"

@implementation AlarmNewCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)dic{
    myDic = [dic copy];
    nameLabel.text = dic[@"name"];
    
    NSString *value =dic[@"value"] ;
    if ([dic[@"value"] length] > 500) {
        value = [[value substringToIndex:500] stringByAppendingString:@"..."];
    }
    
    descLabel0.text = [value isEqualToString:@"(null)"]?@"":value;
 
    
    
}

- (IBAction)delClick:(id)sender {
    if (self.leftClickBlock) {
        self.leftClickBlock(myDic);
    }
}

@end
