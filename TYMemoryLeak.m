//
//  TYMemoryLeak.m
//  bili-universal
//
//  Created by hanTaoYe on 2018/5/19.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "TYMemoryLeak.h"
#import "TYMemoryLeakIgnoreRule.h"

#if TYMEMORYLEAK

static NSString * const __componentString = @"----";

@interface TYMemoryLeak ()

@property (nonatomic, strong) NSMutableSet *instanceViewSets;

@end

@implementation TYMemoryLeak

+ (instancetype)shared {
    static TYMemoryLeak *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[TYMemoryLeak alloc] init];
    });
    return __instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self _setup];
    }
    return self;
}

#pragma mark - public

- (void)addInstanceView:(UIView *)view {
    NSAssert([view isKindOfClass:[UIView class]], @"class error");
    NSParameterAssert([view isKindOfClass:[UIView class]]);
    BOOL __flag = YES;
    for (TYMemoryLeakIgnoreRule *rule in [self.config ignoreRules]) {
        if ([rule validate:view]) {
            __flag = NO;
            break;
        }
    }
    if (__flag) {
        NSString *className = NSStringFromClass([view class]);
        [_instanceViewSets addObject:[NSString stringWithFormat:@"%@%@%p", className, __componentString, view]];
    }
}

- (void)removeWillDeallocView:(UIView *)view {
    NSString *className = NSStringFromClass([view class]);
    NSString *object = [NSString stringWithFormat:@"%@%@%p", className, __componentString, view];
    if ([[self instanceViewSets] containsObject:object]) {
        [[self instanceViewSets] removeObject:object];
    }
}

- (void)clear {
    [self.instanceViewSets removeAllObjects];
}

- (void)showMemoryLeakObject {
    NSMutableString *log = [NSMutableString stringWithString:@"===========以下是init但没dealloc的UI子类===============\n"];
    for (NSString *str in self.instanceViewSets) {
        NSArray *arr = [str componentsSeparatedByString:__componentString];
        NSString *p = [arr lastObject];
        
        // 根据 内存地址 获取 对象
        uintptr_t hex = strtoull(p.UTF8String, NULL, 0);
        id gotcha = (__bridge id)(void *)hex;
        if (gotcha == nil) {
            NSLog(@"我擦，果然有问题");
        } else {
            NSString *className = [NSString stringWithFormat:@"%@", [gotcha class]];
            [log appendString:[NSString stringWithFormat:@"%@\n", [self _getLogStrWithObject:gotcha defaultStr:className]]];
        }
    }
    [log appendString:@"=========== 到此为止 ==============="];
    
    if (!self.instanceViewSets.count) {
        log = [@"good, 没有泄露" mutableCopy];
    }
    if ([self _hasDebugMode:TYMemoryLeakDebugModeAlert]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:log delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    if ([self _hasDebugMode:TYMemoryLeakDebugModeConsole]) {
        NSLog(@"%@", log);
    }
    if ([self _hasDebugMode:TYMemoryLeakDebugModeCrash]) {
        if (self.instanceViewSets.count) {
            NSAssert(0, log);
        } else {
            NSLog(@"good, 没有泄露");
        }
    }
}

#pragma mark - private

- (void)_setup {
    _instanceViewSets = [NSMutableSet set];
    self.config = [[TYMemoryLeakConfig alloc] init];
}

- (BOOL)_hasDebugMode:(TYMemoryLeakDebugMode)mode {
    return (self.config.debugMode & mode) == mode;
}

- (NSString *)_getLogStrWithObject:(id)gotcha defaultStr:(NSString *)defaultStr {
    if ([gotcha nextResponder] && ![[gotcha nextResponder] isMemberOfClass:[UIViewController class]]) {
        id nextResponder = [gotcha nextResponder];
        defaultStr = [defaultStr stringByAppendingString:[NSString stringWithFormat:@"->%@",  NSStringFromClass([nextResponder class])]];
        return [self _getLogStrWithObject:nextResponder defaultStr:defaultStr];
    } else {
        return defaultStr;
    }
}

- (void)setConfig:(TYMemoryLeakConfig *)config {
    _config = config;
    [self clear];
}

@end

#endif
