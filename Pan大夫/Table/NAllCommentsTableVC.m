//
//  NAllCommentsTableVC.m
//  Pan大夫
//
//  Created by Carl Lee on 5/7/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "NAllCommentsTableVC.h"
#import "MKNetworkOperation.h"
#import "AppDelegate.h"

@interface NAllCommentsTableVC ()

@property (nonatomic, assign) NSString *articleID;
@property (nonatomic) NSMutableArray *dataArray;

@end

@implementation NAllCommentsTableVC

- (instancetype)initWithArticleID:(NSString *)articleID {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.articleID = articleID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 网络请求
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MKNetworkOperation *operation = [appDelegate.netEngine operationWithPath:@""];
    [operation addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSDictionary *JSONData = (NSDictionary *)[completedOperation responseJSON];
        [self.dataArray addObjectsFromArray:(NSArray *)[JSONData objectForKey:@"list"]];
        [self performSelectorOnMainThread:@selector(tableReload) withObject:nil waitUntilDone:NO];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableReload {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleCommentTableViewCell *cell = (SingleCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell) {
        NSDictionary *element = [self.dataArray objectAtIndex:indexPath.row];
        NSString *name = [element objectForKey:@"name"];
        NSString *content = [element objectForKey:@"content"];
        [cell assignValueWithName:name content:content];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *element = [self.dataArray objectAtIndex:indexPath.row];
    NSString *content = [element objectForKey:@"content"];
    CGFloat contentHeight = [content sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}].height;
    return 10 /* 顶端距离 */ + 20 /* 名字 Label 高度 */ + 10 /* 两个 Label 间距 */ + contentHeight + 10 /* 下端距离 */;
}

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
