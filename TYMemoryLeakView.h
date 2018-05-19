//
//  TYMemoryLeakView.h
//  TY
//
//  Created by hanTaoYe on 2018/3/15.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYMemoryLeakConfig.h"

@interface TYMemoryLeakView : UIView

+ (void)showInView:(UIView *)superview;

+ (void)showInView:(UIView *)superview config:(TYMemoryLeakConfig *)config;

@end
