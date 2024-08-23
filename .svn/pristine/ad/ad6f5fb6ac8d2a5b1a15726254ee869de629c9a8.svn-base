//
//  NoticeDetailTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "NoticeDetailTableViewCell.h"

@implementation NoticeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    bgView.layer.cornerRadius = BUTTON_CORNERRADIUS;    // Initialization code
    
    bgView.layer.shadowColor = MAIN_TINIT_COLOR.CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,0);
    // 设置阴影透明度
    bgView.layer.shadowOpacity = 1;
    // 设置阴影半径
    bgView.layer.shadowRadius = 1;
    bgView.clipsToBounds = NO;
    
    bgView.backgroundColor = [UIColor whiteColor];
    titleLabel.textColor =  COLOR_TABLE_TITLE;
    fujianLabel.textColor = contentLabel.textColor = dateLabel.textColor = COLOR_TABLE_DES;
    line0.backgroundColor = COLOR_TABLE_SEP;
    
    titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    fujianLabel.font = contentLabel.font = dateLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)data{
    titleLabel.text = data[@"title"];
    dateLabel.text = [NSString stringWithFormat:@"发布时间：%@",data[@"releaseTime"]];
    contentLabel.text = data[@"content"];
    
    
    NSArray *fileArr = data[@"attachementsList"];
    if (fileArr.count>0) {
        fujianLabel.hidden = NO;
        
        NSString *desc =  data[@"content"];
        CGFloat width = MAINSCREENWIDTH-5*4;
        
        UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
        _atest.numberOfLines = 0;
        _atest.text = desc;
        _atest.lineBreakMode = NSLineBreakByWordWrapping;
        _atest.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
        CGSize labelsize = [_atest sizeThatFits:baseSize];
        for (int i = 0; i<fileArr.count; i++) {
            UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(5, 100 +labelsize.height + i*38, MAINSCREENWIDTH-20, 30)];
            v.backgroundColor = [UIColor clearColor];
            v.textColor = MAIN_TINIT_COLOR;
            v.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
            v.text = fileArr[i][@"name"];
            
            
            UIButton *button = [[UIButton alloc] initWithFrame:v.frame];
            button.tag = i;
            [button addTarget:self action:@selector(attClick:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            [bgView addSubview:v];
        }
    }else{
        fujianLabel.hidden = YES;
    }
}

- (void)attClick:(UIButton*)btn
{
    if (self.attClick) {
        self.attClick(btn.tag);
    }
}
@end
