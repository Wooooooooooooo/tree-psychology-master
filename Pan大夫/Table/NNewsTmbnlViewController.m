//
//  NNewsTmbnlViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 5/4/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "NNewsTmbnlViewController.h"

@interface NNewsTmbnlViewController ()

@property (nonatomic) NSString *articleID;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *loadIndicator;

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIImageView *addCommentImageView;
@property (strong, nonatomic) UILabel *addCommentLabel;
@property (strong, nonatomic) UIImageView *commentsImageView;
@property (strong, nonatomic) UILabel *commentsLabel;

@property (strong, nonatomic) UIView *authorBackgroundView;
@property (strong, nonatomic) UILabel *authorLabel;

@property (strong, nonatomic) UIBarButtonItem *shareBBI;
@property (strong, nonatomic) VoteItem *voteItem;

@end

@implementation NNewsTmbnlViewController

- (instancetype)initWithArticleID:(NSString *)articleID {
    self = [super init];
    if (self) {
        self.articleID = articleID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 右上角
    self.shareBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    self.voteItem = [[VoteItem alloc] initWithArticleID:self.articleID userID:@"20150000"];
    UIBarButtonItem *voteBBI = [[UIBarButtonItem alloc] initWithCustomView:self.voteItem];
    self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:self.shareBBI, voteBBI, nil];
    
    // 作者栏
    self.authorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    self.authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.authorLabel.font = [UIFont boldSystemFontOfSize:18];
    
    // 页面加载方面
    self.loadIndicator = [[UIActivityIndicatorView alloc] init];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    NSString *fullArticleURL = [HOSTNAME stringByAppendingString:[NSString stringWithFormat:@"/newsDetail.php?id=%@", _articleID]];
    
    // 评论，底部栏方面
    CGFloat bottomViewHeight = 44;
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - bottomViewHeight, [UIScreen mainScreen].bounds.size.width, bottomViewHeight)];
    // TODO: 以下的 CGRectZero 需要更改成原型指定数值；[UIImage imageNamed:] 需要改成实际图像
    self.addCommentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.addCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.addCommentImageView.image = [UIImage imageNamed:@""];
    self.addCommentImageView.userInteractionEnabled = YES;
    self.addCommentLabel.text = @"添加评论";
    self.addCommentLabel.userInteractionEnabled = YES;
    
    self.commentsImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.commentsImageView.image = [UIImage imageNamed:@""];
    self.commentsImageView.userInteractionEnabled = YES;
    self.commentsLabel.text = @"查看所有评论";
    self.commentsLabel.userInteractionEnabled = YES;
    
    // 两个按钮的点击事件
    UITapGestureRecognizer *addCommentTGR = [[UITapGestureRecognizer alloc] init];
    addCommentTGR.numberOfTapsRequired = 1;
    addCommentTGR.numberOfTouchesRequired = 1;
    [addCommentTGR addTarget:self action:@selector(goToAddCommentVC)];
    [self.addCommentImageView addGestureRecognizer:addCommentTGR];
    [self.addCommentLabel addGestureRecognizer:addCommentTGR];
    
    UITapGestureRecognizer *commentsTGR = [[UITapGestureRecognizer alloc] init];
    commentsTGR.numberOfTapsRequired = 1;
    commentsTGR.numberOfTouchesRequired = 1;
    [commentsTGR addTarget:self action:@selector(gotoCommentsVC)];
    [self.commentsImageView addGestureRecognizer:commentsTGR];
    [self.commentsLabel addGestureRecognizer:commentsTGR];
    
    // view 绘制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.loadIndicator];
    [self.bottomView addSubview:self.addCommentImageView];
    [self.bottomView addSubview:self.addCommentLabel];
    [self.bottomView addSubview:self.commentsImageView];
    [self.bottomView addSubview:self.commentsLabel];
    [self.view addSubview:self.bottomView];
    
    [self.authorBackgroundView addSubview:self.authorLabel];
    [self.view addSubview:self.authorBackgroundView];
    
    // 刚刚进入时，加载网页，菊花转动
    // 最后才开始加载 URL 资源
    [self.webView loadRequest:[[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:fullArticleURL]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self startLoadIndicate];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self stopLoadIndicate];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self stopLoadIndicate];
}

- (void)startLoadIndicate {
    self.loadIndicator.hidden = NO;
    [self.loadIndicator startAnimating];
}

- (void)stopLoadIndicate {
    [self.loadIndicator stopAnimating];
    self.loadIndicator.hidden = YES;
}

- (void)goToAddCommentVC {
    NAddCommentVC *addCommentVC = [[NAddCommentVC alloc] initWithArticleID:self.articleID];
    [self.navigationController pushViewController:addCommentVC animated:YES];
}

- (void)gotoCommentsVC {
    NAllCommentsTableVC *allCommentsVC = [[NAllCommentsTableVC alloc] initWithArticleID:self.articleID];
    [self.navigationController pushViewController:allCommentsVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
