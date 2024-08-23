//
//  FileDetailViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/27.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "FileDetailViewController.h"
 #define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface FileDetailViewController ()<UIDocumentInteractionControllerDelegate>
{
    NSString * filePath;
    NSURL * fileURL;
    UIImageView *bgV;
}
@property (nonatomic, strong) UIDocumentInteractionController *DIController;

@end

@implementation FileDetailViewController
- (id)initWithFilePath:(NSString *)fileP{
    if (self = [super init]) {
        filePath = [NSString stringWithString:fileP];
        NSLog(@"%@",filePath);
    }
    return self;
}
- (id)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        fileURL = [url copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = String(@"文件查看");

    _webV.scalesPageToFit=YES;
    _webV.multipleTouchEnabled=YES;
    _webV.userInteractionEnabled=YES;
    
    NSDictionary *dic = [BAPIHelper getUserInfo];
    if (dic) {
//        UIImage *img= [[UIImage alloc] init];
//        img = [img imageWithString:[NSString stringWithFormat:@"%@(%@)",dic[@"username"],dic[@"account"]] font:[UIFont systemFontOfSize:14] width:MAINSCREENWIDTH textAlignment:NSTextAlignmentCenter];
//        self.view.backgroundColor = [UIColor colorWithPatternImage:img];
        
        bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENHEIGHT, MAINSCREENHEIGHT)];
        UIImage *img= [[UIImage alloc] init];
        bgV.image = [img imageWithString:[NSString stringWithFormat:@"%@(%@)",dic[@"username"],dic[@"account"]] font:[UIFont systemFontOfSize:14] width:MAINSCREENWIDTH textAlignment:NSTextAlignmentCenter];
        [self.view addSubview:bgV];
        [self.view sendSubviewToBack:bgV];
        bgV.center = self.view.center;
        
        
   
//        double rads = DEGREES_TO_RADIANS(45);
//        CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, rads);
//        bgV.transform = transform;
        
       
        bgV.transform = CGAffineTransformMakeRotation(-45);
    }
    NSURLRequest *request;
    if(fileURL){
        request =[NSURLRequest requestWithURL:fileURL];
        
        
        self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveFileToPhone)];
       
    }else{
        
        
        
        NSString* encodedString = [filePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedString];
        request = [NSURLRequest requestWithURL:url];
    }
   
    [self.webV loadRequest:request];
    
    self.webV.backgroundColor = [UIColor clearColor];
    
    [self.webV setOpaque:NO];
    
    
    // Do any additional setup after loading the view from its nib.
}




- (void)viewWillDisappear:(BOOL)animated
{
    bgV.hidden = YES;
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    bgV.hidden = NO;
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//保存文件到手机文件指定目录
- (void)saveFileToPhone {
    
    self.DIController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    self.DIController.delegate = self;// 遵循代理
//    documentController.UTI = @"com.adobe.pdf"; // 哪类文件支持第三方打开，这里不证明就代表所有文件！
//    documentController.name = @"111.pdf";
    [self.DIController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];

    
//    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@",fileURL]] inMode:UIDocumentPickerModeOpen];
//    documentPicker.delegate = self;
//    documentPicker.modalPresentationStyle = UIModalPresentationFormSheet;
//    [self presentViewController:documentPicker animated:YES completion:nil];
}

#pragma mark - UIDocumentInteractionControllerDelegate

-(UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller{
    return self;
}

-(UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray <NSURL *>*)urls {
     //保存成功
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
     //取消保存
}


@end
