//
//  MonitorViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/7/8.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "HeroTopViewController.h"
#import "ReportDetailViewController.h"

#import "MonitorDetailViewController.h"
#import "HeroTableViewCell.h"
@interface HeroTopViewController ()
{
    CGRect bounds;
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;
    
}
@end

@implementation HeroTopViewController
@synthesize mainTableV;
@synthesize hideSectionArr;
@synthesize pickerV;

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
- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setBarTintColor:MAIN_TINIT_COLOR]; // 修改导航栏的颜色为蓝色
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]]; // 字体的颜色为白色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]]; // 修改导航栏的颜色为蓝色
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]]; // 字体的颜色为白色
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     

    
    
    self.title = String(@"英雄榜");
   
    button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button0 setTitle:@"项目公司" forState:UIControlStateNormal];
    button0.titleLabel.font = [UIFont systemFontOfSize:15];
    button0.titleLabel.textColor = UIColorFromHex(0xffffff);
    button0.frame = CGRectMake(0, 0, MAINSCREENWIDTH/3, 44);
    [button0 setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [self.view addSubview:button0];
    [self reSetBtn:button0];
    [button0 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"发电量" forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize:15];
    button1.titleLabel.textColor = UIColorFromHex(0xffffff);
    button1.frame = CGRectMake(MAINSCREENWIDTH/3, 0, MAINSCREENWIDTH/3, 44);
    [button1 setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    [self reSetBtn:button1];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"日" forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize:15];
    button2.titleLabel.textColor = UIColorFromHex(0xffffff);
    button2.frame = CGRectMake(MAINSCREENWIDTH/3 * 2, 0, MAINSCREENWIDTH/3, 44);
    [button2 setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    [self reSetBtn:button2];
    [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];


     UIView *view = [[UIView alloc] init];
     view.frame = CGRectMake(0,0,MAINSCREENWIDTH,335);
     // gradient
     CAGradientLayer *gl = [CAGradientLayer layer];
     gl.frame = CGRectMake(0,0,MAINSCREENWIDTH,335);
     gl.startPoint = CGPointMake(0.5, 1);
     gl.endPoint = CGPointMake(0.5, 0);
     gl.colors = @[(__bridge id)[UIColor colorWithRed:110/255.0 green:210/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)MAIN_TINIT_COLOR.CGColor];
     gl.locations = @[@(0), @(1.0f)];
     [view.layer addSublayer:gl];
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    
    hideSectionArr = [[NSMutableArray alloc] init];
    weak_self(ws);
    
    [mainTableV registerNib:[UINib nibWithNibName:@"HeroTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeroTableViewCell"];
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;

    
    mainTableV.backgroundColor = [UIColor clearColor];
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.hideSectionArr removeAllObjects];
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    
    if (@available(iOS 11.0, *)) {

            self.mainTableV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

    } else {

            self.automaticallyAdjustsScrollViewInsets = NO;

    }
    
}

- (void)buttonClick:(UIButton *)btn{
    if ( btn ==button0) {
        [self.pickerV setType:PickerTypeOne andTag:0 andDatas:@[@{@"name":@"项目公司"},@{@"name":@"电站"}]];
        self.pickerV.hiddenCustomPicker = NO;
        
    }else if ( btn ==button1) {
        [self.pickerV setType:PickerTypeOne andTag:1 andDatas:@[@{@"name":@"发电量"},@{@"name":@"兆瓦发电量"}]];
        self.pickerV.hiddenCustomPicker = NO;
    }else{
        [self.pickerV setType:PickerTypeOne andTag:2 andDatas:@[@{@"name":@"日"},@{@"name":@"月"},@{@"name":@"年"}]];
        self.pickerV.hiddenCustomPicker = NO;
    }
}

- (void)reloadV{
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)alarmDealNoti:(id)obj{
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
 
    [parmDic setObject:@(button0.tag) forKey:@"type"];
    [parmDic setObject:@(button1.tag) forKey:@"datasort"];
    [parmDic setObject:@(button2.tag) forKey:@"selectTime"];

    //    type = request.POST.get('type', '0')  0 项目公司，电站
    //    datasort = request.POST.get('datasort', '0') 0 发电量 1兆瓦发电量
    //    selectTime = request.POST.get('selectTime', '0') 0 日 1 月 2 年
    
    [apiBlock startRequest:parmDic uri:API_HERO_LIST result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        
        [ws.mainTableV reloadData];
    }];
}

#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 33.5;
    }
    return 39;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44 + (MAINSCREENWIDTH - 41) * 198.5 / 334;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataModel) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = dataModel.data;
    return arr.count -2 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44 + (MAINSCREENWIDTH - 41) * 198.5 / 334)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(21.5, 44, MAINSCREENWIDTH-41, (MAINSCREENWIDTH - 41) * 198.5 / 334)];
    imgV.image = [UIImage imageNamed:@"b'g"];
    [view addSubview:imgV];
    
    if ([dataModel.data count] > 0)
    {
        UILabel *oneLabel = [UILabel mj_label];
        oneLabel.font = [UIFont systemFontOfSize:14];
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabel];
        oneLabel.text = dataModel.data[0][@"name"];
        oneLabel.center = CGPointMake(MAINSCREENWIDTH/2, 15 + 44 + imgV.frame.size.height * 0.52);
        
        UILabel *oneLabelDes = [UILabel mj_label];
        oneLabelDes.font = [UIFont systemFontOfSize:14];
        oneLabelDes.textColor = [UIColor whiteColor];
        oneLabelDes.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabelDes];
        oneLabelDes.text = [NSString stringWithFormat:@"%.1f%@", [dataModel.data[0][@"value"] floatValue],dataModel.data[0][@"unit"]];
        oneLabelDes.center = CGPointMake(MAINSCREENWIDTH/2, 15 + 44 + imgV.frame.size.height * 0.64);
    }
    if ([dataModel.data count] > 1) {
        UILabel *oneLabel = [UILabel mj_label];
        oneLabel.font = [UIFont systemFontOfSize:14];
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabel];
        oneLabel.text = dataModel.data[1][@"name"];
        oneLabel.center = CGPointMake(21.5 + (MAINSCREENWIDTH-41)/6, 15 + 44 + imgV.frame.size.height * 0.64);
        
        UILabel *oneLabelDes = [UILabel mj_label];
        oneLabelDes.font = [UIFont systemFontOfSize:14];
        oneLabelDes.textColor = [UIColor whiteColor];
        oneLabelDes.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabelDes];
        oneLabelDes.text = [NSString stringWithFormat:@"%.1f%@",[dataModel.data[1][@"value"] floatValue] ,dataModel.data[1][@"unit"]];
        oneLabelDes.center = CGPointMake(21.5 + (MAINSCREENWIDTH-41)/6, 15 + 44 + imgV.frame.size.height * 0.76);
    }
    if ([dataModel.data count] > 2) {
        UILabel *oneLabel = [UILabel mj_label];
        oneLabel.font = [UIFont systemFontOfSize:14];
        oneLabel.textColor = [UIColor whiteColor];
        oneLabel.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabel];
        oneLabel.text = dataModel.data[2][@"name"];
        oneLabel.center = CGPointMake(MAINSCREENWIDTH- 21.5 -  (MAINSCREENWIDTH-41)/6, 15 + 44 + imgV.frame.size.height * 0.64);
        
        UILabel *oneLabelDes = [UILabel mj_label];
        oneLabelDes.font = [UIFont systemFontOfSize:14];
        oneLabelDes.textColor = [UIColor whiteColor];
        oneLabelDes.frame = CGRectMake(0, 0, (MAINSCREENWIDTH-41)/3, 30);
        [view addSubview:oneLabelDes];
        oneLabelDes.text = [NSString stringWithFormat:@"%.1f%@", [dataModel.data[2][@"value"] floatValue],dataModel.data[2][@"unit"]];
        oneLabelDes.center = CGPointMake(MAINSCREENWIDTH- 21.5 -  (MAINSCREENWIDTH-41)/6, 15 + 44 + imgV.frame.size.height * 0.76);
    }
    
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeroTableViewCell"];

    if (indexPath.row>0){
        NSDictionary *dic = dataModel.data[indexPath.row + 2];
        [cell setData:dic andIndex:indexPath.row + 3];
    }else{
        [cell setData:nil andIndex:0];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}



#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
    if (v.tag == 0) {
        button0.tag = indexpath.section;
        [button0 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button0];
    }else if (v.tag == 1){
        button1.tag = indexpath.section;
        [button1 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button1];
       
    }else if (v.tag == 2){
        button2.tag = indexpath.section;
        [button2 setTitle:array[0][@"name"] forState:UIControlStateNormal];
        [self reSetBtn:button2];

    }
    [mainTableV.mj_header beginRefreshing];

}

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
         needLine = false;
     } else if (indexPath.row == [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
         // 3.每组最后一行cell
         
     }else if (indexPath.row != 0 && indexPath.row != [mainTableV numberOfRowsInSection:indexPath.section] - 1) {
    // 4.每组的中间行
         needLine = true;
     }
    if (needLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, bounds.size.height-0.5f, MAINSCREENWIDTH-0, 0.5f)];
        line.backgroundColor = COLOR_TABLE_SEP;
        [cell addSubview:line];
    }
    
}

#pragma mark - private method
- (CGMutablePathRef)drawPathRef:(CGMutablePathRef)pathRef forCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // cell的bounds
    CGFloat cornerRadius = LAYER_CORNERRADIUS;
    bounds = cell.bounds;
    bounds =  CGRectMake(0, bounds.origin.y, CGRectGetWidth(bounds)-0, CGRectGetHeight(bounds));
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
