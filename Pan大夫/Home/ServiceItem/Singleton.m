//
//  Singleton.m
//  Pan大夫
//
//  Created by 刘明瑞 on 16/10/9.
//  Copyright © 2016年 Neil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"


@interface Singleton()


@end

static Singleton* singleton = nil;




@implementation Singleton



+ (instancetype)getInstance {
    
    // GCD创建单例，效率更高，性能更好，消耗更低。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[Singleton alloc] init];
    });
    return singleton;
}


@end
