//
//  CheckUpImgCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/11.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckUpImgCell : UITableViewCell
{
    IBOutlet UIView *bgV;
    BOOL canEdit;
    NormalBlock myBlock;
    NormalBlock myBlock2;
    IBOutlet UIImageView *img0;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    
    IBOutlet UIButton *btn0;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    NSMutableArray *picDatas;
    
    BOOL isPPPPPPP;
}
- (IBAction)imgClick:(id)sender;
- (IBAction)delBtnClick:(id)sender;

- (void)setData:(NSDictionary *)dic canEdit:(BOOL)canEdit andBlock:(NormalBlock)block andDelImgBlock:(NormalBlock)block2 ;
- (void)setData2:(NSArray *)dic canEdit:(BOOL)canEdit andBlock:(NormalBlock)block andDelImgBlock:(NormalBlock)block2 ;

@end

NS_ASSUME_NONNULL_END
