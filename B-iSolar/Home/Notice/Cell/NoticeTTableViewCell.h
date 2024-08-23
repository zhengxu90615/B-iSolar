//
//  NoticeTTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/18.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeTTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    
    IBOutlet UILabel *detailLabel;
    IBOutlet UILabel *tagNameLabel;
    IBOutlet UIImageView *tagBgImg;
    
    IBOutlet NSLayoutConstraint *topCons;
    
}

- (void)setTagName:(NSString *)tagName;
- (void)setName:(NSString*)name detail:(NSString*)detail;
- (void)setName2:(NSString*)name detail:(NSString*)detail;
@end

NS_ASSUME_NONNULL_END
