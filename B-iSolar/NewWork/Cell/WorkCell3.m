//
//  HomeTableViewMyStationCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "WorkCell3.h"

@implementation WorkCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

//    des0.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
//    des1.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    
//    self.numOfStationLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
//    self.capacityLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(notificationSegChanged:) name:NOTIFICATION_SEG_CHANGED object:nil];

//    img1.image = [img1.image imageChangeColor:MAIN_TINIT_COLOR];
//    img2.image = [img2.image imageChangeColor:MAIN_TINIT_COLOR];
    // Initialization code
}
- (void)notificationSegChanged:(NSNotification*)noti{
    if (_myData){
        int index = [noti.object intValue];
        switch (index) {
            case 0:
                {
                    self.capacityLabel3.text = TOSTRING(_myData.data[@"today_tree"]);
                    self.capacityLabel2.text = TOSTRING(_myData.data[@"today_carbon"]);
                }
                break;
            case 1:
            {
                self.capacityLabel3.text = TOSTRING(_myData.data[@"month_tree"]);
                self.capacityLabel2.text = TOSTRING(_myData.data[@"month_carbon"]);
            }
            break;
            case 2:
            {
                self.capacityLabel3.text = TOSTRING(_myData.data[@"year_tree"]);
                self.capacityLabel2.text = TOSTRING(_myData.data[@"year_carbon"]);
            }
            break;
            case 3:
            {
                self.capacityLabel3.text = TOSTRING(_myData.data[@"total_tree"]);
                self.capacityLabel2.text = TOSTRING(_myData.data[@"total_carbon"]);
            }
            break;
                
            default:
                break;
        }
    }
}

- (void)setData:(BResponseModel*)model{
    
    if (model) {
        _myData = model;
        self.numOfStationLabel.text = TOSTRING(model.data[@"station_count"]);
        self.capacityLabel.text = TOSTRING(model.data[@"all_capacity"]);
        self.capacityLabel3.text = TOSTRING(model.data[@"today_tree"]);
        self.capacityLabel2.text = TOSTRING(model.data[@"today_carbon"]);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
