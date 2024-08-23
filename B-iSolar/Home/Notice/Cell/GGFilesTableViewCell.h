//
//  GGFilesTableViewCell.h
//  B-iSolar
//
//  Created by Mark.zheng on 2020/11/3.
//  Copyright © 2020 Mark.zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^AttachClick)(NSDictionary* data);

@interface GGFilesTableViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UIImageView *imgV;
    IBOutlet UIButton *btn;
    
    NSDictionary *dataDic;
    
}
- (void)setData:(NSDictionary *)data;
- (IBAction)click:(id)sender;
@property (copy, nonatomic) AttachClick attClick;


@end

NS_ASSUME_NONNULL_END
