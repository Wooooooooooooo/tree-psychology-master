//
//  NAddCommentVC.m
//  Pan大夫
//
//  Created by Carl Lee on 5/7/16.
//  Copyright © 2016 Neil. All rights reserved.
//
#import "MKNetworkOperation.h"
#import "NAddCommentVC.h"

#import "AppDelegate.h"

@interface NAddCommentVC ()

@property (nonatomic,assign) NSString *articleID;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *submitCommentButton;

@end

@implementation NAddCommentVC

- (instancetype)initWithArticleID:(NSString *)articleID {
    self = [super init];
    if (self) {
        self.articleID = articleID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    self.textView.editable = YES;
    self.textView.font = [UIFont systemFontOfSize:12];
    
    self.submitCommentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.submitCommentButton.frame = CGRectMake(0, 0, 20, 10);
    [self.submitCommentButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.submitCommentButton addTarget:self action:@selector(submitComment) forControlEvents:UIControlEventTouchUpInside];
    
    // 绘制
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.submitCommentButton];
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)submitComment {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (!self.articleID) {
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"遇到未知错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        [self returnToArticleVC];
    }
    NSString *path = [NSString stringWithFormat:@"/community/addComment.php?id=%@", self.articleID];
    MKNetworkOperation *operation = [appDelegate.netEngine operationWithPath:path];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *JSONData = (NSDictionary *)[completedOperation responseJSON];
        BOOL status = (BOOL)[JSONData objectForKey:@"status"];
        if (status) {
            // react if succeed
        }
        [self performSelectorOnMainThread:@selector(returnToArticleVC) withObject:nil waitUntilDone:NO];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        //
    }];
    [appDelegate.netEngine enqueueOperation:operation];
}

- (void)returnToArticleVC {
    [self dismissViewControllerAnimated:YES completion:^{}];
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
