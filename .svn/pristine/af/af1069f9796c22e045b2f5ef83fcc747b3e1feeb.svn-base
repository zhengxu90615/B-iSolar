//
//  BaseTableViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/24.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "BaseCardTableViewController.h"

@interface BaseCardTableViewController ()
{
    CGRect bounds;
}
@end

@implementation BaseCardTableViewController
@synthesize mainTableV;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT) style:UITableViewStyleGrouped];
    mainTableV.delegate = self;
    mainTableV.dataSource = self;
    mainTableV.backgroundColor = [UIColor clearColor];
    mainTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:mainTableV];
    
    
    weak_self(ws)
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)getData:(id)sender{
   
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 0.cell背景透明，否则不会出现圆角效果
    cell.backgroundColor = [UIColor clearColor];

    // 原因如下：
    // 之所以设置为透明，是因为cell背景色backGroundColor是直接设置在UITableViewCell上面的，位于cell的第四层
    // backGroundView是在UITableViewCell之上的，也就是位于cell的第三层
    // 我们所要做的操作是在backGroundView上，也就是第三层
    // 第三层会挡住第四层，如果第四层设置了颜色，那么将来cell的圆角部分会露出第四层的颜色，也就是背景色
    // 所以，必须设置cell的背景色为透明色！
    // 另外:
    // 第二层是UITableViewCellContentView，默认就是透明的，无需设置
    // 第一层是UITableViewLabel，也就是cell.textLabel
    
    // 1.创建path,保存绘制的路径
    CGMutablePathRef pathRef = CGPathCreateMutable();
    pathRef = [self drawPathRef:pathRef forCell:cell atIndexPath:indexPath];
    
    // 2.创建layer,渲染效果
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    [self renderCornerRadiusLayer:layer withPathRef:pathRef toCell:cell];
    
    
    BOOL needLine = false;
     if (indexPath.row == 0 && indexPath.row == [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
         // 1.既是第一行又是最后一行
    } else if (indexPath.row == 0) {
         // 2.每组第一行cell
         needLine = true;
     } else if (indexPath.row == [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
         // 3.每组最后一行cell
         
     }else if (indexPath.row != 0 && indexPath.row != [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
    // 4.每组的中间行
         needLine = true;
     }
    if (needLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, bounds.size.height-0.5f, MAINSCREENWIDTH-30, 0.5f)];
        line.backgroundColor = COLOR_TABLE_SEP;
        [cell addSubview:line];
    }
     
    
}

#pragma mark - private method
- (CGMutablePathRef)drawPathRef:(CGMutablePathRef)pathRef forCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // cell的bounds
    CGFloat cornerRadius = LAYER_CORNERRADIUS;
    bounds = cell.bounds;
    bounds =  CGRectMake(10, bounds.origin.y, CGRectGetWidth(bounds)-20, CGRectGetHeight(bounds));
    if (indexPath.row == 0 && indexPath.row == [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
        // 1.既是第一行又是最后一行
        // 1.1.底端中点 -> cell左下角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
        // 1.2.左下角 -> 左端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 1.3.左上角 -> 顶端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        // 1.4.cell右上角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 1.5.cell右下角 -> 底端中点
        CGPathAddArcToPoint(pathRef, nil,   CGRectGetMaxX(bounds), CGRectGetMaxY(bounds),CGRectGetMidX(bounds), CGRectGetMaxY(bounds),cornerRadius);
        return pathRef;
        
    } else if (indexPath.row == 0) {
        // 2.每组第一行cell
        // 2.1.起点： 左下角
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 2.2.cell左上角 -> 顶端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        // 2.3.cell右上角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 2.4.cell右下角
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        // 绘制cell分隔线
        // addLine = YES;
        return pathRef;
        
    } else if (indexPath.row == [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
        // 3.每组最后一行cell
        // 3.1.初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        // 3.2.cell左下角 -> 底端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        // 3.3.cell右下角 -> 右端中点
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 3.4.cell右上角
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        return pathRef;
        
    }else if (indexPath.row != 0 && indexPath.row != [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
        // 4.每组的中间行
        CGPathAddRect(pathRef, nil, bounds);
        return pathRef;
    }
    return nil;
}

- (void)renderCornerRadiusLayer:(CAShapeLayer *)layer withPathRef:(CGMutablePathRef)pathRef toCell:(UITableViewCell *)cell {
    // 绘制完毕，路径信息赋值给layer
    layer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    // 创建和cell尺寸相同的view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12, bounds.origin.y, CGRectGetWidth(bounds)-24, CGRectGetHeight(bounds))];
    // 添加layer给backView
    [backView.layer addSublayer:layer];
    // backView的颜色
    backView.backgroundColor = [UIColor clearColor];
    // 把backView添加给cell
    cell.backgroundView = backView;
    
    
}


@end
