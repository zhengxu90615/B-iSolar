//
//  UserViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/20.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "UserViewController.h"
#import "HomeTableHeaderView.h"
#import "ChangePwdViewController.h"
@interface UserViewController ()
{
    IBOutlet UIButton *logoutBtn;
    
    
}
@end

@implementation UserViewController
@synthesize mainTableV;
@synthesize pickerV;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.title = String(@"我的");
    
    logoutBtn.backgroundColor = MAIN_TINIT_COLOR;
    logoutBtn.layer.cornerRadius = BUTTON_CORNERRADIUS;
    footV.backgroundColor = [UIColor clearColor];
    [logoutBtn setTitle:String(@"退出登录") forState:UIControlStateNormal];
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNoti:) name:NOTIFICATION_LOGIN object:nil];
}
- (void)loginNoti:(id)noti{
    [mainTableV reloadData];
}

#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0.1f;
    //    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section==0?.1f:80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = section==1?String(@"版本"):String(@"账号");
    
    return [[HomeTableHeaderView alloc] initWithTitle:title andFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 30)];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        return [[UIView alloc] init];
    }else{
        
        return footV;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TOSTRING(@(indexPath.row))];
    if(indexPath.section == 1){
//        cell.textLabel.text = String(@"修改密码");
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }else{
        cell.textLabel.text = String(@"版本号");
//        NSDictionary *userInfo = [BAPIHelper getUserInfo];
        NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
        cell.detailTextLabel.text =  dict[@"CFBundleShortVersionString"];
    }else{
        
        NSDictionary *userInfo = [BAPIHelper getUserInfo];
        cell.textLabel.text = userInfo[@"username"];
        cell.detailTextLabel.text =  userInfo[@"phone"];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
//        ChangePwdViewController*vc = [[ChangePwdViewController alloc] init];
//        PUSHNAVICONTROLLER(vc);
    }else{
//        [pickerV setType:PickerTypeOne andTag:1 andDatas:@[@{@"name":@"7个"}
//                                                           ,@{@"name":@"8个"}
//                                                           ,@{@"name":@"9个"}
//                                                           ,@{@"name":@"10个"}
//                                                           ,@{@"name":@"11个"}
//                                                           ,@{@"name":@"12个"}
//                                                           ,@{@"name":@"13个"}
//                                                           ,@{@"name":@"14个"}
//                                                           ,@{@"name":@"15个"}]];
//         self.pickerV.hiddenCustomPicker = NO;
    }
}


#pragma mark -- customer picker
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath{
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    apiBlock.needShowHud = @1;
    NSDictionary *dic = @{@"num":[[array objectAtIndex:0][@"name"] stringByReplacingOccurrencesOfString:@"个" withString:@""]};
    weak_self(ws);
    [apiBlock startRequest:dic uri:API_SHOW_NUM result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            [SVProgressHUD showSuccessWithStatus:respModel.message];
            
            NSMutableDictionary *newUserInfo = [[NSMutableDictionary alloc] initWithDictionary:[BAPIHelper getUserInfo]];
            newUserInfo[@"showNum"] =dic[@"num"];
            [BAPIHelper saveUserInfo:newUserInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.mainTableV reloadData];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage];
        }
    }];
}

- (IBAction)logoutClick:(id)sender {
    
    BHttpRequest * apiBlock = [BHttpRequest new];
    apiBlock.needShowHud = @0;
    [apiBlock startRequest:nil uri:API_LOGOUT result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
           
        }else{
        }
    }];
    [BAPIHelper saveUserInfo:nil];

    
    [[AppDelegate App] CheckLogin];
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
