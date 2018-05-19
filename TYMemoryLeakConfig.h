//
//  TYMemoryLeakConfig.h
//  bili-universal
//
//  Created by hanTaoYe on 2018/5/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYMemoryLeakIgnoreRule.h"

#ifdef DEBUG
#define TYMEMORYLEAK 1
#else
#define TYMEMORYLEAK 0
#endif

typedef NS_OPTIONS(NSUInteger, TYMemoryLeakDebugMode) {
    TYMemoryLeakDebugModeAlert         = 1 << 0,   //!< 弹窗
    TYMemoryLeakDebugModeConsole       = 1 << 1,   //!< 控制台输出
    TYMemoryLeakDebugModeCrash         = 1 << 2,   //!< 崩溃
    TYMemoryLeakDebugModeAll           = TYMemoryLeakDebugModeAlert | TYMemoryLeakDebugModeConsole | TYMemoryLeakDebugModeCrash
};

@interface TYMemoryLeakConfig : NSObject

@property (nonatomic, strong, readonly) NSSet <TYMemoryLeakIgnoreRule *> *ignoreRules;

@property (nonatomic, assign) TYMemoryLeakDebugMode debugMode;

@property (nonatomic, assign) BOOL memoryLeakSwich;

/**
 添加忽略类型
 
 @param rule 忽略类型规则
 */
- (void)addIgnoreRule:(TYMemoryLeakIgnoreRule *)rule;

@end
