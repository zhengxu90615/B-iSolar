//
//  CheckUpDeatailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/10.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "CheckUpDeatailViewController.h"
#import "Select3StationHeaderView.h"
#import "ChildNameCell.h"
#import "ErrorInputTableViewCell.h"
#import "CheckSthCell.h"
#import "CheckUpImgCell.h"
#import "YBImageBrowser.h"

@interface CheckUpDeatailViewController ()<UITextFieldDelegate>
{
    NSDictionary *dataDic;
    Select3StationHeaderView * checkHeadView;
    NSMutableArray *newCheckDataArray,*newTypeDataArray;
    BOOL canEdit;
    
    UITableViewCell *tmpCell;
    id tmpExValue;
    NSIndexPath *tmpIndexPath;
    NSString * locationString,*city;
    
    BOOL isMannual;
    NSMutableArray * areaArr;
    NSDictionary *currentArea, *currentStation,*currentType;
    NSString*currentDate;
    
}

@property(nonatomic,readwrite)BOOL added,isLoaded;

@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation CheckUpDeatailViewController
@synthesize mainTableV;
@synthesize pickerV;

- (id)initWithData:(NSString *)dic andEdit:(BOOL)canEd{
    if(self=[super init]){
        canEdit = canEd;
        if(dic)
            dataDic = [[NSDictionary alloc] initWithDictionary:dic];
    }
    return self;
}

- (IBAction)submitClick:(id)sender {
//    ["ExternalStation_id", "ExternalStation_type", "dataList", "inspectionPer", "inspectionDate"]
    if(!currentStation)
    {
        [SVProgressHUD showErrorWithStatus:String(@"请选择电站")];
        return;
    }
    if(!currentType)
    {
        [SVProgressHUD showErrorWithStatus:String(@"请选择电站类型")];
        return;
    }
    if(!currentDate)
    {
        [SVProgressHUD showErrorWithStatus:String(@"请选择巡检时间")];
        return;
    }
    if([peopleLabel.text  isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:String(@"请输入巡检人员")];
        return;
    }
    
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    requestHelper.needShowHud =@1;
    parmDic[@"ExternalStation_id"] = currentStation[@"itemId"];
    parmDic[@"ExternalStation_type"] = currentType[@"id"];
    parmDic[@"inspectionPer"] = peopleLabel.text;
    parmDic[@"inspectionDate"] = currentDate;

    parmDic[@"dataList"] = [newCheckDataArray JSONString];
    
    if(dataDic)
        parmDic[@"id"] = dataDic[@"id"];

    
    weak_self(ws);
    [requestHelper startRequest:parmDic uri:API_ExternalSaveApi result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            
            [SVProgressHUD showSuccessWithStatus:String(@"成功")];
            [ws.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电站巡检报告上传";//dataDic[@"name"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    weak_self(ws);
    checkHeadView = [[Select3StationHeaderView alloc] initWithTitle:@[@"地区",@"类型",@"巡检时间"] andButtonClick:^(id x) {
        if(!canEdit)
            return;
        [ws headCheckClick:[x intValue]];

    }];
    
    [self.view addSubview:checkHeadView];
    
    float h = kNavigationHeight + kBottomSafeAreaHeight;

    self.mainTableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+ 44+ 44, MAINSCREENWIDTH, MAINSCREENHEIGHT-h- 44*3 + 2) style:UITableViewStylePlain];
    mainTableV.delegate = self;
    mainTableV.dataSource = self;
    mainTableV.backgroundColor = [UIColor clearColor];
    mainTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 15.0, *)) {
        self.mainTableV.sectionHeaderTopPadding = 0;
    }
    
    [self.view addSubview:mainTableV];
    
//    if (dataDic) {
        //新增 不给下拉刷新
    self.mainTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getData:nil];
    }];
    [self.mainTableV.mj_header beginRefreshing];
    
    
    self.mainTableV.backgroundColor = [UIColor whiteColor];
    
    nameLabel.layer.borderColor = COLOR_TABLE_DES.CGColor;
    nameLabel.layer.borderWidth = 0.5f;
    nameLabel.layer.cornerRadius = 3.0f;
    nameLabel.clipsToBounds = YES;
    nameLabel.delegate = self;
    
    peopleLabel.layer.borderColor = COLOR_TABLE_DES.CGColor;
    peopleLabel.layer.borderWidth = 0.5f;
    peopleLabel.layer.cornerRadius = 3.0f;
    peopleLabel.clipsToBounds = YES;
    peopleLabel.delegate = self;

    submitBtn.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    submitBtn.clipsToBounds = YES;
    submitBtn.backgroundColor = MAIN_TINIT_COLOR;
    
    [mainTableV registerNib:[UINib nibWithNibName:@"ChildNameCell" bundle:nil] forCellReuseIdentifier:@"ChildNameCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"ErrorInputTableViewCell" bundle:nil] forCellReuseIdentifier:@"ErrorInputTableViewCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckSthCell" bundle:nil] forCellReuseIdentifier:@"CheckSthCell"];
    [mainTableV registerNib:[UINib nibWithNibName:@"CheckUpImgCell" bundle:nil] forCellReuseIdentifier:@"CheckUpImgCell"];

    [self setEdit];
    
    self.pickerV = [[CustomPicker alloc] init];
    self.pickerV.backgroundColor = UIColorFromHex(0xf0f0f0);
    self.pickerV.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark ---- uitextInputDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == nameLabel)
    {
        [self headCheckClick:3];
        return NO;
    }else{
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [peopleLabel resignFirstResponder];
    return YES;
}


- (void)setEdit{
    nameLabel.enabled = peopleLabel.enabled = canEdit;
    
    
    
}


- (void)headCheckClick:(int)index
{
    [peopleLabel resignFirstResponder];
    
    if(index == 2)
    {
        [self.pickerV setType:PickerTypeYYYYMMDD andTag:2 andDatas:areaArr];
        [pickerV setCurrentY:[NSDate year] M:[NSDate month] D:[NSDate day]];
        self.pickerV.hiddenCustomPicker = NO;
        return;
    }
    
    if(index == 1){
        
        [self.pickerV setType:PickerTypeOne andTag:1 andDatas:newTypeDataArray];
        self.pickerV.hiddenCustomPicker = NO;
        return;
    }
    
    weak_self(ws);
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
    requestHelper.needShowHud =@1;
    [requestHelper startRequest:parmDic uri:API_ExternalStationApi result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
            areaArr = [[NSMutableArray alloc] init];
            if (index==0)
            {
                for (NSDictionary * dic in respModel.data) {
                    if([dic[@"pId"] intValue]==0)
                    {
                        [areaArr addObject:dic];
                    }
                }
                [ws.pickerV setType:PickerTypeOne andTag:0 andDatas:areaArr];
                self.pickerV.hiddenCustomPicker = NO;
            }else{
                for (NSDictionary * dic in respModel.data) {
                    if([dic[@"pId"] intValue]==0)
                    {
                        [areaArr addObject:dic];
                    }
                }
                
                for (int i =0; i< areaArr.count;i++) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:areaArr[i]];
                    NSMutableArray * tmpArr = [NSMutableArray array];
                    for (NSDictionary * tmpDic in respModel.data) {
                        if( [tmpDic[@"areaId"] intValue] == -2 &&  [tmpDic[@"pId"] intValue]==[dic[@"id"] intValue])
                        {
                            [tmpArr addObject:tmpDic];
                        }
                    }
                    dic[@"list"] = tmpArr;
                    areaArr[i] = dic;
                }
                
                [ws.pickerV setType:PickerTypeTwo andTag:3 andDatas:areaArr];
                self.pickerV.hiddenCustomPicker = NO;
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
    }];
      
}


- (void)getData:(id)sender{
    if ([BAPIHelper getToken].length==0) {
        return;
    }
    
    if(!dataDic && newCheckDataArray){
        [self.mainTableV.mj_header endRefreshing];
        return;
    }
    
    weak_self(ws);
    [requestHelper stop];
    
        
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];

    if (dataDic){
        [parmDic setObject:dataDic[@"id"] forKey:@"id"];
    }
    requestHelper.needShowHud =@0;
    [requestHelper startRequest:parmDic uri:API_ExternalDetailApi result:^(BResponseModel * _Nonnull respModel) {
        if (respModel.success) {
        
            if(!dataDic)
            {
                [self.mainTableV.mj_header  setHidden:YES];
            }
            ws.dataModel = respModel;
            newCheckDataArray = [[NSMutableArray alloc] initWithArray:respModel.data[@"dataList"]];
            newTypeDataArray = [[NSMutableArray alloc] initWithArray:respModel.data[@"typeList"]];

            nameLabel.text = ws.dataModel.data[@"ExternalStation_name"];
            peopleLabel.text =ws.dataModel.data[@"inspectionPer"];
            
            
            if(dataDic)
            {
                NSDictionary *dic =ws.dataModel.data;
                [checkHeadView setTitle0:dic[@"ExternalStation_area_name"] title1:ws.dataModel.data[@"ExternalStation_type_name"] title2:ws.dataModel.data[@"inspectionDate"]];
                
                currentArea = @{@"id":dic[@"ExternalStation_area_id"] , @"name":dic[@"ExternalStation_area_name"]};
                currentStation = @{@"itemId":dic[@"ExternalStation_id"] , @"name":dic[@"ExternalStation_name"]};
                currentType = @{@"id":dic[@"ExternalStation_type"] , @"name":dic[@"ExternalStation_type_name"]};
//                currentArea = @{};
                currentDate = dic[@"inspectionDate"];
            }
                
            else{
                
                
            }
        }else{
            [SVProgressHUD showErrorWithStatus:respModel.errorMessage?respModel.errorMessage:respModel.message];
        }
        [ws.mainTableV.mj_header endRefreshing];
        [ws.mainTableV reloadData];
    }];
}



#pragma mark --UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *child = newCheckDataArray[indexPath.section];
    NSArray * children = child[@"children"];
    int index = 0;
    if(children && [children count]>0)
        
        for (NSDictionary * dic in children)
        {
            NSArray *secondChildren = dic[@"children"];

            if(index == indexPath.row)
            {
                return 32;
                
            }else if(index + [secondChildren count] + 1 == indexPath.row){
                
                float imgW = (MAINSCREENWIDTH-60)/3;
                
                return imgW*3/4 + 20;
            }else{
                if(indexPath.row > index + [secondChildren count]){
                    index +=1; //title
                    index += [secondChildren count];
                    index +=1; //image
                }else{
                    return 44;
                }
            }
            
        }
    else{
        //没有子集，只有一个input框
        return 120;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(newCheckDataArray){
        return [newCheckDataArray count];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary * dic = newCheckDataArray[section];
    int count = 0;
    
    NSArray * children = dic[@"children"];
    if(children && [children count]>0)
        for (NSDictionary * dic in children) {
            count +=1;  //title
            NSArray *secondChildren = dic[@"children"];
            count += [secondChildren count];
            count +=1; //image
        }
    else{
        //没有子集，只有一个input框
        return 1;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 32.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(newCheckDataArray){
        if(section == newCheckDataArray.count-1){
            return canEdit?40+10:0;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *child = newCheckDataArray[section];
    UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 32)];
    headV.backgroundColor = MAIN_BACKGROUND_COLOR;
    
    UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAINSCREENWIDTH-20, 32)];
    label.text = child[@"name"];
    label.textColor = MAIN_TINIT_COLOR;
    label.font = FONTSIZE_TABLEVIEW_HEADER;
    [headV addSubview:label];
    
    return headV;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(newCheckDataArray){
        if(section == newCheckDataArray.count-1){
            
            return canEdit?footView:nil;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *child = newCheckDataArray[indexPath.section];
    NSArray * children = child[@"children"];
    int index = 0;
    weak_self(ws);
    int x1 = 0;
    if(children && [children count]>0)
        
        for (NSDictionary * dic in children)
        {
            NSArray *secondChildren = dic[@"children"];

            if(index == indexPath.row)
            {
                ChildNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChildNameCell"];
                cell.nameBale.text = dic[@"name"];
                return cell;
                
            }else if(index + [secondChildren count] + 1 == indexPath.row){
                CheckUpImgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckUpImgCell"];
                NSArray *imgList = dic[@"imgList"];
                cell.tag = x1 * 1000;

                [cell setData:dic  canEdit:canEdit andBlock:^(id x) {
                    int index = [x intValue];
                    
                    if(index >= 1000)
                    {
                        NSLog(@"新增图片%d",index-1000);
//                        ws
                        
                        [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:@(index-1000) andtype:3];

                    }else{
                        NSMutableArray *datas = [NSMutableArray array];
    //                    for (NSString * urlstring in imgList) {
                            NSURL *url = [NSURL URLWithString:API_FILE_URL([imgList[index] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
                            YBIBImageData *data = [YBIBImageData new];
                            data.imageURL = url;
                            data.projectiveView =[cell viewWithTag:1000+index];
                            [datas addObject:data];
    //                    }
                        
                        YBImageBrowser *browser = [YBImageBrowser new];
                        browser.dataSourceArray = datas;
                        browser.currentPage = 1;
                        // 只有一个保存操作的时候，可以直接右上角显示保存按钮
                        browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
                        [browser show];
                    }
                } andDelImgBlock:^(id x) {
                    NSLog(@"删除图片%@",x);
                    [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:1];

                }];
                
                return cell;
            }else{
                if(indexPath.row > index + [secondChildren count]){
                    index +=1; //title
                    index += [secondChildren count];
                    index +=1; //image
                }else{
                    NSDictionary * selectDic = secondChildren[indexPath.row - index -1];
                    CheckSthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckSthCell"];
                    cell.tag = x1 * 1000 + indexPath.row - index -1;
                    [cell setData:selectDic  canEdit:canEdit andBlock:^(id x) {
                        NSLog(@"选择项%@",x);
                        [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:0];
                    }];
                    return cell;
                }
            }
            x1 += 1;
        }
    else{
        //没有子集，只有一个input框
        weak_self(ws)
        ErrorInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorInputTableViewCell"];
        cell.tag = x1 * 1000;
        [cell setData:child andCanEdit:canEdit andBlock:^(id x) {
            float h = kNavigationHeight + kBottomSafeAreaHeight;
            ws.mainTableV.frame = CGRectMake(0, 44+ 44+ 44, MAINSCREENWIDTH, MAINSCREENHEIGHT-h- 44*3 + 2) ;
            
            [ws resetDataWithSection:indexPath.section row:indexPath.row andCell:cell andEx:x andtype:2];

            
        }andBlock2:^(id x) {
            float h = kNavigationHeight + kBottomSafeAreaHeight;
            ws.mainTableV.frame = CGRectMake(0, 44+ 44+ 44, MAINSCREENWIDTH, MAINSCREENHEIGHT-h- 44*3 + 2 - 256) ;
                        [ws.mainTableV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        }];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




// 刷新数据
- (void)resetDataWithSection:(int)section row:(int)row andCell:(UITableViewCell*)cell andEx:(id)exValue andtype:(int)type  //0:seg 1:img del 2:input 3:img new  4:up img
{
    NSMutableDictionary * data = [[NSMutableDictionary alloc] initWithDictionary:newCheckDataArray[section]];
    NSMutableArray * dataChildren = [[NSMutableArray alloc] initWithArray:data[@"children"]];

    int x1 = (int)cell.tag/1000;
    int x2 = cell.tag%1000;
    
    if(type == 0)
    {
        NSMutableDictionary * data1 = [[NSMutableDictionary alloc] initWithDictionary:dataChildren[x1]];
        NSMutableArray * data1Children = [[NSMutableArray alloc] initWithArray:data1[@"children"]];
        
        NSMutableDictionary * data2 = [[NSMutableDictionary alloc] initWithDictionary:data1Children[x2]];
        NSMutableArray *data2Children = [[NSMutableArray alloc] initWithArray:data1[@"children"]];

        data2[@"value"] = exValue;
        
        data2Children[x2] = data2;
        
        data1[@"children"] = data2Children;
        dataChildren[x1] = data1;
        
        data[@"children"] = dataChildren;
        newCheckDataArray[section] = data;
    }else if(type == 1){
        NSMutableDictionary * data1 = [[NSMutableDictionary alloc] initWithDictionary:dataChildren[x1]];
        NSMutableArray * data1Children = [[NSMutableArray alloc] initWithArray:data1[@"children"]];
        
        NSMutableArray * imgListArr = [[NSMutableArray alloc] initWithArray:data1[@"imgList"]];
        imgListArr[[exValue intValue]] = @"";
        data1[@"imgList"] = imgListArr;
        
        dataChildren[x1] = data1;
        data[@"children"] = dataChildren;
        newCheckDataArray[section] = data;

    }else if(type == 2){
        data[@"value"] = exValue;
        newCheckDataArray[section] = data;
        
        
    }else if (type ==3){
        tmpIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        tmpCell = cell;
        tmpExValue = exValue;
        
        
        [self showActions];
        
        return;
    }else if (type ==4){
        
        NSMutableDictionary * data1 = [[NSMutableDictionary alloc] initWithDictionary:dataChildren[x1]];
        NSMutableArray * data1Children = [[NSMutableArray alloc] initWithArray:data1[@"children"]];
        
        NSMutableArray * imgListArr = [[NSMutableArray alloc] initWithArray:data1[@"imgList"]];
        imgListArr[[exValue[0] intValue]] = exValue[1];
        data1[@"imgList"] = imgListArr;
        
        dataChildren[x1] = data1;
        data[@"children"] = dataChildren;
        newCheckDataArray[section] = data;
        
    }
    
    [mainTableV reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)showActions{
   weak_self(ws)
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
   UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//       [ws.navigationController popViewControllerAnimated:YES];
   }];
   UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [ws openLibary];
   }];
   UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [ws openCamera];
   }];
   [alertController addAction:cancelAction];
   [alertController addAction:okAction];
   [alertController addAction:resetAction];
   [self presentViewController:alertController animated:YES completion:nil];
}
- (void)openLibary{
   if (![self isLibaryAuthStatusCorrect]) {\
       [SVProgressHUD showErrorWithStatus:@"需要相册权限"];
       return;
   }
   _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)openCamera{
   if (![self statusCheck]) {
//       [SVProgressHUD showErrorWithStatus:@"需要相册权限"];
       return;
   }
   _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

   [self presentViewController:self.imagePicker animated:YES completion:nil];
}
- (BOOL)isLibaryAuthStatusCorrect{
   PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
   if (authStatus == PHAuthorizationStatusNotDetermined || authStatus == PHAuthorizationStatusAuthorized) {
       return YES;
   }
   return NO;
}

- (BOOL)statusCheck{
    if (![self isCameraAvailable]){
        [SVProgressHUD showErrorWithStatus:@"设备无相机——设备无相机功能，无法进行扫描"];
        return NO;
    }
    if (![self isRearCameraAvailable] && ![self isFrontCameraAvailable]) {
        [SVProgressHUD showErrorWithStatus:@"设备相机错误——无法启用相机，请检查"];
        return NO;
    }
    if (![self isCameraAuthStatusCorrect]) {
        [SVProgressHUD showErrorWithStatus:@"未打开相机权限 ——请在“设置-隐私-相机”选项中，允许滴滴访问你的相机"];
        return NO;
    }
    return YES;
}


- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isCameraAuthStatusCorrect{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    return NO;
}


#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)editingInfo{
    weak_self(ws);
    requestHelper.needShowHud =@1;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
//    [parmDic setObject:TOSTRING(checkWork[@"id"]) forKey:@"check_id"];
//    [requestHelper startUploadImage:image withP:parmDic uri:API_CHECK_MISSION_FILE_UPLOAD result:^(BResponseModel * _Nonnull resp) {
//        [picker dismissViewControllerAnimated:YES completion:^{
//            [ws.footV setImage:image orUrl:nil];
//        }];
//
//    }];
}
- (void)  imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info
{
        UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
        
        weak_self(ws);
        requestHelper.needShowHud =@1;
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        
        if(city)
            if([[city substringFromIndex:city.length-1] isEqualToString:@"市"])
                city = [city substringToIndex:city.length-1];
            parmDic[@"city"] = city;
        if(locationString)
            parmDic[@"location"] = locationString;
        
        if(_added)
        {
            parmDic[@"longAndLat"] = [NSString stringWithFormat:@"%.6f,%.6f",
                                                               self.locationManager.location.coordinate.longitude,
                                                               self.locationManager.location.coordinate.latitude];

        }
    
        [requestHelper startUploadImage:image withP:parmDic uri:API_ExternalPicUploadApi result:^(BResponseModel * _Nonnull resp) {
             if (resp.success) {
                [ws resetDataWithSection:tmpIndexPath.section row:tmpIndexPath.row andCell:tmpCell andEx:@[tmpExValue, resp.data[@"filePath"]] andtype:4];

//                errorDiction[@"img_path"] = resp.data[@"path"];
                [picker dismissViewControllerAnimated:YES completion:^{
//                    [ws.footV setImage:image orUrl:nil];
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:resp.errorMessage?resp.errorMessage:resp.message];
            }
        }];
}




- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.locationManager startUpdatingLocation];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationManager *)locationManager{
    if (_locationManager==nil) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//精度设置
        _locationManager.distanceFilter=1000.0f;//设备移动后获取位置信息的最小距离
        _locationManager.delegate=self;
        [_locationManager requestWhenInUseAuthorization];//弹出用户授权对话框，使用程序期间授权
    }
    return _locationManager;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.added = NO;

//    locationString = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f\n高度:%3.5f",
//                             self.locationManager.location.coordinate.longitude,
//                             self.locationManager.location.coordinate.latitude,
//                             self.locationManager.location.altitude];
//    NSLog(@"%@",locationString);
    weak_self(ws)
    
    //创建CLGeocoder对象
       CLGeocoder *geocoder = [CLGeocoder new];
    
       //对应经纬度的详细信息(addressDictionary)
       [geocoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
           if (error == nil) {
               for (CLPlacemark *placemark in placemarks) {
                   NSArray *lines = placemark.addressDictionary[@"FormattedAddressLines"];
                   city = placemark.addressDictionary[@"City"];
                   
                   if (lines.count >0 && !ws.added)
                   {
                       ws.added = YES;
//                       locationString = [locationString stringByAppendingString:@"\n"];
                       locationString = placemark.addressDictionary[@"FormattedAddressLines"][0];
                   }
                   NSLog(@"%@",locationString);

                   
               }
           }
       }];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"E:%@",error);
}

- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler;
{
    
}










#pragma mark --CustomPicker delegate
- (void)pickerView:(CustomPicker *)v selected:(NSArray *)array andIndexPath:(NSIndexPath *)indexpath
{
   
   if(v.tag == 2)
   {
       currentDate = [NSString stringWithFormat:@"%@-%@-%@",array[0],array[1],array[2]];
       [checkHeadView setTitle0:nil title1:nil title2:currentDate];

       isMannual = NO;
//       [self.mainTableV.mj_header beginRefreshing];
   }else if (v.tag==1)
   {
       isMannual = NO;
       currentType = array[0];
       [checkHeadView setTitle0:nil title1:currentType[@"name"] title2:currentDate];

//       currentArea = array[0];
//       currentStation = array[1];
////       [self.mainTableV.mj_header beginRefreshing];
//       [checkHeadView setTitle0:array[0][@"name"] title1:array[1][@"name"] title2:nil];

       
   }else if (v.tag==0)
   {
       isMannual = NO;
       
       NSDictionary * newArea = array[0];
       if([newArea[@"id"] intValue] !=  [currentArea[@"id"] intValue])
       {
           currentArea = array[0];
           currentStation = nil;
           
           nameLabel.text = @"";
           peopleLabel.text = @"";
       }else{
           
       }
      
       [checkHeadView setTitle0:currentArea[@"name"] title1:nil title2:currentDate];

//       [self.mainTableV.mj_header beginRefreshing];

   }else if (v.tag==3)
   {
       isMannual = NO;
       currentArea = array[0];
       currentStation = array[1];
       
       [checkHeadView setTitle0:currentArea[@"name"] title1:nil title2:nil];
       nameLabel.text = currentStation[@"name"];
       peopleLabel.text = currentStation[@"inspectionPer"];
//       [self.mainTableV.mj_header beginRefreshing];

   }
    
}


@end
