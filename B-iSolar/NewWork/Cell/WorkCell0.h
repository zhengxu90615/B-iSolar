//
//  HomeTableViewMyStationCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/6/21.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkCell0 : UITableViewCell{
    
    __weak IBOutlet UILabel *des0;
    __weak IBOutlet UILabel *des1;
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    BResponseModel *_myData;
    NormalBlock myBlock;

}
@property (weak, nonatomic) IBOutlet UILabel *numOfStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel2;
- (void)setData:(BResponseModel*)model  andBlock:(NormalBlock)block;
@end

NS_ASSUME_NONNULL_END
