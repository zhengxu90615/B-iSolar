//
//  CheckUpImgCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/11.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "CheckUpImgCell.h"
#import "UIImageView+WebCache.h"

@implementation CheckUpImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    img0.backgroundColor= img1.backgroundColor= img2.backgroundColor= COLOR_TABLE_SEP;
    bgV.backgroundColor = MAIN_BACKGROUND_COLOR;
    // Initialization code
    

    isPPPPPPP = NO;
    [img0 setImage:[UIImage imageNamed:@"jiahao"]];
    [img1 setImage:[UIImage imageNamed:@"jiahao"]];
    [img2 setImage:[UIImage imageNamed:@"jiahao"]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setData:(NSDictionary *)dic canEdit:(BOOL)canEd andBlock:(NormalBlock)block andDelImgBlock:(nonnull NormalBlock)block2
{
    canEdit = canEd;
    btn0.hidden = btn1.hidden = btn2.hidden = !canEdit;
    myBlock = block;
    myBlock2 = block2;
    picDatas = [[NSMutableArray alloc] initWithArray:dic[@"imgList"]];
   
    if(![picDatas[2] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[2] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img2 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img2.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn2.hidden = YES;
    }
    
    if(![picDatas[1] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[1] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img1.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn1.hidden = YES;
    }
    if(![picDatas[0] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[0] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img0 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img0.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn0.hidden = YES;
    }
}


- (void)setData2:(NSArray *)dic canEdit:(BOOL)canEd andBlock:(NormalBlock)block andDelImgBlock:(nonnull NormalBlock)block2
{
    isPPPPPPP = YES;
    canEdit = canEd;
    btn0.hidden = btn1.hidden = btn2.hidden = !canEdit;
    myBlock = block;
    myBlock2 = block2;
    picDatas = [[NSMutableArray alloc] initWithArray:dic ];
    if (picDatas.count >2 ) {
        img2.hidden = NO;
        if([picDatas[2] isKindOfClass:[UIImage class]])
        {
            [img2 setImage:picDatas[2]];
            btn2.hidden = NO;

        }else
        {
            img2.image = [UIImage imageNamed:@"jiahao"];
            btn2.hidden = YES;
        }
        
    }else{
        img2.hidden = YES;
        btn2.hidden = YES;
    }
    
    if (picDatas.count >1)
    {
        img1.hidden = NO;

        if([picDatas[1] isKindOfClass:[UIImage class]])
        {
            [img1 setImage:picDatas[1]];
            btn1.hidden = NO;
        }
        else
        {
            img1.image = [UIImage imageNamed:@"jiahao"];
            btn1.hidden = YES;
        }

    }else{
        img1.hidden = YES;
        btn1.hidden = YES;
    }
    
    
    
    if([picDatas[0] isKindOfClass:[UIImage class]])
    {
        [img0 setImage:picDatas[0]];
    }else{
        img0.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn0.hidden = YES;
    }
}

- (IBAction)delBtnClick:(id)sender {
    UIButton*btn =sender;
    myBlock2(@(btn.tag-1000));
}

- (IBAction)imgClick:(id)sender {
    UIButton*btn =sender;
    if (btn.tag > picDatas.count-1) {
        return;
    }
    
    if (isPPPPPPP) {
       
        if([picDatas[btn.tag] isKindOfClass:[NSString class]])
        {
            myBlock(@(1000 + btn.tag));

        }else{
            myBlock(@(btn.tag));

        }
        
        
    }else{
        
        if([picDatas[btn.tag] isEqualToString:@""])
        {
            myBlock(@(1000 + btn.tag));

        }else{
            myBlock(@(btn.tag));

        }
    }
    
    
    
}
@end
