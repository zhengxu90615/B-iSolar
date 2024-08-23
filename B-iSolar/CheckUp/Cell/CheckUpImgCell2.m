//
//  CheckUpImgCell.m
//  B-iSolar
//
//  Created by Mark.zheng on 2023/5/11.
//  Copyright © 2023 Mark.zheng. All rights reserved.
//

#import "CheckUpImgCell2.h"
#import "UIImageView+WebCache.h"

@implementation CheckUpImgCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    img0.backgroundColor= img1.backgroundColor= img2.backgroundColor= COLOR_TABLE_SEP;
    bgV.backgroundColor = [UIColor whiteColor];;
    // Initialization code
    


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
   
    if(picDatas.count>2  && ![picDatas[2] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[2] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img2 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img2.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn2.hidden = YES;
    }
    
    if(picDatas.count>1  && ![picDatas[1] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[1] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img1 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img1.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn1.hidden = YES;
    }
    if(picDatas.count>0  && ![picDatas[0] isEqualToString:@""])
    {
        NSURL *url = [NSURL URLWithString:API_FILE_URL([picDatas[0] stringByReplacingOccurrencesOfString:@"/u01/" withString:@""])]; //文件下载地址
        [img0 sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_gif"]];
    }else{
        img0.image = canEdit ?[UIImage imageNamed:@"jiahao"] : nil;
        btn0.hidden = YES;
    }
    
    if (picDatas.count == 0) {
        imgBtn0.hidden = NO;
        img0.hidden = NO;
        
        imgBtn1.hidden = imgBtn2.hidden = YES;
        img1.hidden = img2.hidden = YES;
    }else if (picDatas.count == 1)
    {
        imgBtn0.hidden = imgBtn1.hidden = NO;
        img0.hidden = img1.hidden = NO;
        
        imgBtn2.hidden = YES;
        img2.hidden = YES;
    }else if (picDatas.count == 2)
    {
        imgBtn0.hidden = NO;
        img0.hidden = NO;
        
        imgBtn1.hidden = imgBtn2.hidden = NO;
        img1.hidden = img2.hidden = NO;
    }else
    {
        imgBtn0.hidden = NO;
        img0.hidden = NO;
        
        imgBtn1.hidden = imgBtn2.hidden = NO;
        img1.hidden = img2.hidden = NO;
    }
    
}

- (IBAction)delBtnClick:(id)sender {
    UIButton*btn =sender;
    myBlock2(@(btn.tag-1000));
}

- (IBAction)imgClick:(id)sender {
    UIButton*btn =sender;

    if( picDatas.count < btn.tag      )
    {
        myBlock(@(1000 + btn.tag-1));
    }else{
        myBlock(@(btn.tag-1));
    }
}

@end
