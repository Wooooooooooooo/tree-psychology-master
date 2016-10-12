//
//  AllCommentTableViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "AllCommentTableViewController.h"

@interface AllCommentTableViewController ()

@property (nonatomic) NSString *articleId;
//@property (nonatomic) NSMutableArray<NComment *> *comments;
@property (nonatomic) NSString *userId;
@end

@implementation AllCommentTableViewController

- (instancetype)initWithArticleId:(NSString *)articleId  {
    self = [super init];
    if (self) {
        _articleId = articleId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.view addSubview:webView];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://pandoctor.applinzi.com/comment.php?id=%@", _articleId]];//创建URL
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    
    [webView loadRequest:request];//加载

    //    [self.tableView registerClass:NCommentTableViewCell.class forCellReuseIdentifier:@"cell"];
//    
//    // 请求评论数据
//    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://1.pandoctor.sinaapp.com/Community/Comment/getComment.php?articleId=%@", _articleId]]];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
//        } else {
//            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"HttpResponseCode:%ld", responseCode);
//            NSLog(@"HttpResponseBody %@",responseString);
//            
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            if ([dic objectForKey:@"error"]) {
//                NSLog(@"%@", [dic objectForKey:@"error"]);
//                return;
//            }
//            
////            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
////            for (NSDictionary *d in arr) {
////                [self.comments addObject:[[NComment alloc] initWithRawData:d]];
////            }
//            
//            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//        }
//    }];
//    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    //return _comments.count;
//    return 5;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    [cell assignValueWithUserId:[_comments objectAtIndex:indexPath.row].userId commentContent:[_comments objectAtIndex:indexPath.row].content];
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
