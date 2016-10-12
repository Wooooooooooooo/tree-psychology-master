//
//  NewsDetailViewController.h
//  1.0.5
//
//  Created by tiny on 15/1/30.
//  Copyright (c) 2015年 tiny. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

#import "VoteItem.h"
#import "AddCommentViewController.h"
#import "AllCommentTableViewController.h"

@interface NewsDetailViewController : UIViewController<UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate>

- (id)initWithId:(NSString *)Id;

@end
