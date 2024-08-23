//
//  FileDetailViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/27.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"



@interface FileDetailViewController : BaseViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIWebView *webV;
- (id)initWithFilePath:(NSString *)filePath;
- (id)initWithURL:(NSString *)url;
@end


