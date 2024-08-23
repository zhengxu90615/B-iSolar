//
//  CheckPointsViewController.h
//  B-iSolar
//
//  Created by Mark.zheng on 2024/3/13.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "BaseViewController.h"
#import <CoreNFC/CoreNFC.h>
#import "CustomPicker.h"
NS_ASSUME_NONNULL_BEGIN

@interface CheckPointsViewController : BaseViewController
{
 
    CustomPicker *pickerV;

    
    IBOutlet UITableView *mainTableV;
}

@property (strong, nonatomic) NSString *selectTime;
@property(nonatomic,strong) CustomPicker *pickerV;

@property(nonatomic,strong)UIView *sepView;
@property (strong, nonatomic) UITableView *mainTableV;


@property(strong, nonatomic)NFCNDEFReaderSession *session;
@property(strong, nonatomic)id<NFCNDEFTag>currentTag;
@end

NS_ASSUME_NONNULL_END
