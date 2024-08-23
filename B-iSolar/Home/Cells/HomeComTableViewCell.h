//
//  HomeComTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/10/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"
#import "MKSegmentControl.h"
#import "MKYBChartView.h"
NS_ASSUME_NONNULL_BEGIN



@interface HomeComTableViewCell : UITableViewCell<MKSegmentControlDelegate>
{
    NSInteger currentIndex;
    BResponseModel *dataModel;
    BOOL        *isYuce;
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIView *inV;
    
    IBOutlet UIImageView *tongbiImg;
    IBOutlet UILabel *tongbiLabel;
    
    IBOutlet UIImageView *huanbiImg;
    IBOutlet UILabel *huanbiLabel;
    
    
    IBOutlet UILabel *la1;
    IBOutlet UILabel *la2;
    
    
}
- (IBAction)buttonClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet MKSegmentControl *segComtrol;

@property (nonatomic, weak) IBOutlet PYEchartsView *kEchartView;

@property (nonatomic, weak) IBOutlet MKYBChartView *mkchartView;



- (void)setData:(BResponseModel*)model;

@end

NS_ASSUME_NONNULL_END
