//
//  CheckLocationCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/6/28.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DottedLineView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,Location_location) {
    Location_location_First   = 0,
    Location_location_Normal  = 1,
    Location_location_Last    = 2,
};
@interface CheckLocationCell : UITableViewCell
{
    IBOutlet UIImageView *imageV;
    IBOutlet UILabel *nameLabel;
    IBOutlet UIButton *button;
    NormalBlock myBlock;
    DottedLineView * dotView;
}
- (void)setData:(NSDictionary*)data andLocation_location:(Location_location)location andButtonClick:(nonnull NormalBlock)block;
- (IBAction)buttonClick:(id)sender;
@end

NS_ASSUME_NONNULL_END
