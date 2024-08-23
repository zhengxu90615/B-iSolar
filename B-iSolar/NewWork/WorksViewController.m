//
//  HomeViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/18.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "WorksViewController.h"
#import "BDefine.h"
#import "HomeTableHeaderView.h"
#import "HomeTableViewMyStationCell.h"
#import "NFCManager.h"
#import "InCheckViewController.h"

#import "HomeTableChartsCell.h"
#import "HomeTableViewCompleteCell.h"
#import "FileDetailViewController.h"
#import "NoticesViewController.h"
#import "ReportViewController.h"
#import "UserViewController.h"
#import "ZBarSDK.h"
#import "CDZQRScanViewController.h"
#import "QrScanUploadViewController.h"
#import "NoticeTypeViewController.h"
#import "AppDelegate.h"
#import "AssetsViewController.h"
#import "HomeComTableViewCell.h"
#import "HeroTopViewController.h"
#import "MonitorViewController.h"
#import "AlarmNewViewController.h"
#import "WorkCell0.h"
#import "WorkCell1.h"
#import "WorkCell2.h"
#import "CheckUpViewController.h"
#import "WorkCell3.h"


@interface WorksViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZBarReaderDelegate>
{
    CGRect bounds;
    int alarmNum;
    int noticeNum;
    IBOutlet NSLayoutConstraint *tableTopCon;
    UIView *headView;
}
@end

@implementation WorksViewController
@synthesize mainTableV;
@synthesize dataModel;
static NSString *homeTableViewMyStationCellInd = @"homeTableViewMyStationCellInd";

static NSString *homeTableViewCompleteCellInd = @"HomeComTableViewCell";
static NSString *homeTableChartsCellInd = @"HomeTableChartsCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (kStatusBarHeight == 20){
        tableTopCon.constant = 44 + 20;
    }
    [self setHeader];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,0,MAINSCREENWIDTH,157);
    self.mainTableV.backgroundColor = [UIColor clearColor];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,MAINSCREENWIDTH,157);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:1/255.0 green:154/255.0 blue:216/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:246/255.0 green:248/255.0 blue:249/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer addSublayer:gl];
    [self.view addSubview:view];
    [self.view sendSubviewToBack:view];
    
    self.title = String(@"工作");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginNoti:) name:NOTIFICATION_LOGIN object:nil];

    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        [self getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];

    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    mainTableV.backgroundColor = [UIColor clearColor];
    
    
    
    [mainTableV registerNib:[UINib nibWithNibName:@"WorkCell0" bundle:nil] forCellReuseIdentifier:@"WorkCell0"];
    [mainTableV registerNib:[UINib nibWithNibName:@"WorkCell1" bundle:nil] forCellReuseIdentifier:@"WorkCell1"];
    [mainTableV registerNib:[UINib nibWithNibName:@"WorkCell2" bundle:nil] forCellReuseIdentifier:@"WorkCell2"];
    [mainTableV registerNib:[UINib nibWithNibName:@"WorkCell3" bundle:nil] forCellReuseIdentifier:@"WorkCell3"];
    
    
    [mainTableV registerNib:[UINib nibWithNibName:@"HomeComTableViewCell" bundle:nil] forCellReuseIdentifier:homeTableViewCompleteCellInd];
    [mainTableV registerNib:[UINib nibWithNibName:@"HomeTableChartsCell" bundle:nil] forCellReuseIdentifier:homeTableChartsCellInd];
}
- (void)setHeader{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, MAINSCREENWIDTH, 44)];
    headView.backgroundColor = [UIColor clearColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = String(@"工作");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [headView addSubview:titleLabel];

    [self.view addSubview:headView];
}


- (void)reloadV{
    [self.mainTableV.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)userLoginNoti:(id)obj{
    [self.mainTableV.mj_header beginRefreshing];
}

- (void)getData:(id)obj{
    
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    weak_self(ws);
    apiBlock.needShowHud =@0;
    [apiBlock startRequest:nil uri:@"mobile/work" result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            ws.dataModel = respModel;
 
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV reloadData];
        [ws.mainTableV.mj_header endRefreshing];
    }];
}

- (void)showMy{
    UserViewController *uV = [[UserViewController alloc] init];
    PUSHNAVICONTROLLER(uV);
}

- (void)showAlarm{
    AlarmNewViewController *uV = [[AlarmNewViewController alloc] init];
    PUSHNAVICONTROLLER(uV);
}

- (void)showNoti{
    NoticeTypeViewController*vc = [[NoticeTypeViewController alloc] init];
      PUSHNAVICONTROLLER(vc)
//    NoticesViewController *vc = [[NoticesViewController alloc] init];
//    PUSHNAVICONTROLLER(vc)
}

- (void)scan{
//    QrScanUploadViewController *qV = [[QrScanUploadViewController alloc] initWithMessage:@"uploadpic_113"];
//   qV.hidesBottomBarWhenPushed = YES;
//   UINavigationController *naVi = [[AppDelegate App].tabC selectedViewController];
//   [naVi pushViewController:qV animated:YES];
    
    CDZQRScanViewController *vc = [[CDZQRScanViewController alloc] init];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:vc];
    nv.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:nv animated:YES completion:^{
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 3) {
//        return 361;
//    }
//    return 10;
    
    switch (indexPath.section) {
        case 0:
            return 138;
            break;
        case 1:
            return 302-50;
            break;
        case 2:
        {
            CGFloat img_w = (MAINSCREENWIDTH-60)/2;
            CGFloat img_h = img_w *63 / 162;
            return img_h *2  + 20 + 47.5;
        }
            break;
        case 3:
            return 302-50;
//            return 102;
            break;
        default:
            break;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 69 - 25;
//    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3) {
        return 10;
    }
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    if (!dataModel){
        return 0;
    }
    if ([dataModel.data[@"showOut"] intValue] == 1) {
        return 4;
    }
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = @"";
    switch (section) {
        case 0:
        {
            return nil;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 69-25)];
            view.backgroundColor = [UIColor clearColor];

            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 44)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = String(@"总览");
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [view addSubview:titleLabel];

            UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            myBtn.frame = CGRectMake(12, 7.5f, 29, 29);
            [myBtn setImage:[UIImage imageNamed:@"icon_nav_my"] forState:UIControlStateNormal];
            [myBtn addTarget:self action:@selector(showMy) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:myBtn];
            
            if (1){
                UIButton *myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                myBtn.frame = CGRectMake(12+ 12 + 29, 7.5f, 29, 29);
                [myBtn setImage:[UIImage imageNamed:@"icon-scan"] forState:UIControlStateNormal];
                [myBtn addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:myBtn];
            }
            
            
            UIButton *alarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            alarmBtn.frame = CGRectMake(MAINSCREENWIDTH - 59 - 22, 11, 22, 22);
            [alarmBtn setImage:[UIImage imageNamed:@"icon_nav_ warning"] forState:UIControlStateNormal];
            [alarmBtn addTarget:self action:@selector(showAlarm) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:alarmBtn];
            
            if (alarmNum > 0) {
                UILabel *dot = [[UILabel alloc] init];
                dot.layer.masksToBounds = YES;
                dot.layer.cornerRadius = 7.5;
                dot.font = [UIFont systemFontOfSize:12];
                dot.textColor = [UIColor whiteColor];
                dot.textAlignment = NSTextAlignmentCenter;
                if(alarmNum<10){
                    dot.frame = CGRectMake(MAINSCREENWIDTH-53.5 - 15,5,15,15);
                    dot.text = TOINTSTRING(alarmNum);
                }else if (alarmNum<99){
                    dot.frame = CGRectMake(MAINSCREENWIDTH-53.5 - 15 -2.5,5,20,15);
                    dot.text = TOINTSTRING(alarmNum);
                }else if (alarmNum<999){
                    dot.frame = CGRectMake(MAINSCREENWIDTH-53.5 - 15 -2.5,5,30,15);
                    dot.text = TOINTSTRING(alarmNum);
                }else{
                    dot.frame = CGRectMake(MAINSCREENWIDTH-53.5 - 15 -5,5,35,15);
                    dot.text = @"999+";
                }
                dot.layer.backgroundColor = [UIColor colorWithRed:247/255.0 green:48/255.0 blue:66/255.0 alpha:1.0].CGColor;
                [view addSubview:dot];
            }
            
            UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            noticeBtn.frame = CGRectMake(MAINSCREENWIDTH - 17 - 22, 11, 22, 22);
            [noticeBtn setImage:[UIImage imageNamed:@"icon_nav_notice"] forState:UIControlStateNormal];
            [noticeBtn addTarget:self action:@selector(showNoti) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:noticeBtn];
            
            if (noticeNum > 0) {
                UIView *dot = [[UIView alloc] init];
                dot.layer.masksToBounds = YES;
                dot.layer.cornerRadius = 5;
                dot.frame = CGRectMake(MAINSCREENWIDTH-23.5,5,10,10);
                dot.layer.backgroundColor = [UIColor colorWithRed:247/255.0 green:48/255.0 blue:66/255.0 alpha:1.0].CGColor;
                [view addSubview:dot];
            }
            
            
            
            return view;
            
        }
            break;
        case 1:
            title = String(@"发电量概况") ;
            break;
        case 2:
            title = String(@"计划电量完成率") ;
            break;
        case 3:
            title = String(@"日发电量柱状图") ;
            break;
        default:
            break;
    }
    return nil;
    
    return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            WorkCell0 *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell0"];
            cell.contentView.frame = CGRectMake(12, 0, MAINSCREENWIDTH-24, cell.contentView.frame.size.height);
            cell.contentView.backgroundColor = [UIColor clearColor];

            cell.backgroundColor = [UIColor yellowColor];
            cell.backgroundView.frame = CGRectMake(12, 0, MAINSCREENWIDTH-24, cell.contentView.frame.size.height);
            
            [cell setData:dataModel andBlock:^(id x) {
                switch ([x intValue]) {
                    case 0:
                        {
                            CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:-1 andParms:@{@"from":@"0",@"user_position":dataModel.data[@"userPosition"]}] ;
                            PUSHNAVICONTROLLER(vc)
                        }
                        break;
                    case 1:
                        {
                            CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:-1 andParms:@{@"from":@"1",@"user_position":dataModel.data[@"userPosition"]}] ;
                            PUSHNAVICONTROLLER(vc)
                        }
                        break;
                    case 2:
                        {
                            CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:-1 andParms:@{@"from":@"2",@"user_position":dataModel.data[@"userPosition"]}] ;
                            PUSHNAVICONTROLLER(vc)
                        }
                        break;
                    default:
                        break;
                }
            }];
            [cell setNeedsDisplay];
            return cell;
        }
            break;
        case 2:
        {
            WorkCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell2"];
            weak_self(ws)
            [cell setData:dataModel andBlock:^(id x) {
                switch ([x intValue]) {
                    case 0:
                        {
                            CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:-1] ;
                            PUSHNAVICONTROLLER(vc)
                        }
                        break;
                        case 1:
                        {
                            InCheckViewController *vc =[[InCheckViewController alloc]initWithAction:2] ;
                            PUSHNAVICONTROLLER(vc)
//                            
//                            [[NFCManager sharedInstance] scanTagWithSuccessBlock:^(NFCNDEFMessage * _Nonnull message) {
//                                NSLog(@"success");
//                                                        } andErrorBlock:^(NSError * _Nonnull error) {
//                                                            NSLog(@"err");
//                                                            
//                                                        }];
                            
                            
                            //[SVProgressHUD showInfoWithStatus:@"开发中" maskType:SVProgressHUDMaskTypeBlack];
                        }
                        break;
                        case 2:
                        {
                            if ([dataModel.data[@"showOut"] intValue] == 1) {
                                
                                CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:2] ;
                                PUSHNAVICONTROLLER(vc)
                            }else{
                                [SVProgressHUD showInfoWithStatus:@"您没有权限" maskType:SVProgressHUDMaskTypeBlack];

                            }
                        }
                        break;
                        case 3:
                        {
                            CheckUpViewController *vc =[[CheckUpViewController alloc]initWithAction:0] ;
                            PUSHNAVICONTROLLER(vc)
                        }
                        break;
                        
                    default:
                        break;
                }
            }];
            return cell;
        }
            break;
        case 3:
        {
            WorkCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell1"];
            weak_self(ws)
            [cell setData:dataModel andType:1];
           
            return cell;
            
//            WorkCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell3"];
//            
//            [cell setData:dataModel];
//            return cell;
        }
            break;
        case 1:
        {
            WorkCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkCell1"];
            weak_self(ws)
            [cell setData:dataModel  andType:0];
            
        
          
            return cell;
        }
            break;
        default:
            break;
    }
    
    
    return [[UITableViewCell alloc] init];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
