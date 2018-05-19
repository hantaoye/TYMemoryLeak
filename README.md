# TYMemoryLeak

## OC内存泄露检测小工具

RAC/block用的越来越多，稍不注意就有循环引用发生， 自己写个小工具，方便查找问题。

## usage
```
[TYMemoryLeakView showInView:self.view];

/// 配置忽略文件和输出方式
+ (void)showInView:(UIView *)superview config:(TYMemoryLeakConfig *)config;
```

## pod、Carthage
有时间搞一下

