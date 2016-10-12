//
//  SingleCommentTableViewCell.m
//  Pan大夫
//
//  Created by Carl Lee on 5/7/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "SingleCommentTableViewCell.h"

@implementation SingleCommentTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)identifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        
        self.textView = [[UITextView alloc] init];
        self.textView.editable = NO;
        self.textView.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)assignValueWithName:(NSString *)name content:(NSString *)content {
    self.nameLabel.text = name;
    self.textView.text = content;
    self.textView.frame = CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, self.textView.contentSize.height);
    
    [self.contentView addSubview:_textView];
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
