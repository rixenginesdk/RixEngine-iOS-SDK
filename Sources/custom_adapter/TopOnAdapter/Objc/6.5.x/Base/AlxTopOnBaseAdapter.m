//
//  AlxTopOnCustomBaseAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBaseAdapter.h"

@implementation AlxTopOnBaseAdapter

#pragma mark - 适配器初始化类名定义 / Adapter Init Class Name Definition

- (Class)initializeClassName {
    // 返回创建的初始化适配器类
    // Returns the initialization adapter class to be used.
    return [AlxTopOnInitAdapter class];
}

@end
