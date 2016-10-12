//
//  ViewController.m
//  Demo_homepage
//
//  Created by lf on 15/3/7.
//  Copyright (c) 2015年 lf. All rights reserved.
//

#import "ServiceItemViewController.h"
#import "EventDetailViewController.h"
#import "ServiceItemViewModel.h"


#import "UIImageView+WebCache.h"
#import <MJRefresh.h>
#import <MBProgressHUD.h>

#define kCellHeight 160.f
#define kImageMargin 5.f

@interface ServiceItemViewController () {
    int _currentPageNumber;
}

//@property (nonatomic, assign) int currentPageNumber;
//@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) ServiceItemViewModel *serviceItemViewModel;
@property (strong, nonatomic) NSArray *modelArray;
@property (strong, nonatomic) UIImageView *cellImageView;

// 下拉刷新控件
//@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end



@implementation ServiceItemViewController
@synthesize refreshControl;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _serviceItemViewModel = [[ServiceItemViewModel alloc] init];
        _currentPageNumber = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // self.view 初始化
    self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -49)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        _currentPageNumber = 1;
////        [self showHud];
//
//        [[_serviceItemViewModel fetchItemPictureUrlWithPage:_currentPageNumber] subscribeNext:^(id x) {
//            _modelArray = x;
//        } error:^(NSError *e){/* 有一点问题 */} completed:^{
////            [self hideHud];
//            [_tableView.header endRefreshing];
//            [_tableView reloadData];
//        }];
//    }];
    
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPageNumber ++;
        [self showHud];
        [[_serviceItemViewModel fetchItemPictureUrlWithPage:_currentPageNumber] subscribeNext:^(id x) {
            _modelArray = x;
        } error:^(NSError *error) {
            if ([error.domain isEqualToString:NoUrlError]) {
                [self hideHud];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有更多数据了" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [alertView show];
            };
            [self.tableView.footer endRefreshing];
        } completed:^{
            [self hideHud];
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }];
    }];

    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshImages:)
             forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:refreshControl];
    
    [refreshControl beginRefreshing];
    [self refreshImages:nil];
}

#pragma mark - 下拉刷新
// 进入主页面就会调用一次
// 提示文字被注释掉是因为看起来不协调
- (void)refreshImages:(id)sender {
    _currentPageNumber = 1;
    
    if (self.refreshControl.refreshing) {
//        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在刷新"];
        [[_serviceItemViewModel fetchItemPictureUrlWithPage:_currentPageNumber] subscribeNext:^(id x) {
            _modelArray = x;
        } error:^(NSError *e){} completed:^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
//            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_modelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceItemCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceItemCell"];
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageMargin, kImageMargin, kScreenWidth - 2 * kImageMargin, kCellHeight - 2 * kImageMargin)];
        _cellImageView.layer.masksToBounds = YES;
        _cellImageView.layer.cornerRadius = 10;
        [cell.contentView addSubview:_cellImageView];
    }
    //在此处加载图片
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:[_modelArray objectAtIndex:[indexPath row]]] placeholderImage:[UIImage imageNamed:@"ImageLoadError"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    NSArray *array = [ServiceItemViewModel getIDArray];
    Singleton* singleton = [Singleton getInstance];
    singleton.selectedID = array[row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];  // 取消选中状态
    EventDetailViewController *eventDetailViewController = [[EventDetailViewController alloc] init];
   
    [self.delegate pushViewController:eventDetailViewController animated:YES];
}

- (void)showHud{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.tableView];
    [self.view addSubview:hud];
    hud.labelText = @"加载中";
    [hud show:YES];
}

- (void)hideHud{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end
