//
//  CheckLocationCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "CheckLocationCell.h"

@implementation CheckLocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    imageV.image = [imageV.image imageChangeColor:[UIColor lightGrayColor]];
    
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    nameLabel.textColor =  COLOR_TABLE_DES;
    
    // Initialization code
    
    [button setTitle:@"全部完成" forState:UIControlStateNormal];
    [button setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    button.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    button.backgroundColor = [UIColor grayColor];
    
    button.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    button.clipsToBounds = YES;

    button.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
    button.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    button.layer.shadowOpacity = 1;
    // 设置阴影半径
    button.layer.shadowRadius = 1;
   
    dotView = [[DottedLineView alloc] initWithFrame:CGRectMake(10+15 -1, 0, 2, 66)];
    dotView.backgroundColor = [UIColor clearColor];
    [self addSubview:dotView];
    [self sendSubviewToBack:dotView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


    
- (void)setData:(NSDictionary*)data andLocation_location:(Location_location)location andButtonClick:(nonnull NormalBlock)block;
{
    myBlock = block;
    nameLabel.text = data[@"name"];
    if ([data[@"checkFlag"] intValue] == 0) {
        //未完成
        [button setTitle:@"开始检查" forState:UIControlStateNormal];
        button.backgroundColor = MAIN_TINIT_COLOR;
    }else{
        [button setTitle:@"继续检查" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor grayColor];
    }
    
    if (location == Location_location_First) {
        dotView.frame = CGRectMake(24, 30, 2, 66-30);
    }else if (location == Location_location_Last)
    {
        dotView.frame = CGRectMake(24, 0, 2, 20);
    }else{
        dotView.frame = CGRectMake(24, 0, 2, 66);
    }
    [dotView setNeedsDisplay];
}
- (IBAction)buttonClick:(id)sender{
    myBlock(sender);
}

@end
