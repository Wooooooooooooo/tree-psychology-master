//
//  CommentTableViewCell.m
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//
//该部分是输入评论的界面
#import "NCommentTableViewCell.h"

@implementation NCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _userIdLabel.font = [UIFont boldSystemFontOfSize:18];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _textView.editable = NO;
        _textView.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_userIdLabel];
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)assignValueWithUserId:(NSString *)userId commentContent:(NSString *)content {
    _userIdLabel.text = userId;
    _textView.text = content;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
