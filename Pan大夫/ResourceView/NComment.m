//
//  Comment.m
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import "NComment.h"

@implementation NComment

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithRawData:(NSDictionary *)rawData {
    self = [super init];
    if (self) {
  //      _userId = [rawData objectForKey:@"userID"];
        _content = [rawData objectForKey:@"commentContent"];
        _time = [rawData objectForKey:@"commentTime"];
    }
    return self;
}

@end
