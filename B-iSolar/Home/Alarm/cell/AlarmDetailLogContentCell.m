//
//  MissionDealContentCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2024/4/24.
//  Copyright © 2024 Mark.zheng. All rights reserved.
//

#import "AlarmDetailLogContentCell.h"
#import "UIImageView+WebCache.h"
#import "YBImageBrowser.h"
#import "FileDetailViewController.h"
@implementation AlarmDetailLogContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    proLabel.textColor = MAIN_TINIT_COLOR;
    noteLabel.textColor = COLOR_TABLE_TITLE;
    delTimeLabel.textColor = takeTimeLabel.textColor = paidanLabel.textColor =  COLOR_TABLE_DES;
    noteLabel.font = FONTSIZE_TABLEVIEW_CELL_DESCRIPTION;

    delTimeLabel.font = takeTimeLabel.font = paidanLabel.font =  FONTSIZE_TABLEVIEW_CELL_DESCRIPTION2;
    
    tmpV0.backgroundColor = tmpV1.backgroundColor = tmpV2.backgroundColor =MAIN_TINIT_COLOR;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClick:(id)sender {
    if (myBlock) {
        myBlock(nil);
    }
}

- (void)setData:(NSDictionary *)dic  andNeedLine:(BOOL)need andBlock:(nonnull NormalBlock)blcok
{
    myBlock = blcok;
    
    label0.text = TOSTRING(dic[@"createUser"]);
    proLabel.text = [NSString stringWithFormat:@"进度:%@%%",dic[@"rate"]];
    
    noteLabel.text = TOSTRING(dic[@"dealNote"]);
    delTimeLabel.text = [NSString stringWithFormat:@"处理时间:%@",dic[@"dealTime"]];
  
    
    if (!need) {
        tmpV1.hidden = tmpV2.hidden = YES;
    }else{
        tmpV1.hidden = tmpV2.hidden = NO;
    }
    if ([TOSTRING(dic[@"rate"]) isEqualToString:@"100"]) {
        tmpV0.backgroundColor = UIColorFromRGB0xFFFFFF(0x19D39B);
        proLabel.textColor = UIColorFromRGB0xFFFFFF(0x19D39B);
        
    }else{
        proLabel.textColor = tmpV0.backgroundColor=MAIN_TINIT_COLOR;
    }
    
    
//    label1.text = TOSTRING(dic[@"dealTime"]);
//    label2.text = TOSTRING(dic[@"dealNote"]);

    CGFloat width = MAINSCREENWIDTH-20 - 90;
    UILabel*_atest = [[UILabel alloc]initWithFrame:CGRectZero];
    _atest.numberOfLines = 0;
    _atest.text = dic[@"dealNote"];
    _atest.lineBreakMode = NSLineBreakByWordWrapping;
    _atest.font = [UIFont systemFontOfSize:15];
    CGSize baseSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize labelsize = [_atest sizeThatFits:baseSize];
    
    fileList = [NSMutableArray arrayWithArray:dic[@"file_list"]];
    int   fileListCount = [dic[@"file_list"] count];
    int lines = fileListCount/3 + (fileListCount%3 >0 ?1:0);
    CGFloat picwidth = (width-20-20)/3;
    CGFloat picH = picwidth* 1.333333 ;
    
    for (UIView*v in [self subviews]) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i=0; i<lines; i++) {
        for (int j =0; j<3; j++) {
            int index = i*3 + j;
            if (index < fileListCount) {
                UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(100 + (picwidth+20)*j, labelsize.height + 59 + (picH+10)*i  , picwidth, picH)];
                NSURL *url = [NSURL URLWithString:API_FILE_URL([dic[@"file_list"][index][@"filePath"] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
                
                
                if ([[[url absoluteString] lowercaseString] hasSuffix:@".png"] || [[[url absoluteString] lowercaseString] hasSuffix:@".jpg"] || [[[url absoluteString] lowercaseString] hasSuffix:@".jpeg"] )
                {
                    [imv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
                }else if ([[[url absoluteString] lowercaseString] hasSuffix:@".pdf"]) {
                    imv.image = [UIImage imageNamed:@"icon_pdf"];
                }
                else{
                    imv.image = [UIImage imageNamed:@"file"];
                }
                
                imv.tag = 10000+index;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVClick:)];
                tap.numberOfTapsRequired = 1;
                [imv addGestureRecognizer:tap];
                imv.userInteractionEnabled = YES;
                [self addSubview:imv];
            }
        }
    }
}
- (void)imgVClick:(UITapGestureRecognizer*)sender{
    
    UIImageView *imv = sender.view;
    int index = imv.tag - 10000;
    
    NSDictionary *file = fileList[index];
    NSString *filepath = file[@"filePath"];
    if ([[filepath lowercaseString] hasSuffix:@".png"] || [[filepath lowercaseString] hasSuffix:@".jpg"] || [[filepath lowercaseString] hasSuffix:@".jpeg"] ) {
        
        
        NSMutableArray *datas = [NSMutableArray array];
    //                    for (NSString * urlstring in imgList) {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([fileList[index][@"filePath"] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
            YBIBImageData *data = [YBIBImageData new];
            data.imageURL = url;
            data.projectiveView = imv;
            [datas addObject:data];
    //                    }
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = datas;
        browser.currentPage = 1;
        // 只有一个保存操作的时候，可以直接右上角显示保存按钮
        browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
        [browser show];
        
    }else{
        NSURL *url = [NSURL URLWithString:API_FILE_URL([fileList[index][@"filePath"] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        FileDetailViewController * v = [[FileDetailViewController alloc] initWithURL:url];
        [[AppDelegate App] pushView:v];
    }
    
    
    
//    FileDetailViewController * v = [[FileDetailViewController alloc] initWithFilePath:API_FILE_URL(file[@"filePath"])];
//    [self.navigationController pushViewController:v animated:YES];
    
    
    
}


@end
