
//
//  Singleton.h
//  Pan大夫
//
//  Created by 刘明瑞 on 16/10/9.
//  Copyright © 2016年 Neil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Singleton : NSObject

@property(strong,nonatomic)NSString *selectedID;
@property(strong,nonatomic)NSMutableDictionary *userDictonary;
@property(strong,nonatomic)NSString* nickname;
@property(strong,nonatomic)NSString *tel;
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic)NSString *commentID;
+(instancetype) getInstance;

@end
