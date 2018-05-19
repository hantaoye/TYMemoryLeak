//
//  TYMemoryLeakIgnoreRule.h
//  TY
//
//  Created by Abin on 2018/3/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TYMemoryLeakIgnoreType) {
    TYMemoryLeakIgnoreTypeClassNamePrefix = 0,
    TYMemoryLeakIgnoreTypeClassNameSuffix = 1,
//    TYMemoryLeakIgnoreTypeClassNameContain = 2,
    TYMemoryLeakIgnoreTypeClassNameMatch = 3,
    TYMemoryLeakIgnoreTypeIsKindOfClass = 4,
    TYMemoryLeakIgnoreTypeRespondsMethod = 5,
};

@interface TYMemoryLeakIgnoreRule : NSObject

@property (nonatomic, copy) NSString *target;
@property (nonatomic, assign) TYMemoryLeakIgnoreType type;

+ (instancetype)ruleWithTarget:(NSString *)target type:(TYMemoryLeakIgnoreType)type;

- (BOOL)validate:(id)obj;

@end
