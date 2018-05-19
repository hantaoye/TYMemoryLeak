//
//  TYMemoryLeakIgnoreRule.m
//  TY
//
//  Created by Abin on 2018/3/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "TYMemoryLeakIgnoreRule.h"

@implementation TYMemoryLeakIgnoreRule

+ (instancetype)ruleWithTarget:(NSString *)target type:(TYMemoryLeakIgnoreType)type {
    TYMemoryLeakIgnoreRule *rule = [[TYMemoryLeakIgnoreRule alloc] init];
    rule.target = target;
    rule.type = type;
    return rule;
}

- (BOOL)validate:(id)obj {
    if (!obj) return NO;
    switch (self.type) {
        case TYMemoryLeakIgnoreTypeClassNamePrefix:
            return [NSStringFromClass([obj class]) hasPrefix:self.target];
            break;
        case TYMemoryLeakIgnoreTypeClassNameSuffix:
            return [NSStringFromClass([obj class]) hasSuffix:self.target];
            break;
        case TYMemoryLeakIgnoreTypeClassNameMatch:
            return [NSStringFromClass([obj class]) isEqualToString:self.target];
            break;
        case TYMemoryLeakIgnoreTypeIsKindOfClass:
            return [obj isKindOfClass:NSClassFromString(self.target)];
            break;
        case TYMemoryLeakIgnoreTypeRespondsMethod:
            return [obj respondsToSelector:NSSelectorFromString(self.target)];
            break;
    }
    return NO;
}

@end
