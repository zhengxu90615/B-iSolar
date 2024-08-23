//
//  QrScanUploadViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2020/7/14.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import "QrScanUploadViewController.h"
#import <Photos/Photos.h>

@interface QrScanUploadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    NSString *pid;
}
@property (nonatomic ,strong) UIImagePickerController *imagePicker;

@end

@implementation QrScanUploadViewController
- (id)initWithMessage:(NSString*)mess{
    if (self = [super init]) {
        pid = [mess stringByReplacingOccurrencesOfString:@"uploadpic_" withString:@""];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [copyBtn setTintColor:WHITE_COLOR];
    [copyBtn setBackgroundColor:MAIN_TINIT_COLOR];
    copyBtn.titleLabel.font = FONTSIZE_TABLEVIEW_CELL_TITLE;
    copyBtn.layer.cornerRadius =  BUTTON_CORNERRADIUS;    // Initialization code
    copyBtn.clipsToBounds = YES;
    self.title = @"上传图片";
    UIBarButtonItem *libaryItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:UIBarButtonItemStylePlain target:self action:@selector(showActions)];
    self.navigationItem.rightBarButtonItem = libaryItem;
    
    _imagePicker = [[UIImagePickerController alloc]init];
    _imagePicker.delegate = self;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self showActions];
}

- (void)showActions{
    weak_self(ws)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [ws.navigationController popViewControllerAnimated:YES];
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
    if (![self isLibaryAuthStatusCorrect]) {
        [SVProgressHUD showErrorWithStatus:@"需要相册权限"];
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

- (IBAction)btnClick:(id)sender {
        
    if (imgV.image) {
        
        weak_self(ws);
        requestHelper.needShowHud =@1;
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc] init];
        parmDic[@"pid"] = pid;
        [requestHelper startUploadImage:imgV.image withP:parmDic uri:API_QR_UPLOAD result:^(BResponseModel * _Nonnull resp) {
            if (resp.success) {

                [ws.navigationController popViewControllerAnimated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:resp.errorMessage?resp.errorMessage:resp.message];
            }
        }];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"请先拍照或从相册选择图片"];
    }
}

#pragma mark - imagePickerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self showActions];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    imgV.image = image;
    
    
    
}



@end
