//
//  NewsDetailViewController.m
//  1.0.5
//
//  Created by tiny on 15/1/30.
//  Copyright (c) 2015年 tiny. All rights reserved.
//
#define pandaColor [UIColor colorWithRed:25/255.0 green:189/255.0 blue:154/255.0 alpha:1.0]
#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (strong,nonatomic) NSString *Id;

@property (nonatomic ,strong) UIActivityIndicatorView *indicator;
@property (nonatomic ,strong) UIView *coverView;
@property (nonatomic ,strong) UILabel *loadingLabel;
@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UIButton *addCommentButton;
@property (nonatomic, strong) UIButton *allCommentButton;

@end

@implementation NewsDetailViewController
@synthesize indicator,coverView,loadingLabel;
- (id)initWithId:(NSString *)Id{
    self = [super init];
    if (self) {
        self.Id = Id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    NSMutableArray *rightBarItems = [[NSMutableArray alloc] init];
    
    //设置分享按钮，添加动作函数
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
//    [rightBarItems addObject:rightButton];
    
    //加载灰色遮蔽视图
    coverView = [[UIView alloc]initWithFrame:self.view.frame];
    [coverView setBackgroundColor:[UIColor grayColor]];
    
    
    //加载网络活动指示器
//    [self.view setBackgroundColor: [UIColor grayColor]];
//    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    indicator.frame = CGRectMake(([[UIScreen mainScreen]bounds].size.width - 10)/2, (self.view.frame.size.height - 100)/2, 10, 10);
    
//    //加载说明文字
//    loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(([[UIScreen mainScreen]bounds].size.width - 120)/2, (self.view.frame.size.height - 40)/2, 150, 40)];
//    loadingLabel.text = @"拼命加载中。。。";
//    // Dispose of any resources that can be recreated.
    
//    NSString *stringURL = [[NSString alloc]initWithFormat:@"http://1.pandoctor.sinaapp.com/Community/Templates/newsDetail.php?articleID=%@",self.Id];
//    NSURL *url = [NSURL URLWithString:stringURL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    webView.delegate = self;
//    
//    [webView loadRequest:request];
    
#pragma mark - CL
    
//    WKWebView *newWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
//    newWebView.UIDelegate = self;
//    newWebView.navigationDelegate = self;
//    [newWebView loadRequest:request];
//
    
    

    
    
    
    
    
    
    NSString *stringURL = [[NSString alloc]initWithFormat:@"http://pandoctor.applinzi.com/read_article.php?id=%@&userID=3",self.Id];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -10, self.view.frame.size.width, self.view.frame.size.height - 40)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stringURL]]];
    self.webView=webView;
    
    [self.view addSubview:webView];
    
    
    
    
    
    
    
    
    //转到文章页面
//    WKWebView* articleWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
////    articleWebView.sizeToFit = YES;//自动对页面进行缩放以适应屏幕
//    
//    articleWebView.backgroundColor=[UIColor whiteColor];
//    [self.view addSubview:articleWebView];
//    NSURL* articleUrl = [NSURL URLWithString:@"http://pandoctor.applinzi.com/read_article.php?id=2"];//创建URL
//    NSURLRequest* articleRequest = [NSURLRequest requestWithURL:articleUrl];//创建NSURLRequest
//    [articleWebView loadRequest:articleRequest];//加载
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
//    [headerView setBackgroundColor:[UIColor whiteColor]];
//    _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 200, 12)];
//    _authorLabel.text = @"Hello World!";
    
    // 下方分割线
//    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height - 1, headerView.frame.size.width, 1)];
//    [splitLine setBackgroundColor:[UIColor grayColor]];
//    [headerView addSubview:splitLine];
//    [self getAuthor];
    
//    // 投票
//    VoteItem *voteItem = [[VoteItem alloc] initWithArticleID:_Id userID:@"20150000"];
//    voteItem.parent = self;
//    [rightBarItems addObject:[[UIBarButtonItem alloc] initWithCustomView:voteItem]];
    
//    [self.view addSubview:webView];
//    [self.view addSubview:newWebView];
//    [self.view addSubview:headerView];
//    [headerView addSubview:_authorLabel];
//    self.navigationItem.rightBarButtonItems = rightBarItems;
    
    // 评论底部栏
    UIView *commentBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, [UIScreen mainScreen].bounds.size.width, 50)];
    [commentBottomView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:commentBottomView];//添加底部栏
    _addCommentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _addCommentButton.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width/2, 50);
    [_addCommentButton setTitle:@"评论文章" forState:UIControlStateNormal];
    _addCommentButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _addCommentButton.tintColor=[UIColor whiteColor];
    _addCommentButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _addCommentButton.backgroundColor=[UIColor colorWithRed:25/255.0 green:189/255.0 blue:154/255.0 alpha:1.0];
    [_addCommentButton addTarget:self action:@selector(goAddComment) forControlEvents:UIControlEventTouchUpInside];
    
    _allCommentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _allCommentButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 0, [UIScreen mainScreen].bounds.size.width/2, 50);
    [_allCommentButton setTitle:@"查看评论" forState:UIControlStateNormal];
    _allCommentButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _allCommentButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _allCommentButton.tintColor=[UIColor whiteColor];
    [_allCommentButton addTarget:self action:@selector(goAllComments) forControlEvents:UIControlEventTouchUpInside];
    
    [commentBottomView addSubview:_addCommentButton];
    [commentBottomView addSubview:_allCommentButton];
}

- (void)getAuthor {
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://pandoctor.applinzi.com/request.php?request=activity"]]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"HttpResponseCode:%ld", responseCode);
            NSLog(@"HttpResponseBody %@",responseString);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if ([dic objectForKey:@"error"]) {
            //    NSLog(@"%@", [dic objectForKey:@"error"]);
                return;
            }
            _authorLabel.text = [dic objectForKey:@"author"];
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self.view addSubview:coverView];
    [coverView addSubview:loadingLabel];
    [coverView addSubview:indicator];
    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [indicator stopAnimating];
    [indicator removeFromSuperview];
    [loadingLabel removeFromSuperview];
    [coverView removeFromSuperview];
}

//- (void)share:(id)sender{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
//    
//    //构造分享内容
//    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
//                                       defaultContent:@"测试一下"
//                                                image:[ShareSDK imageWithPath:imagePath]
//                                                title:@"ShareSDK"
//                                                  url:@"http://www.mob.com"
//                                          description:@"这是一条测试信息"
//                                            mediaType:SSPublishContentMediaTypeNews];
//    //创建弹出菜单容器
//    id<ISSContainer> container = [ShareSDK container];
//
//
//    //弹出分享菜单
//    [ShareSDK showShareActionSheet:container
//                         shareList:nil
//                           content:publishContent
//                     statusBarTips:YES
//                       authOptions:nil
//                      shareOptions:nil
//                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
//                                
//                                if (state == SSResponseStateSuccess)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
//                                }
//                                else if (state == SSResponseStateFail)
//                                {
//                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
//                                }
//                            }];
//}

- (void)goAddComment {
    // TODO: 修改为读取值
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory =[paths objectAtIndex:0];
    NSString *documentPlistPath = [documentsDirectory stringByAppendingPathComponent:@"login.plist"];//plist文件位置
    NSMutableDictionary *plistDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:documentPlistPath];
    
    if ([plistDictionary objectForKey:@"login"]==nil) {
        [[[UIAlertView alloc] initWithTitle:@"未登录" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    AddCommentViewController *nextVC = [[AddCommentViewController alloc] initWithArticleId:_Id userId:[plistDictionary objectForKey:@"login"]];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (void)goAllComments {
    AllCommentTableViewController *nextVC = [[AllCommentTableViewController alloc] initWithArticleId:_Id];
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

@end
