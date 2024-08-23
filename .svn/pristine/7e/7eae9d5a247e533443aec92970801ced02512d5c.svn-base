//
//  GGFilesTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "GGFilesTableViewCell.h"

@implementation GGFilesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    btn.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)data{
    dataDic = [data copy];
    titleLabel.text = data[@"name"];

}

- (IBAction)click:(id)sender {
    if (self.attClick) {
        self.attClick(dataDic);
    }
}
@end
