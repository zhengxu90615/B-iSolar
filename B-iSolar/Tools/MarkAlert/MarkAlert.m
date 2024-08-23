//
//  MarkAlert.m
//  Operator
//
//  Created by Mark on 14-10-16.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import "MarkAlert.h"
#import "RuleTableViewCell.h"
#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)
#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define  BUTTONWITDH 90

typedef void (^MarkAlertResult)(NSArray*) ;
@interface MarkAlert ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation MarkAlert
{
    UIButton *button;
    UILabel *titleLabel;
    UILabel *messageLabel;
    UIView *backWindowLayer;
    UITableView *payTable;
    NSMutableArray *payActions;
    MarkAlertResult clickResult;
    NSInteger payWay;
    
    UIButton *selectBtnl;
    NSMutableArray*checkedArray;
    UIView *showV;
    BOOL onlyChoseOne ;
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
-(id) initWithPayActionOnlyOne:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result{
    
    id x =  [self initWithPayAction:title action:actions result:result];
    onlyChoseOne = true;
    button.hidden = YES;
    payTable.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+30, MAINSCREENWIDTH-60, payTable.height + 50);
    return x;
}
-(id) initWithPayAction:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result andSelected:(NSArray*)arr{
    id x = [self initWithPayAction:title action:actions result:result];
    
  
    for (int i =0;i<arr.count; i++) {
        [ checkedArray addObject:actions[[arr[i] intValue]]];
    }
    return x;
}

-(id) initWithPayAction:(NSString*)title action:(NSArray*)actions result:(void (^)(NSArray*))result
{
   
    if (self = [super init]){
        onlyChoseOne = false;

        float totalHeight = 34 * actions.count;
        
        payActions = [actions mutableCopy];
        clickResult = result;
        
        self.frame = CGRectMake(30, (MAINSCREENHEIGHT-(MAINSCREENWIDTH-60)/1.56)/2, MAINSCREENWIDTH-60, 0);
        self.backgroundColor =  UIColorFromRGB(0xffffff);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, MAINSCREENWIDTH-60, 18)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = UIColorFromRGB(0x4b4b4d);
        [self addSubview:titleLabel];
        
        
        float tableHeight = totalHeight;
        
        if (tableHeight > (MAINSCREENHEIGHT-260)) {
            tableHeight = MAINSCREENHEIGHT-260;
        }
        
        payTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+30, MAINSCREENWIDTH-60, tableHeight) style:UITableViewStyleGrouped];
        payTable.backgroundColor= [UIColor whiteColor];
        payTable.scrollEnabled = YES;
        payTable.separatorColor = UIColorFromRGB(0xe8e8e8);
        payTable.dataSource = self;
        payTable.delegate = self;
        [self addSubview:payTable];
        [payTable  registerNib:[UINib nibWithNibName:@"RuleTableViewCell" bundle:nil] forCellReuseIdentifier:@"RuleTableViewCell"];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(payTable.frame), MAINSCREENWIDTH-60, 50);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:MAIN_TINIT_COLOR  forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        self.frame = CGRectMake(30, (MAINSCREENHEIGHT-(CGRectGetMinY(button.frame) + CGRectGetHeight(button.frame) ))/2, MAINSCREENWIDTH-60, CGRectGetMinY(button.frame) + CGRectGetHeight(button.frame));
        
        checkedArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return payActions.count;
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
    [cell setData:payActions[indexPath.row] andBlock:^(id x) {
        UISwitch *sw = x;
        if (sw.on)
        {
            [checkedArray addObject:payActions[indexPath.row]];
        }else{
            [checkedArray removeObject:payActions[indexPath.row]];
        }
    }];
    [cell selected:[checkedArray containsObject:payActions[indexPath.row]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (onlyChoseOne) {
        
        clickResult(@[payActions[indexPath.row]]);
        [self dismiss];
        return;
    }
    
    RuleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![checkedArray containsObject:payActions[indexPath.row]]) {
        [checkedArray addObject:payActions[indexPath.row]];
        [cell selected:YES];
    }else{
        [checkedArray removeObject:payActions[indexPath.row]];
        [cell selected:NO];
    }
    
}
-(void)payAction
{
        if (clickResult){
            clickResult(checkedArray);
        }
        [self dismiss];
    
}


- (void)selectClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}


-(void)show:(void (^)(NSArray* aaa))result
{
    UIView *targetView = [AppDelegate App].window;
    [targetView endEditing:NO];
    
    
    for (UIView *v in [[UIApplication sharedApplication].delegate.window subviews]) {
        if ([v isKindOfClass:[MarkAlert class]]) {
            [(MarkAlert*)v dismiss];
        }
    }
    
    _showed = YES;
    clickResult = result;
    backWindowLayer = [[UIView alloc] init];
    backWindowLayer.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT+20);
    backWindowLayer.backgroundColor = UIColorFromRGBA(0x000000,0.3);
    backWindowLayer.backgroundColor = UIColorFromRGBA(0x00ff00,0.3);
    
    backWindowLayer.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgClick)];
    [backWindowLayer addGestureRecognizer:tapg];
    
    
    [[UIApplication sharedApplication].delegate.window addSubview:backWindowLayer];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}
- (void)bgClick{
    [self cancelAction];
    clickResult(nil);
}

- (void)show
{
    for (UIView *v in [[UIApplication sharedApplication].delegate.window subviews]) {
        if ([v isKindOfClass:[MarkAlert class]]) {
            [(MarkAlert*)v dismiss];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
