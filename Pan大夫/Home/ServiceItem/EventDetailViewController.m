//
//  EventDetailViewController.m
//  Pan大夫
//
//  Created by 张星宇 on 15/10/20.
//  Copyright © 2015年 Neil. All rights reserved.
//

#import "EventDetailViewController.h"

#pragma mark - 一些相对位置信息
#define rightIndicatorView_RightMargin 10

@interface EventDetailViewController ()
@property (strong, nonatomic) NSURL *destinatedURL;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong,nonatomic) NSString* selectedID;
@end


@implementation EventDetailViewController
@synthesize destinatedURL;
@synthesize webView;
@synthesize indicator;

- (instancetype)initWithDestinatedURL:(NSURL *)URL {
    self = [super init];
    self.destinatedURL = URL;
    return self;
}

- (void)viewDidLoad{
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedID = [[NSString alloc] init];
    // 设置 webView
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, PDTopMargin, kScreenWidth, kScreenHeight - PDTopMargin)];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    
    
    NSString *url =@"http://pandoctor.applinzi.com/read_activity.php?id=";
    Singleton *singleton = [Singleton getInstance];
    NSString *ID = singleton.selectedID;
    NSLog(@"ididididididididid %@",ID);
    url = [url stringByAppendingString:ID];
    self.destinatedURL = [[NSURL alloc] initWithString:url]; // Debug
    // webView 加载 NSURLRequest
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:destinatedURL];
    [webView loadRequest:request];
    
    // @Deprecated
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 175, 100)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"活动详情页面" forState:UIControlStateNormal];
    
    // 网页加载的 indicator
    self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth - rightIndicatorView_RightMargin - UIActIndictLength, middleOfView_Top(UIActIndictLength, navigationBarHeight), UIActIndictLength, UIActIndictLength)];
    self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    // 将 indicator 放在右侧
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    // 隐藏 indicator
    self.indicator.hidden = YES;
    
    // addSubview
    [self.view addSubview:button];
    [self.view addSubview:webView];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
}



@end
