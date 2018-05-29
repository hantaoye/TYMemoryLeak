//
//  TYMemoryLeakView.m
//  TY
//
//  Created by hanTaoYe on 2018/3/15.
//  Copyright © 2018年 Bilibili. All rights reserved.
//

#import "TYMemoryLeakView.h"
#import "UIView+MemoryLeak.h"
#import "TYMemoryLeak.h"

@interface TYMemoryLeakView ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UILabel *label;

@end

@implementation TYMemoryLeakView

+ (void)showInView:(UIView *)superview {
    [self showInView:superview config:nil];
}

+ (void)showInView:(UIView *)superview config:(TYMemoryLeakConfig *)config {
#if TYMEMORYLEAK
    if (config) {
        NSParameterAssert([config isKindOfClass:[TYMemoryLeakConfig class]]);
        [TYMemoryLeak shared].config = config;
    }
    TYMemoryLeakView *view = [[self alloc] initWithFrame:CGRectMake(20, 40, 300, 60)];
    view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    superview addSubview:view];
    [UIView memoryLeakHook];
#endif
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self addSubview:_btn];
    [_btn setBackgroundColor:[UIColor blueColor]];
    [_btn setTitle:@"开始" forState:UIControlStateNormal];
    _btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_btn addTarget:self action:@selector(_action:) forControlEvents:UIControlEventTouchUpInside];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 60)];
    [self addSubview:_label];
    _label.font = [UIFont systemFontOfSize:10];
    _label.numberOfLines = 0;
    [_label setTextColor:[UIColor redColor]];
    [_label setText:@"统计从点击“开始”到点击“结束”之间init但没dealloc的非UI开头的UIView子类"];
    
    [[TYMemoryLeak shared] clear];
}

- (void)_action:(UIButton *)sender {
    if (sender.tag == 0) { // 开始
        [sender setTitle:@"结束" forState:UIControlStateNormal];
        sender.tag = 1;
        [_label setText:@"点击后会log出未dealloc的非UI/_UI开头的UI子类"];
        [[TYMemoryLeak shared].config setMemoryLeakSwich:YES];
    } else { // 结束
        [sender setTitle:@"重新开始" forState:UIControlStateNormal];
        sender.tag = 0;
        [_label setText:@"点击会先清空之前的数据，重新统计"];
        [[TYMemoryLeak shared].config setMemoryLeakSwich:NO];
        [[TYMemoryLeak shared] showMemoryLeakObject];
        [[TYMemoryLeak shared] clear];
    }
}

@end
