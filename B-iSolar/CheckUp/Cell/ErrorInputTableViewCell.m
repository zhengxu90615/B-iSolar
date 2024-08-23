//
//  ErrorInputTableViewCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "ErrorInputTableViewCell.h"

@implementation ErrorInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
    inputText.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
    inputText.layer.borderWidth = .5f;
    inputText.layer.borderColor = COLOR_TABLE_SEP.CGColor;
    inputText.textColor = COLOR_TABLE_DES;
    inputText.delegate = self;
    nameLabel.textColor = COLOR_TABLE_TITLE;
    nameLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setData:(NSDictionary *)dic andBlock:(NormalBlock)block
{
    myBlock = block;
    nameLabel.text = @"问题描述";
    inputText.text = dic[@"note"];
}
- (void)setData:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2;
{
    myBlock = block;
    myBlock2 = block2;
    inputText.editable = canEdit;
    nameLabel.text = @"";
    inputText.text = dic[@"value"];
}

- (void)setDataAndName:(NSDictionary *)dic andCanEdit:(BOOL)canEdit andBlock:(NormalBlock)block andBlock2:(NormalBlock)block2;
{
    dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    myBlock = block;
    myBlock2 = block2;
    inputText.editable = canEdit;
    nameLabel.text = dic[@"name"];
    inputText.text = dic[@"value"];
    inputText.layer.borderWidth = 0;
    
    
    nameLabel.textColor =COLOR_TABLE_DES;
    inputText.textColor =COLOR_TABLE_TITLE;
    inputText.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    if (!dataDic[@"placeholder"]) {
        dataDic[@"placeholder"] = @"请输入处理描述";
    }
    
    if ([inputText.text isEqualToString:@""]) {
        inputText.text = dic[@"placeholder"]? dic[@"placeholder"]  :@"请输入处理描述";
        inputText.textColor =COLOR_TABLE_DES;
    }else{
        
    }
    
  
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if ([nameLabel.text isEqualToString:@"处理描述"] || [nameLabel.text isEqualToString:@"任务描述"] || [nameLabel.text isEqualToString:@"任务备注"] )
        inputText.textColor =COLOR_TABLE_TITLE;
    if ([text isEqualToString: @"\n"]) {
        myBlock(textView.text);
        [textView resignFirstResponder];
    }
    
    
    return true;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([nameLabel.text isEqualToString:@"处理描述"])
    {
        if ([inputText.text isEqualToString:@"请输入处理描述"])
        {
            inputText.text = @"";
        }
    }
    if ([nameLabel.text isEqualToString:@"任务描述"] || [nameLabel.text isEqualToString:@"任务备注"] ) {
        
        if ([inputText.text isEqualToString:dataDic[@"placeholder"]? dataDic[@"placeholder"]  :@"请输入处理描述"])
        {
            inputText.text = @"";
        }
    }
    
    if (myBlock2) {
        myBlock2(nil);
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    myBlock(textView.text);
    if ([nameLabel.text isEqualToString:@"处理描述"]) {
        if ([inputText.text isEqualToString:@""])
        {
            inputText.text = @"请输入处理描述";
            inputText.textColor =COLOR_TABLE_DES;
        }
    }
    
    if ([nameLabel.text isEqualToString:@"任务描述"] || [nameLabel.text isEqualToString:@"任务备注"] ) {
        if ([inputText.text isEqualToString:@""])
        {
            inputText.text = dataDic[@"placeholder"];
            inputText.textColor =COLOR_TABLE_DES;
        }
    }
    
}

@end
