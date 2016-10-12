//
//  ServiceItemViewModel.m
//  Pan大夫
//
//  Created by 张星宇 on 15/9/8.
//  Copyright (c) 2015年 Neil. All rights reserved.
//

#import "ServiceItemViewModel.h"
#import "AppDelegate.h"

@interface ServiceItemViewModel()

@property (strong, nonatomic) MKNetworkOperation *netOp;
@property (strong, nonatomic) NSMutableArray *urls;

@end


static NSArray* idArray;

@implementation ServiceItemViewModel

- (RACSignal *)fetchItemPictureUrlWithPage:(int)pageNumber{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        NSString *path = [NSString stringWithFormat:@"request.php?request=activity"];
        _netOp = [appDelegate.netEngine operationWithPath:path];
        [_netOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            @strongify(self);
            id json = [completedOperation responseJSON];
            NSDictionary *jsonDic = (NSDictionary *)json;
            if ([[jsonDic objectForKey:@"rowNumber"] integerValue] == 0) {
                NSError *error = [[NSError alloc] initWithDomain:NoUrlError code:-1 userInfo:nil];
                [subscriber sendError:error];
                [subscriber sendCompleted];
            }
            else{
                
                NSArray *urlArray = [jsonDic objectForKey:@"URLs"];
                NSArray *currentArray = [jsonDic objectForKey:@"ID"];
                if (pageNumber == 1) {
                    self.urls = [[NSMutableArray alloc] initWithArray:urlArray];  // 这是刷新
                    idArray = [[NSArray alloc] initWithArray:currentArray];
                }
                else{
                  //  [self.urls addObjectsFromArray:urlArray];
                    idArray = [[NSArray alloc] initWithArray:currentArray];
                }

                [subscriber sendNext:self.urls];  // 传过来的是url的数组，其中每个元素就是一个URL
                [subscriber sendCompleted];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [subscriber sendError:error];
            [subscriber sendCompleted];
        }];
        
        [appDelegate.netEngine enqueueOperation:_netOp];
        return nil;
    }];
}
         
         +(NSArray*)getIDArray{
             return  idArray;
         }
         
         +(void)setIDArray:(NSArray *)IDArray{
             idArray = IDArray;
         }
@end
