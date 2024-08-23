//
//  HomeTableViewElecCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeTableViewElecCell : UITableViewCell
{
    __weak IBOutlet UILabel *elecLabel;
    __weak IBOutlet UILabel *desc;
    __weak IBOutlet UILabel *desc1;
    __weak IBOutlet UILabel *desc2;
    __weak IBOutlet UISegmentedControl *segmentControl;
    
    __weak IBOutlet UILabel *treeLabel;
    __weak IBOutlet UILabel *co2Label;
    BResponseModel* dataModel;
    
    __weak IBOutlet UIImageView *img1;
    __weak IBOutlet UIImageView *img2;
    __weak IBOutlet UIImageView *img3;

    NormalBlock myBlock;
}
- (IBAction)segChanged:(id)sender;
- (void)setData:(BResponseModel*)model andBlock:(NormalBlock)block;

@end

NS_ASSUME_NONNULL_END
