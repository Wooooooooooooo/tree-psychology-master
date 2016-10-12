//
//  FunTestDetailViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 29/09/2016.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "FunTestDetailViewController.h"

@import WebKit;

#import "Masonry.h"

@interface FunTestDetailViewController ()

@property (nonatomic) NSString *testID;
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation FunTestDetailViewController

- (instancetype)initWithID:(NSString *)testID {
    self = [super init];
    if (self) {
        self.testID = testID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://pandoctor.applinzi.com/read_test.php?id=%@", _testID]]];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
