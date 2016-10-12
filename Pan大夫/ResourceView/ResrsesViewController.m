//
//  ResrsesViewController.m
//  Pan大夫
//
//  Created by Carl Lee on 4/15/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "ResrsesViewController.h"
#import "ResourceTableViewCell.h"
@interface ResrsesViewController ()

@end

@implementation ResrsesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle=YES;
    // Do any additional setup after loading the view.
    //添加刷新小齿轮
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];//刷新
    self.arr = [[NSMutableArray alloc] init];
    self.page = 1;
    

    

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
//    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 防止循环引用
    __weak ResrsesViewController *indirectSelf = self;
    
    self.tableView.footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        ++self.page;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *newsInfoURL = [NSString stringWithFormat:@"http://pandoctor.applinzi.com/request.php?request=article"];
        indirectSelf.operation = [[appDelegate netEngine] operationWithPath:newsInfoURL];
        [indirectSelf.operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSData *data=(NSData *)[completedOperation responseJSON];
            
            
//            // Data 转成 字典 其中responseObject为返回的data数据
//            NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSLog(@"resultDictionary: %@", resultDictionary);
//            
            // Data 转成 数组 其中responseObject为返回的data数据
            NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            
//            NSString *resultString  =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            
            
            
            
            
            
//            NSArray *JSON = (NSArray *)[completedOperation responseJSON];
            for (NSDictionary *d in resultArray) {
                NewsTmbnl *element = [[NewsTmbnl alloc] init];
                element.ID = (NSString *)[d objectForKey:@"id"];
//                element.classify = (NSString *)[d objectForKey:@"class"];
                element.title = (NSString *)[d objectForKey:@"title"];
//                element.imageURL = (NSString *)[d objectForKey:@"picturl"];
                //            NSLog(@"%@ %@ %@ %@", element.ID, element.classify, element.title, element.imageURL);
                [indirectSelf.arr addObject:element];
                
                [indirectSelf performSelectorOnMainThread:@selector(endDownPullRefresh) withObject:nil waitUntilDone:0];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [indirectSelf performSelectorOnMainThread:@selector(endDownPullRefresh) withObject:nil waitUntilDone:0];
        }];
    }];
    
    [self.refreshControl beginRefreshing];
    [self refresh:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)endDownPullRefresh {
    [self.tableView reloadData];
    [self.tableView.footer endRefreshing];
}

- (void)endRefresh {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)refresh:(id)sender {
    // 刷新的情况下
//    if (!self.refreshControl.refreshing) {
//        return;
//    }
    
    // 防止循环引用
//    __block ResrsesViewController *indirectSelf = self;
    
    [self.arr removeAllObjects];
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSString *newsInfoURL = @"Community/newsList.php?page=1";
//    _operation = [[appDelegate netEngine] operationWithPath:newsInfoURL];
//    [_operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSArray *JSON = (NSArray *)[completedOperation responseJSON];
////        NSInteger rows = [[JSON objectForKey:@"rowNumber"] integerValue];
//        for (NSDictionary *d in JSON) {
//            NewsTmbnl *element = [[NewsTmbnl alloc] init];
//            element.ID = (NSString *)[d objectForKey:@"articleID"];
//            element.classify = (NSString *)[d objectForKey:@"class"];
//            element.title = (NSString *)[d objectForKey:@"title"];
//            element.imageURL = (NSString *)[d objectForKey:@"picURL"];
////            NSLog(@"%@ %@ %@ %@", element.ID, element.classify, element.title, element.imageURL);
//            [indirectSelf.arr addObject:element];
//        }
//        
////        for (NewsTmbnl *e in indirectSelf.arr) {
////            NSLog(@"haha......%@ %@ %@ %@", e.ID, e.classify, e.title, e.imageURL);
////        }
//        
//        indirectSelf.page = 1;
//        // 结束刷新
//        [indirectSelf performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:YES];
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        [indirectSelf performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:YES];
//        
//    }];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSString *newsListURL = @"http://pandoctor.applinzi.com/request.php?request=article";
    NSMutableURLRequest *newsListReq = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:newsListURL]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:newsListReq completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Httperror: %@ %ld", error.localizedDescription, error.code);
        } else {
            NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"HttpResponseCode:%ld", responseCode);
//            NSLog(@"HttpResponseBody %@",responseString);
            NSData * data = [responseString dataUsingEncoding:NSUTF8StringEncoding];//将string 转换成 NSdata
//              NSLog(@"data %@",data);
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];//将 NSdata转换成 字典
//             NSLog(@"json %@",json);
//            NSData* data = [@"responseString" dataUsingEncoding:NSUTF8StringEncoding];
          
//            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            NSLog(@"array %@",array);
            
            
            NSString* callBackData = [json valueForKey:@"data"];
            // 如果成功
            NSError *error = nil;
//            NSArray *respArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (error) {
                return;
            }
//            NSMutableArray *newList = [[NSMutableArray alloc] init];
//            for(NSArray* item in callBackData)
//            {
//                NSString* title = [item valueForKey:@"title"];
//                //NSLog(@"%@",nickname);
////                NSString* ID = [item valueForKey:@"id"];
//                NSString* string = [NSString stringWithFormat:@"%@",title];
//            
//                [newList addObject:string];
//            }
            for (NSDictionary *dic in callBackData) {
//                NSLog(@"%@", dic);
                
                NewsTmbnl *e = [[NewsTmbnl alloc] init];
                
                
                e.content=[dic objectForKey:@"content"];
                e.ID = [dic objectForKey:@"id"];
//                e.classify = [dic objectForKey:@"class"];
                e.title = [dic objectForKey:@"title"];
                
                
                
                if ([[dic objectForKey:@"picURL"] isKindOfClass:[NSNull class]]) {
                    e.imageURL = @"";
                } else {
                    e.imageURL = [dic objectForKey:@"picURL"];
                }
                [self.arr addObject:e];
            }
        }
        [self performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:YES];
    }];
    [dataTask resume];
//    [appDelegate.netEngine enqueueOperation:_operation];
}


//这是目录的table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell";
    NewsTmbnlTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[NewsTmbnlTableViewCell alloc] initWithReuseIdentifier:cellIdentifier];
    }
    
    NewsTmbnl *element = [self.arr objectAtIndex:indexPath.row];
    [cell assignValueWithID:element.ID classify:[NewsTmbnlTableViewCell getDiseaseNameInChinese:element.classify] title:element.title imageURL:element.imageURL content:element.content];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewsTmbnl *currentElement = [self.arr objectAtIndex:indexPath.row];
    NewsDetailViewController *detailVC = [[NewsDetailViewController alloc] initWithId:currentElement.ID];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
