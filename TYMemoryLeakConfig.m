//
//  TYMemoryLeakConfig.m
//  bili-universal
//
//  Created by hanTaoYe on 2018/5/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "TYMemoryLeakConfig.h"

@interface TYMemoryLeakConfig ()

@property (nonatomic, strong, readwrite) NSMutableSet <TYMemoryLeakIgnoreRule *> *ignoreRules;

@end

@implementation TYMemoryLeakConfig

- (instancetype)init {
    if (self = [super init]) {
        _ignoreRules = [NSMutableSet set];
        [_ignoreRules addObject:[TYMemoryLeakIgnoreRule ruleWithTarget:@"_UI" type:TYMemoryLeakIgnoreTypeClassNamePrefix]];
        [_ignoreRules addObject:[TYMemoryLeakIgnoreRule ruleWithTarget:@"UI" type:TYMemoryLeakIgnoreTypeClassNamePrefix]];
        
        self.debugMode = TYMemoryLeakDebugModeAlert | TYMemoryLeakDebugModeConsole;
    }
    return self;
}

- (void)addIgnoreRule:(TYMemoryLeakIgnoreRule *)rule {
    NSAssert([rule isKindOfClass:[TYMemoryLeakIgnoreRule class]], @"参数错误");
    [_ignoreRules addObject:rule];
}

@end
