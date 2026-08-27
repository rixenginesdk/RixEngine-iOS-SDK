//
//  AlxTopOnTool.m
//  AlxAdsOCDemo
//

#import "AlxTopOnTool.h"

@interface AlxTopOnTool ()
@property (nonatomic, strong) NSMutableDictionary *requestDic;
@end

@implementation AlxTopOnTool

+ (instancetype)shared {
    static AlxTopOnTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AlxTopOnTool alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestDic = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID {
    @synchronized (self) {
        [self.requestDic setValue:request forKey:unitID];
    }
}

- (id)getRequestItemWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        return [self.requestDic objectForKey:unitID];
    }
}

- (void)removeRequestItemWithUnitID:(NSString *)unitID {
    @synchronized (self) {
        [self.requestDic removeObjectForKey:unitID];
    }
}

@end
