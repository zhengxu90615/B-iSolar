//
//  NoticeDetailTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2019/9/29.
//  Copyright © 2019 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^AttachClick)(int index);

@interface NoticeDetailTableViewCell : UITableViewCell
{
    IBOutlet UIView *bgView;
    
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *dateLabel;
    
    IBOutlet UIView *line0;
    IBOutlet UILabel *fujianLabel;
    
}
@property (copy, nonatomic) AttachClick attClick;

- (void)setData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
