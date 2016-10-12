//
//  Comment.h
//  Pan大夫
//
//  Created by Carl Lee on 6/19/16.
//  Copyright © 2016 Neil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NComment : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *time;

- (instancetype)init;
- (instancetype)initWithRawData:(NSDictionary *)rawData;

@end
