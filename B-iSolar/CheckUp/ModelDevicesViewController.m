//
//  ModelDevicesViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/2.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "ModelDevicesViewController.h"

@interface ModelDevicesViewController ()
{
    NSDictionary *currentModel;
}
@end

@implementation ModelDevicesViewController

-(id)initModel:(NSDictionary*)model
{
    if (self = [super init]){
        currentModel = model;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待查设备";
    // Do any additional setup after loading the view.
}
- (void)getData:(id)sender
{
    [self.mainTableV.mj_header endRefreshing];
}



#pragma mark -- tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = currentModel[@"device"];
    return arr.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *device =  currentModel[@"device"][indexPath.row];

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = device[@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.mj_header.isRefreshing) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}



@end
