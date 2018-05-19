//
//  TYMemoryLeak.h
//  bili-universal
//
//  Created by hanTaoYe on 2018/5/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMemoryLeakIgnoreRule.h"
#import "TYMemoryLeakConfig.h"

#if TYMEMORYLEAK

@interface TYMemoryLeak : NSObject

@property (nonatomic, strong) TYMemoryLeakConfig *config;

+ (instancetype)shared;

/**
 添加实例化view

 @param view
 */
- (void)addInstanceView:(UIView *)view;

/**
 移除将要dealloc实例化view

 @param view 将要dealloc的view
 */
- (void)removeWillDeallocView:(UIView *)view;

/**
 清空记录
 */
- (void)clear;

/**
 展示泄露内容
 */
- (void)showMemoryLeakObject;

@end

#endif
