//
//  UIView+MemoryLeak.h
//  BBLive
//
//  Created by hanTaoYe on 2018/3/7.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MemoryLeak)

+ (void)memoryLeakHook;

@end
