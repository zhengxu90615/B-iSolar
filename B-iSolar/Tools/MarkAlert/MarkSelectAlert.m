//
//  MarkAlert.m
//  Operator
//
//  Created by Mark on 14-10-16.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MarkSelectAlert.h"
#import "RuleTableViewCell.h"
#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define  BUTTONWITDH 90

typedef void (^MarkAlertResult)(NSArray*) ;
@interface MarkSelectAlert ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@end
@implementation MarkSelectAlert
{
    UIButton *button;
    UILabel *titleLabel;
    UITextView *titleInput;
    UIView *backWindowLayer;
    UITableView *payTable;
    UITableView *rightTable;
    
    NSMutableArray *selectUsers;
    NSMutableArray *selectedUsers;
    
    MarkAlertResult clickResult;
    NSInteger leftIndex;
    
    
    UIButton *selectBtnl;

    UIView *showV;
    
}
SHARED_INSTANCE_IMPLEMENTATION(MarkAlert)


-(void)cancelAction
{
    [self dismiss];

}


- (float)totalLabelHeight:(NSArray *)actions{
    
    float totalHeight = 0;
    for (NSString * str in actions) {
        float singleHeight =[self getStringHeightWithText:str font:FONTSIZE_TABLEVIEW_CELL_DESCRIPTION viewWidth:MAINSCREENWIDTH-60 - 65];
        
        if (singleHeight < 34) {
            totalHeight += 44;
        }else{
            totalHeight += 10 ;
            totalHeight += singleHeight;
        }
    }
    return totalHeight;
}

- (CGFloat)getStringHeightWithText:(NSString *)text font:(UIFont *)font viewWidth:(CGFloat)width {
    // 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName :font};
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);

    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    // 计算文字占据的宽高
    CGSize size = [text boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;

   // 当你是把获得的高度来布局控件的View的高度的时候.size转化为ceilf(size.height)。
    return  ceilf(size.height);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}
- (id)initUsers:(NSArray *)users andSelected:sel  result:(void (^)(NSArray*))result;
{
    
    if (self = [super init]){

        leftIndex = -1;
        
        float totalHeight = 34 * MAX(5, users.count);
        
        selectUsers = [[NSMutableArray alloc ] initWithArray: users];
        
       
        
        
        clickResult = result;
        
        self.frame = CGRectMake(30, (MAINSCREENHEIGHT-(MAINSCREENWIDTH-60)/1.56)/2, MAINSCREENWIDTH-60, 0);
        self.backgroundColor =  UIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        
        titleInput = [[UITextView alloc] initWithFrame:CGRectMake(10, 30, MAINSCREENWIDTH-60 -20, 18*5)];
        titleInput.textAlignment = NSTextAlignmentLeft;
        titleInput.delegate = self;
        titleInput.backgroundColor = [UIColor clearColor];
        titleInput.font = [UIFont systemFontOfSize:16];
        titleInput.textAlignment = NSTextAlignmentCenter;
        titleInput.text = @"";
        titleInput.textColor = UIColorFromRGB(0x4b4b4d);
        titleInput.layer.borderWidth = .5f;
        titleInput.layer.borderColor = COLOR_TABLE_SEP.CGColor;

        [self addSubview:titleInput];
        
        if (!sel) {
            selectedUsers = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in selectUsers) {
                [selectedUsers addObject:@[]];
            }
        }else{
            selectedUsers = [sel mutableCopy];
            [self reloadSelectedUsers];
        }
        float tableHeight = totalHeight;
        
        if (tableHeight > (MAINSCREENHEIGHT-300)) {
            tableHeight = MAINSCREENHEIGHT-300;
        }
        
        payTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleInput.frame)+30, (MAINSCREENWIDTH-60)/2, tableHeight) style:UITableViewStyleGrouped];
        payTable.backgroundColor= [UIColor whiteColor];
        payTable.scrollEnabled = YES;
        payTable.separatorColor = UIColorFromRGB(0xe8e8e8);
        payTable.dataSource = self;
        payTable.delegate = self;
        [self addSubview:payTable];
        [payTable  registerNib:[UINib nibWithNibName:@"RuleTableViewCell" bundle:nil] forCellReuseIdentifier:@"RuleTableViewCell"];
        
        rightTable= [[UITableView alloc] initWithFrame:CGRectMake((MAINSCREENWIDTH-60)/2+1, CGRectGetMaxY(titleInput.frame)+30,(MAINSCREENWIDTH-60)/2, tableHeight) style:UITableViewStyleGrouped];
        rightTable.backgroundColor= [UIColor whiteColor];
        rightTable.scrollEnabled = YES;
        rightTable.separatorColor = UIColorFromRGB(0xe8e8e8);
        rightTable.dataSource = self;
        rightTable.delegate = self;
        [self addSubview:rightTable];
        [rightTable  registerNib:[UINib nibWithNibName:@"RuleTableViewCell" bundle:nil] forCellReuseIdentifier:@"RuleTableViewCell"];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(payTable.frame), MAINSCREENWIDTH-60, 50);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:MAIN_TINIT_COLOR  forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.frame = CGRectMake(30, (MAINSCREENHEIGHT-(CGRectGetMinY(button.frame) + CGRectGetHeight(button.frame)))/2, MAINSCREENWIDTH-60, CGRectGetMinY(button.frame) + CGRectGetHeight(button.frame));
        

    }
    return self;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == payTable) {
        return selectUsers.count;
    }else{
        if (leftIndex == -1) {
            return 0;
        }
        return [selectUsers[leftIndex][@"users"] count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
  
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RuleTableViewCell"];
    if (tableView == payTable) {
        [cell setData:selectUsers[indexPath.row] andBlock:^(id x) {
            UISwitch *sw = x;

        }];
        
//        if (leftIndex == -1) {
//            [cell selected:NO];
//        }else{
            [cell hlightBg:leftIndex == indexPath.row];
            
            NSMutableArray * arr = [NSMutableArray arrayWithArray: selectedUsers[indexPath.row]];
            
            if (arr.count > 0) {
                [cell selected:YES];
            }else{
                [cell selected:NO];
            }
//        }
       
    }else{
        [cell setData:selectUsers[leftIndex][@"users"][indexPath.row] andBlock:^(id x) {

        }];
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray: selectedUsers[leftIndex]];
        
        if ([arr containsObject:selectUsers[leftIndex][@"users"][indexPath.row]]) {
            [cell selected:YES];
        }else{
            [cell selected:NO];
        }
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RuleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (tableView == payTable) {
        if (indexPath.row != leftIndex) {
            leftIndex = indexPath.row;
            [payTable reloadData];
            [rightTable reloadData];
        }
        
        return;
    }else{
        
                NSMutableArray * arr = [NSMutableArray arrayWithArray: selectUsers[leftIndex][@"users"]];
                NSDictionary *clickDic = arr[indexPath.row];
                for (int i = 0; i<selectedUsers.count; i++) {
        
                    NSMutableArray * newArr = [NSMutableArray arrayWithArray: selectedUsers[i]];
                    NSMutableArray * total = [NSMutableArray arrayWithArray:  selectUsers[i][@"users"]];
        
                    if (![newArr containsObject:clickDic]) {
                        if ([total containsObject:clickDic]) {
                            [newArr addObject:clickDic];
        
                        }
        //                [cell selected:YES];
                    }else{
                        [newArr removeObject:clickDic];
        //                [cell selected:NO];
                    }
        
                    [selectedUsers replaceObjectAtIndex:i withObject:newArr];
        
                    if (i == leftIndex) {
                        [rightTable reloadData];
                    }
                }
                [payTable reloadData];
        
        
        
//        NSMutableArray * arr = [NSMutableArray arrayWithArray: selectedUsers[leftIndex]];
//        if (![arr containsObject:selectUsers[leftIndex][@"users"][indexPath.row]]) {
//            [arr addObject:selectUsers[leftIndex][@"users"][indexPath.row]];
//            [cell selected:YES];
//        }else{
//            [arr removeObject:selectUsers[leftIndex][@"users"][indexPath.row]];
//            [cell selected:NO];
//        }
//        [selectedUsers replaceObjectAtIndex:leftIndex withObject:arr];
//        
//        [payTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:leftIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

        [self reloadSelectedUsers];
    }
}

- (void)reloadSelectedUsers{
    
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    NSMutableArray *idArr = [[NSMutableArray alloc] init];
    
    for (NSArray *arr in selectedUsers) {
        for (NSDictionary *dic in arr) {
            if ([idArr containsObject:TOINTSTRING(dic[@"id"])]) {
                continue;
            }
            [idArr addObject:TOINTSTRING(dic[@"id"])];
            [nameArr addObject:[NSString stringWithFormat:@"(%d)%@",[nameArr count] +1,dic[@"name"]]];
        }
    }
    
    titleInput.text = [nameArr componentsJoinedByString:@"、"];
    
}

-(void)payAction
{
    if (clickResult) {
        clickResult(selectedUsers);
    }
    [self dismiss];
}


- (void)selectClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}


- (void)bgClick{
    [self cancelAction];
    clickResult(nil);
}

- (void)show
{
    for (UIView *v in [[UIApplication sharedApplication].delegate.window subviews]) {
        if ([v isKindOfClass:[MarkSelectAlert class]]) {
            [(MarkSelectAlert*)v dismiss];
        }
    }
    _showed = YES;
    backWindowLayer = [[UIView alloc] init];
    backWindowLayer.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT+20);
    backWindowLayer.backgroundColor = UIColorFromRGBA(0x000000,0.3);
    [[UIApplication sharedApplication].delegate.window addSubview:backWindowLayer];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [backWindowLayer addGestureRecognizer:tapg];
}

- (void)dismiss
{
    _showed = NO;
    [backWindowLayer removeFromSuperview];
    [self removeFromSuperview];
}


- (void)buttonClick2:(UIButton *)btn
{
    
    if (!selectBtnl.selected) {
        return;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(markAlert:clickedButtonAtIndex:)]) {
        [delegate markAlert:self clickedButtonAtIndex:btn.tag];
    }
    if (clickResult){
//        clickResult(/*btn.tag)*/;
    }
    [self dismiss];
}



- (void)buttonClick:(UIButton *)btn
{
    if (delegate && [delegate respondsToSelector:@selector(markAlert:clickedButtonAtIndex:)]) {
        [delegate markAlert:self clickedButtonAtIndex:btn.tag];
    }
    if (clickResult){
//        clickResult(btn.tag);
    }
    [self dismiss];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
*/


@end
