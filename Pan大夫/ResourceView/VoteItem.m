//
//  VoteItem.m
//  Pan大夫
//
//  Created by Carl Lee on 4/25/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "VoteItem.h"

@interface VoteItem ()

@property (strong, nonatomic) UIView *blockView;
@property (strong, nonatomic) UIView *voteBaseView;
@property (nonatomic) PDVoteDirection voteDirection;

@end

@implementation VoteItem

- (instancetype)initWithArticleID:(NSString *)articleID userID:(NSString *)userID {
    self = [super initWithFrame:CGRectMake(0, 0, 52, 26)];
    if (self) {
        
        self.articleID = articleID;
        self.userID = userID;
        
        self.voteNum = [[UILabel alloc] initWithFrame:CGRectMake(3, 4, 36, 18)];
        self.voteNum.font = [UIFont systemFontOfSize:18];
        self.voteNum.text = @"投票";
        
        self.voteStatus = [[UIImageView alloc] initWithFrame:CGRectMake(42.5, 5.5, 9, 15)];
        self.voteStatus.image = [UIImage imageNamed:@"VoteNone"];
        
        self.tapListener = [[UITapGestureRecognizer alloc] init];
        _tapListener.numberOfTouchesRequired = 1;
        _tapListener.numberOfTapsRequired = 1;
        [self.tapListener addTarget:self action:@selector(voteItemTapped)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:_tapListener];
        
        // 请求投票数据
        [self refreshVoteStatus];
        
        [self addSubview:_voteNum];
        [self addSubview:_voteStatus];
    }
    return self;
}

- (void)refreshVoteStatus {
    NSString *getVoteURL = [NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/getVote.php?articleID=%@&userID=%@", self.articleID, self.userID];
    NSMutableURLRequest *getVoteReq = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:getVoteURL]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:getVoteReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
            return;
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
                NSLog(@"%@", [dic objectForKey:@"error"]);
                NSAssert(NO, @"error");
            }
            NSString *voteDirection = [dic objectForKey:@"vote"];
            if ([voteDirection isEqualToString:@"up"]) {
                [self setVoteStatusByEnumeration:PDVoteDirectionUp];
            } else if ([voteDirection isEqualToString:@"down"]) {
                [self setVoteStatusByEnumeration:PDVoteDirectionDown];
            } else if ([voteDirection isEqualToString:@"none"]) {
                [self setVoteStatusByEnumeration:PDVoteDirectionNone];
            } else {
                NSLog(@"%@", voteDirection);
                //NSAssert(NO, @"voteDirection");
            }
            
            self.voteNum.text = [NSString stringWithFormat:@"%@", [dic objectForKey:@"num"]];
            NSLog(@"hehe");
        }
    }];
    [dataTask resume];
}

- (void)setVoteStatusByEnumeration:(PDVoteDirection)voteDirection {
    _voteDirection = voteDirection;
    switch (voteDirection) {
        case PDVoteDirectionUp:
            self.voteStatus.image = [UIImage imageNamed:@"VoteUp"];
            break;
        case PDVoteDirectionDown:
            self.voteStatus.image = [UIImage imageNamed:@"VoteDown"];
            break;
        case PDVoteDirectionNone:
            self.voteStatus.image = [UIImage imageNamed:@"VoteNone"];
            break;
        default:
            break;
    }
}

// 投票 Item 点击响应事件
// 弹出独立响应框
- (void)voteItemTapped {
    // 如果父 UIViewController 已指派
    if (self.parent) {
        // 创建半透明背景，覆盖整个 view
        _blockView = [[UIView alloc] initWithFrame:self.parent.view.frame];
        _blockView.backgroundColor = [UIColor blackColor];
        _blockView.alpha = 0.3;
        [self.parent.view addSubview:_blockView];
        _blockView.userInteractionEnabled = YES;
        // 收回投票响应
        UITapGestureRecognizer *goBackTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackFromVoteView)];
        goBackTap.numberOfTapsRequired = 1;
        goBackTap.numberOfTouchesRequired = 1;
        [_blockView addGestureRecognizer:goBackTap];
        // 创建响应框，圆角 200x100
        _voteBaseView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 100, [UIScreen mainScreen].bounds.size.height / 2 - 50, 200, 100)];
        _voteBaseView.layer.cornerRadius = 10;
        [_voteBaseView setBackgroundColor:[UIColor whiteColor]];
        [_blockView addSubview:_voteBaseView];
        
        // 投票选择
        UIImageView *upVoteImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 50, 50)];
        UIImageView *downVoteImage = [[UIImageView alloc] initWithFrame:CGRectMake(125, 25, 50, 50)];
        if (_voteDirection == PDVoteDirectionUp) {
            upVoteImage.image = [UIImage imageNamed:@"Upvote"];
            downVoteImage.image = [UIImage imageNamed:@"DownvoteNone"];
        } else if (_voteDirection == PDVoteDirectionDown) {
            upVoteImage.image = [UIImage imageNamed:@"UpvoteNone"];
            downVoteImage.image = [UIImage imageNamed:@"Downvote"];
        } else {
            upVoteImage.image = [UIImage imageNamed:@"UpvoteNone"];
            downVoteImage.image = [UIImage imageNamed:@"DownvoteNone"];
        }
//        upVoteImage.image = [UIImage imageNamed:@"Upvote"];
//        downVoteImage.image = [UIImage imageNamed:@"Downvote"];
        upVoteImage.userInteractionEnabled = YES;
        downVoteImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *upVoteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upVoteButtonTapped)];
        upVoteTap.numberOfTapsRequired = 1;
        upVoteTap.numberOfTouchesRequired = 1;
        [upVoteImage addGestureRecognizer:upVoteTap];
        
        UITapGestureRecognizer *downVoteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downVoteButtonTapped)];
        downVoteTap.numberOfTapsRequired = 1;
        downVoteTap.numberOfTouchesRequired = 1;
        [downVoteImage addGestureRecognizer:downVoteTap];
        
        [_voteBaseView addSubview:upVoteImage];
        [_voteBaseView addSubview:downVoteImage];
    }
}

- (void)upVoteButtonTapped {
    if (_voteDirection == PDVoteDirectionNone || _voteDirection == PDVoteDirectionDown) {
        [self upVote];
    } else if (_voteDirection == PDVoteDirectionUp) {
        [self cancelVote];
    }
}

- (void)downVoteButtonTapped {
    if (_voteDirection == PDVoteDirectionNone || _voteDirection == PDVoteDirectionUp) {
        [self downVote];
    } else if (_voteDirection == PDVoteDirectionDown) {
        [self cancelVote];
    }
}

- (void)upVote {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/vote.php?studentId=%@&articleId=%@&vote=up", _userID, _articleID]]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
                NSLog(@"%@", [dic objectForKey:@"error"]);
            }
            if (!(BOOL)[dic objectForKey:@"success"]) {
                [[[UIAlertView alloc] initWithTitle:@"投票失败" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
    [dataTask resume];
    NSLog(@"UpVote");
    [self goBackFromVoteView];
}

- (void)downVote {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/vote.php?studentId=%@&articleId=%@&vote=down", _userID, _articleID]]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
                NSLog(@"%@", [dic objectForKey:@"error"]);
            }
            if (!(BOOL)[dic objectForKey:@"success"]) {
                [[[UIAlertView alloc] initWithTitle:@"投票失败" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
    [dataTask resume];
    NSLog(@"DownVote");
    [self goBackFromVoteView];
}

- (void)cancelVote {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/vote.php?studentId=%@&articleId=%@&vote=none", _userID, _articleID]]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
                NSLog(@"%@", [dic objectForKey:@"error"]);
            }
            if (!(BOOL)[dic objectForKey:@"success"]) {
                [[[UIAlertView alloc] initWithTitle:@"投票失败" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }
    }];
    [dataTask resume];
    NSLog(@"cancelVote");
    [self goBackFromVoteView];
}

- (void)goBackFromVoteView {
    // TODO: 未完成
    [_voteBaseView removeFromSuperview];
    [_blockView removeFromSuperview];
    [self refreshVoteStatus];
    NSLog(@"GoBack");
}

@end
