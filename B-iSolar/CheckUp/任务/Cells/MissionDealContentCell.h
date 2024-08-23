//
//  MissionDealContentCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/24.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MissionDealContentCell : UITableViewCell
{
    IBOutlet UILabel *label0;
    IBOutlet UILabel *proLabel;
    
    IBOutlet UILabel *noteLabel;
    IBOutlet UILabel *delTimeLabel;
    IBOutlet UILabel *takeTimeLabel;
    IBOutlet UILabel *paidanLabel;
    
    NormalBlock myBlock;
    IBOutlet UIView *tmpV0;
    IBOutlet UIView *tmpV1;
    IBOutlet UIView *tmpV2;
    NSMutableArray *fileList;
}
- (IBAction)buttonClick:(id)sender;
- (void)setData:(NSDictionary *)dic andNeedLine:(BOOL)need andBlock:(nonnull NormalBlock)blcok;
@end

NS_ASSUME_NONNULL_END
