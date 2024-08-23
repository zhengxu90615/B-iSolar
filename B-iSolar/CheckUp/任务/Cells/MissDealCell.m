//
//  MissDealCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/28.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "MissDealCell.h"

@implementation MissDealCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    contentTextF.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    
    nameLabel.textColor = COLOR_TABLE_DES;
    contentTextF.textColor = COLOR_TABLE_TITLE;
    contentTextF.delegate = self;
}
- (void)setContentX:(NSString *)x
{
    contentTextF.text = x;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setDataAndName:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2{

    myBlock = block;
    myBlock2 = block2;
    canEd = canEdit;
    nameLabel.text = dic[@"name"];
    if ( [nameLabel.text isEqualToString:@"进度百分比"] || [nameLabel.text isEqualToString:@"完成进度"] ) {
        rightCon.constant = 50;
        perLabbel.hidden= NO;
        perLabbel.text = [NSString stringWithFormat:@"(%@-100)%%",dic[@"rate1"]];
        contentTextF.keyboardType = UIKeyboardTypeNumberPad;
    }else
    {
        rightCon.constant = 10;
        perLabbel.hidden= YES;
        contentTextF.keyboardType = UIKeyboardTypeDefault;
    }
    
    contentTextF.text = dic[@"value"];
    contentTextF.placeholder = dic[@"placeholder"];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (![nameLabel.text isEqualToString:@"进度百分比"] &&   ![nameLabel.text isEqualToString:@"完成进度"]) {
        
        if (myBlock2) {
            myBlock2(nil);
        }
        if ([contentTextF.placeholder hasPrefix:@"请输入"]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (myBlock) {
        myBlock(textField.text);
    }
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
