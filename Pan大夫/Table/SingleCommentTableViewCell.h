//
//  SingleCommentTableViewCell.h
//  Pan大夫
//
//  Created by Carl Lee on 5/7/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleCommentTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UITextView *textView;

- (instancetype)initWithReuseIdentifier:(NSString *)identifier;
- (void)assignValueWithName:(NSString *)name content:(NSString *)content;

@end
