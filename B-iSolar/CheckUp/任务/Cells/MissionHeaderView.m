//
//  MissionHeaderView.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/22.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "MissionHeaderView.h"

@implementation MissionHeaderView

- (instancetype)initWithBlock:(NormalBlock2)block{
    CGRect rect = CGRectMake(0, 0, MAINSCREENWIDTH, 88);
    if(self = [super initWithFrame:rect])
    {
        myBlock = block;
        
        self.backgroundColor = [UIColor clearColor];
        
        bgV0 = [[UIView alloc] initWithFrame:CGRectMake(10, 10, MAINSCREENWIDTH-20, 36)];
        bgV0.backgroundColor = [UIColor whiteColor];
        bgV0.layer.cornerRadius = 7;
        bgV0.layer.masksToBounds = YES;
        [self addSubview:bgV0];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(100, 10.5, 0.5, 15)];
        sepLine.backgroundColor = COLOR_TABLE_DES;
        [bgV0 addSubview:sepLine];
        
        statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusBtn setImage:[UIImage imageNamed:@"icon_down_g"] forState:UIControlStateNormal];
        statusBtn.frame = CGRectMake(0, 0, 100, 36);
        [bgV0 addSubview:statusBtn];
        statusBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [statusBtn setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        [statusBtn setTitle:@"请选择状态" forState:UIControlStateNormal];
        [self reSetBtn:statusBtn];
        
        nameTextF = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, MAINSCREENWIDTH-120-40, 36)];
        nameTextF.backgroundColor = [UIColor clearColor];
        nameTextF.font = [UIFont systemFontOfSize:14];
        nameTextF.returnKeyType = UIReturnKeySearch;
        nameTextF.placeholder = @"请输入任务名称";
        nameTextF.delegate = self;
        [bgV0 addSubview:nameTextF];
        
        
        bgV1 = [[UIView alloc] initWithFrame:CGRectMake(10, bgV0.mj_origin.y + 36 +8, MAINSCREENWIDTH-20 - 90, 36)];
        bgV1.backgroundColor = [UIColor whiteColor];
        bgV1.layer.cornerRadius = 7;
        bgV1.layer.masksToBounds = YES;
        [self addSubview:bgV1];
        
        selectUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [selectUserBtn setImage:[UIImage imageNamed:@"icon_down_g"] forState:UIControlStateNormal];
        selectUserBtn.frame = CGRectMake(0, 0, MAINSCREENWIDTH-20-90, 36);
        
        [bgV1 addSubview:selectUserBtn];
        selectUserBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        selectUserBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        selectUserBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        selectUserBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [selectUserBtn setTitleColor:COLOR_TABLE_DES forState:UIControlStateNormal];
        [selectUserBtn setTitle:@"请选择被指派人" forState:UIControlStateNormal];

        imV = [[UIImageView alloc] initWithFrame:CGRectMake(bgV1.width-17, 14, 7, 7.5)];
        [bgV1 addSubview:imV];
        [imV setImage:[UIImage imageNamed:@"icon_down_g"]];
        
        onMeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(bgV1.x + bgV1.width + 10, bgV1.y + 9, 18, 18)];
        [self addSubview:onMeImgV];
        [onMeImgV setImage:[UIImage imageNamed:@"unselected"]];
        
        la = [[UILabel alloc] initWithFrame:CGRectMake(onMeImgV.x + onMeImgV.width + 5, bgV1.y, 80, 36)];
        la.text = @"指派给我";
        la.textColor = COLOR_TABLE_TITLE;
        la.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;
        [self addSubview:la];
        
        onMeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        onMeBtn.frame = CGRectMake(bgV1.x + bgV1.width, bgV1.y,  90, 36);
        onMeBtn.backgroundColor = [UIColor clearColor];
        [self addSubview:onMeBtn];
        
        
        [statusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectUserBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [onMeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)reSetBtn:(UIButton *)btn{
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
    CGFloat btnImageWidth = btn.imageView.bounds.size.width;
    CGFloat btnLabelWidth = btn.titleLabel.bounds.size.width;
    CGFloat margin = 3;

    btnImageWidth += margin;
    btnLabelWidth += margin;

    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnImageWidth, 0, btnImageWidth)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnLabelWidth, 0, -btnLabelWidth)];
}

- (void)btnClick:(UIButton *)btn
{
    [nameTextF resignFirstResponder];
    
    if (btn == onMeBtn) {
        onMeBtn.selected = !onMeBtn.selected;
        [onMeImgV setImage:onMeBtn.selected?[UIImage imageNamed:@"selected"]:[UIImage imageNamed:@"unselected"]];

        myBlock(3,onMeBtn.selected?@"1":@"0");
        
    }else if (btn == statusBtn){
        myBlock(0,nil);
        
    }else if (btn == selectUserBtn){
        myBlock(2,nil);

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [nameTextF resignFirstResponder];
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [nameTextF resignFirstResponder];
    }
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    myBlock(1,nameTextF.text);
}
- (void)resetData:(NSString*)status name:(NSString*)name ids:(NSString*)ids onMe:(NSString*)onme
{
    if (status) {
//        if ([status isEqualToString:@""]) {
//            [statusBtn setTitle:@"请选择被指派人" forState:UIControlStateNormal];
//        }else{
            [statusBtn setTitle:status forState:UIControlStateNormal];
//        }
        [self reSetBtn:statusBtn];
    }
    if (name) {
        
    }
    if (ids) {
        if ([ids isEqualToString:@""]) {
            [selectUserBtn setTitle:@"请选择被指派人" forState:UIControlStateNormal];

        }else{
            [selectUserBtn setTitle:ids forState:UIControlStateNormal];
        }
    }
    if (onme) {
        if ([onme isEqualToString: @"0"]) {
            onMeBtn.selected = NO;
            [onMeImgV setImage:onMeBtn.selected?[UIImage imageNamed:@"selected"]:[UIImage imageNamed:@"unselected"]];
        }else{
            onMeBtn.selected = YES;
            [onMeImgV setImage:onMeBtn.selected?[UIImage imageNamed:@"selected"]:[UIImage imageNamed:@"unselected"]];
        }
    }
}
- (void)setData:(NSDictionary *)data{
    
    NSString *user_position = TOSTRING(data[@"user_position"]);
    
//    @"user_position"   3 负责人  0总部员工  1站长  2普通员工     1 才会有指派给我   2 下面一行都没有   0总部
    if ([user_position isEqualToString:@"2"]) {
        bgV1.hidden = YES;
        onMeImgV.hidden = YES;
        onMeBtn.hidden = YES;
        la.hidden = YES;
    }else if ([user_position isEqualToString:@"1"] || [user_position isEqualToString:@"0"]) {
        bgV1.hidden =  onMeImgV.hidden =  onMeBtn.hidden =  la.hidden = NO;
        
        bgV1.frame = CGRectMake(10, bgV0.mj_origin.y + 36 +8, MAINSCREENWIDTH-20 - 90, 36);
        imV.frame = CGRectMake(bgV1.width-17, 14, 7, 7.5);

        onMeImgV.frame = CGRectMake(bgV1.x + bgV1.width + 10, bgV1.y + 9, 18, 18);
        onMeBtn.frame = CGRectMake(bgV1.x + bgV1.width, bgV1.y,  90, 36);
        la.frame = CGRectMake(onMeImgV.x + onMeImgV.width + 5, bgV1.y, 80, 36);
        
        
    }else{
        bgV1.hidden =  NO;
        onMeImgV.hidden = onMeBtn.hidden =  la.hidden = YES;

        bgV1.frame = CGRectMake(10, bgV0.mj_origin.y + 36 +8, MAINSCREENWIDTH-20 , 36);
        imV.frame = CGRectMake(bgV1.width-17, 14, 7, 7.5);

    }
    
    
    
    
}
- (void)resignFirstResp
{
    [nameTextF resignFirstResponder];
    
    
}
@end
