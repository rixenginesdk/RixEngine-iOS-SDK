//
//  AlxTopOnCustomBaseAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBaseAdapter.h"

@implementation AlxTopOnBaseAdapter

#pragma mark - adapter init class name define
- (Class)initializeClassName {
    // 返回创建的初始化适配器类 / Return the initialization adapter class
    return [AlxTopOnInitAdapter class];
}

@end
