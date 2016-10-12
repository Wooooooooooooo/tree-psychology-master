//
//  NewsTmbnlTableViewCell.m
//  Pan大夫
//
//  Created by 李昂 on 3/30/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "NewsTmbnlTableViewCell.h"

#pragma mark -
@implementation NewsTmbnlTableViewCell
//@synthesize classify;
//@synthesize classifyLabel;
//@synthesize title;
//@synthesize titleLabel;
//@synthesize imageURL;
//@synthesize imageView;

+ (NSString *)getDiseaseNameInChinese:(NSString *)disease {
    if (disease == nil || [disease isEqual:@""]) {
        return @"未知";
    }
    if ([disease isEqualToString:@"depression"]) {
        return @"抑郁症";
    } else if ([disease isEqualToString:@"anxiety"]) {
        return @"焦虑症";
    } else if ([disease isEqualToString:@"hypochondria"]) {
        return @"疑病症";
    } else if ([disease isEqualToString:@"obsession"]) {
        return @"强迫症";
    } else if ([disease isEqualToString:@"paranoid"]) {
        return @"妄想症";
    } else if ([disease isEqualToString:@"phobia"]) {
        return @"恐惧症";
    } else if ([disease isEqualToString:@"amnesia"]) {
        return @"健忘症";
    } else if ([disease isEqualToString:@"ADHD"]) {
        return @"多动症";
    } else {
        return @"未知";
    }
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // 单元格内部内容绘制
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 分类
//        self.classifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(classifyLeftMargin, classifyTopMargin, kScreenWidth - classifyLeftMargin - classifyRightMargin, classifyHeight)];
//        self.classifyLabel.numberOfLines = 1;
//        self.classifyLabel.font = [UIFont systemFontOfSize:12];
//        
        // 标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, kScreenWidth - titleLeftMargin - titleRightMargin, titleHeight)];
        self.titleLabel.numberOfLines = 1;
        
        
        
        //内容
        self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 10+CGRectGetMaxY(self.titleLabel.bounds), kScreenWidth-80, 100)];
        
//        // 图片
        self.imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.imageView0.image=[UIImage imageNamed:@"appCover"];
//        [self.contentView addSubview:self.classifyLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.imageView0];
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

// 满足单元格重用性，单元格内容加载时调用
- (void)assignValueWithID:(NSString *)id classify:(NSString *)classify title:(NSString *)title imageURL:(NSString *)imageURL content:(NSString *)content {
    self.id = id;
    self.title = title;
    self.classify = classify;
    self.imageURL = imageURL;
    self.content= content;
    NSLog(@"%@ %@ %@ %@ %@", self.id, self.title, self.classify, self.imageURL,self.content);
    
//     设置标题颜色，需要富文本支持，下同
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:self.title];
    [titleAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:throughAllString(title)];
    self.titleLabel.attributedText = titleAttrStr;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
//     设置内容
    NSMutableAttributedString *contentAttrStr = [[NSMutableAttributedString alloc] initWithString:self.content];
    [contentAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:throughAllString(content)];
    self.contentLabel.numberOfLines=4;
    self.contentLabel.userInteractionEnabled=NO;
    self.contentLabel.attributedText = contentAttrStr;
    self.contentLabel.font=[UIFont systemFontOfSize:15.0];
    self.contentLabel.textColor=[UIColor grayColor];
//     分类
  //  NSLog(@"%@", self.classify);
 //   NSLog(@"%@\n====", [NewsTmbnlTableViewCell getDiseaseNameInChinese:self.classify]);
    NSMutableAttributedString *classifyAttrStr = [[NSMutableAttributedString alloc] initWithString:self.classify];
    [classifyAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:throughAllString(classify)];
    self.classifyLabel.attributedText = classifyAttrStr;
    
//     设置图片
//    [self.imageView0 sd_setImageWithURL:[[NSURL alloc] initWithString:self.imageURL]];
    
}


@end
