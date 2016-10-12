//
//  VoteItem.h
//  Pan大夫
//
//  Created by Carl Lee on 4/25/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PDVoteDirection) {
    PDVoteDirectionUp,
    PDVoteDirectionDown,
    PDVoteDirectionNone
};

@interface VoteItem : UIView

@property (weak, nonatomic) UIViewController *parent;

@property (strong, nonatomic) UILabel *voteNum;
@property (strong, nonatomic) UIImageView *voteStatus;
@property (strong, nonatomic) UITapGestureRecognizer *tapListener;

@property (nonatomic) NSString *articleID;
@property (nonatomic) NSString *userID;

- (instancetype)initWithArticleID:(NSString *)articleID userID:(NSString *)userID;
@end
