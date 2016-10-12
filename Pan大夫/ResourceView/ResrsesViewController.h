//
//  ResrsesViewController.h
//  Pan大夫
//
//  Created by Carl Lee on 4/15/16.
//  Copyright © 2016 Neil. All rights reserved.
//
//暂时没用
#import <UIKit/UIKit.h>
#import <MJRefresh.h>

#import "AppDelegate.h"
#import "MKNetworkEngine.h"
#import "NewsTmbnlTableViewCell.h"
#import "NewsTmbnl.h"
#import "NewsDetailViewController.h"

@interface ResrsesViewController : UITableViewController

@property (strong, nonatomic) MKNetworkOperation *operation;
@property (nonatomic) NSMutableArray *arr;

@property (nonatomic) NSInteger page;

@end
