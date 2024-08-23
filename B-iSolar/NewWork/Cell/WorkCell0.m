//
//  HomeTableViewMyStationCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "WorkCell0.h"

@implementation WorkCell0

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (void)setData:(BResponseModel*)model   andBlock:(NormalBlock)block{
    myBlock = block;
    if (model) {
        _myData = model;
        self.numOfStationLabel.text = TOSTRING(model.data[@"asigneeMy"]);
        self.capacityLabel.text = TOSTRING(model.data[@"noStart"]);
        self.capacityLabel2.text = TOSTRING(model.data[@"onDeal"]);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)area0Click:(id)sender {
    NSLog(@"0 click");
    myBlock(@(0));
}

- (IBAction)area1Click:(id)sender {
    NSLog(@"1 click");
    myBlock(@(1));
}
- (IBAction)area2Click:(id)sender {
    NSLog(@"2 click");
    myBlock(@(2));
}


@end
