//
//  NewsTmbnlTableViewCell.h
//  Pan大夫
//
//  Created by 李昂 on 3/30/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIImage+CircleImage.h"

#import "PreDefination.h"

#import "ScrollableTable.h"

#pragma mark 一些布局数据
#pragma mark 分类
// 分类 UILabel 左侧距离
#define classifyLeftMargin standardMargin
// 分类 UILabel 上方距离
#define classifyTopMargin standardMargin
// 分类 UILabel 右侧距离
#define classifyRightMargin standardMargin
// 分类 UILabel 高度
#define classifyHeight standardMargin

#pragma mark 标题
// 标题 UILabel 左侧距离
#define titleLeftMargin standardMargin
// 标题 UILabel 与摘要距离
#define titleTopMargin standardMargin
// 标题 UILabel 右侧距离
#define titleRightMargin standardMargin
// 标题 UILabel 高度
#define titleHeight 18

//#pragma mark 摘要
//// 摘要 UILabel 左侧距离
//#define abstractLeftMargin titleLeftMargin
//// 摘要 UILabel 右侧距离
//#define abstractRightMargin titleRightMargin
//// 摘要 UILabel 上方与标题距离
//#define abstractTopMargin 20
//// 摘要 UILabel 高度
//#define abstractHeight 60
//// 摘要 UILabel 底部距离
//#define abstractBottomMargin standardMargin

#pragma mark 图片（头像）
// 图片右侧距离
#define imageRightMargin standardMargin
// 图片上方距离
#define imageTopMargin titleTopMargin
// 图片宽度
#define imageWidth 20
// 图片高度
#define imageHeight 20

#pragma mark 单个单元格
// 单元格高度
#define cellHeight (classifyTopMargin + classifyHeight + titleTopMargin + titleHeight + standardMargin/* 下方 */)

#pragma mark -
// 仿知乎的 UITableViewCell
@interface NewsTmbnlTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *id;
//@property (strong, nonatomic) UITapGestureRecognizer *gestureRecog;

//@property (nonatomic) NSInteger row;

// 分类
@property (strong, nonatomic) NSString *classify;
@property (strong, nonatomic) UILabel *classifyLabel;

// 标题
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UILabel *titleLabel;

//// 文章摘要
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) UILabel *contentLabel;
// 右上角照片
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImageView *imageView0;

+ (NSString *)getDiseaseNameInChinese:(NSString *)disease;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)assignValueWithID:(NSString *)ID classify:(NSString *)classify title:(NSString *)title imageURL:(NSString *)imageURL content:(NSString *)content;

@end
