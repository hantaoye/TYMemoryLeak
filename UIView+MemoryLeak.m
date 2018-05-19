//
//  UIView+MemoryLeak.m
//  BBLive
//
//  Created by hanTaoYe on 2018/3/7.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "UIView+MemoryLeak.h"
#import <objc/runtime.h>
#import "TYMemoryLeak.h"

@implementation UIView (MemoryLeak)

+ (void)_swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)memoryLeakHook {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        [self _swizzleSEL:@selector(initWithFrame:) withSEL:@selector(ty_initWithFrame:)];
        [self _swizzleSEL:NSSelectorFromString(@"dealloc") withSEL:@selector(ty_dealloc)];
    });
}

- (void)ty_dealloc {
    [[TYMemoryLeak shared] removeWillDeallocView:self];
    return [self ty_dealloc];
}

- (instancetype)ty_initWithFrame:(CGRect)frame {
    if ([TYMemoryLeak shared].config.memoryLeakSwich) {
        [[TYMemoryLeak shared] addInstanceView:self];
    }
   return [self ty_initWithFrame:frame];
}


@end
