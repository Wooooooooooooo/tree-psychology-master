//
//  CommentTableViewCell.h
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCommentTableViewCell : UITableViewCell

//@property (nonatomic) NSString *userId;
//@property (nonatomic) NSString *content;

@property (nonatomic) UILabel *userIdLabel;
@property (nonatomic) UITextView *textView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)assignValueWithUserId:(NSString *)userId commentContent:(NSString *)content;

@end
