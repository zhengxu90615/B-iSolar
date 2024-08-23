//
//  BaseViewController.m
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/28.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize dataModel;
@synthesize requestHelper;
@synthesize pageIndex;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.topItem.title = @"";

    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    self.requestHelper = [BHttpRequest new];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;


    
    
//    NSDictionary *dic = [BAPIHelper getUserInfo];
//    if (dic) {
//        UIImage *img= [[UIImage alloc] init];
//        img = [img imageWithString:[NSString stringWithFormat:@"%@(%@)",dic[@"username"],dic[@"account"]] font:[UIFont systemFontOfSize:14] width:MAINSCREENWIDTH textAlignment:NSTextAlignmentCenter];
//        
//        self.view.backgroundColor = [UIColor colorWithPatternImage:img];
//    }
    
    
    // Do any additional setup after loading the view.
}
-(BOOL) dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }

    for(UIView *subView in view.subviews) {
        if([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
    }
    return NO;
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
