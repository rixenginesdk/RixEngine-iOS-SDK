//
//  AlxTopOnNativeAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnNativeAdapter.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnNativeDelegate.h"
#import "AlxTopOnNativeEvent.h"
#import "AlxTopOnNativeObject.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnTool.h"
#import "AlxTopOnNativeRender.h"

static NSString *const TAG = @"AlxTopOnNativeAdapter";

@interface AlxTopOnNativeAdapter ()
@property (nonatomic, strong) AlxNativeAdLoader *nativeAdLoader;
@property (nonatomic, strong) AlxNativeAd *nativeAd;
@property (nonatomic, strong) AlxTopOnNativeDelegate *nativeDelegate;
@property (nonatomic, strong) AlxTopOnNativeEvent *nativeEvent;  // 用于传递给 TopOn SDK
@end

@implementation AlxTopOnNativeAdapter

#pragma mark - lazy load
- (AlxTopOnNativeDelegate *)nativeDelegate {
    if (_nativeDelegate == nil) {
        _nativeDelegate = [[AlxTopOnNativeDelegate alloc] init];
        _nativeDelegate.adStatusBridge = self.adStatusBridge;
        _nativeDelegate.nativeEvent = self.nativeEvent;  // 设置 Event 引用
    }
    return _nativeDelegate;
}

- (AlxTopOnNativeEvent *)nativeEvent {
    if (_nativeEvent == nil) {
        // 创建一个 Event 对象用于传递给 TopOn SDK
        _nativeEvent = [[AlxTopOnNativeEvent alloc] initWithInfo:@{} localInfo:@{}];
    }
    return _nativeEvent;
}

#pragma mark - Ad load
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    NSLog(@"%@: loadADWithArgument", TAG);
    NSLog(@"%@: loadAD: isMainThread=%@", TAG, [NSThread isMainThread] ? @"YES" : @"NO");
    
    NSString *bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey];
    NSLog(@"%@: loadAD: bidId=%@", TAG, bidId ?: @"空");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *unitKeyStr = [AlxTopOnBaseManager unitID];
        NSString *unitId = argument.serverContentDic[unitKeyStr];
        
        if (!unitId || unitId.length == 0) {
            NSString *errorStr = @"unitid is empty";
            NSLog(@"%@: loadAD: error = %@", TAG, errorStr);
            NSError *error = [AlxTopOnBaseManager errorWithCode:-100 message:errorStr];
            [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
            return;
        }
        NSLog(@"%@: loadAD: unitid = %@", TAG, unitId);
        
        if (bidId) {
            // Bidding 场景：从缓存中取出已加载的广告
            AlxTopOnBiddingRequest *biddingRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:unitId];
            if (biddingRequest) {
                self.nativeAd = (AlxNativeAd *)biddingRequest.customObject;
                
                if (self.nativeAd) {
                    NSLog(@"%@: loadAD: bid ad loaded, creating native object", TAG);
                    
                    // ⚠️ 正确方式：创建 AlxTopOnNativeObject 对象
                    AlxTopOnNativeObject *nativeObject = [[AlxTopOnNativeObject alloc] init];
                    nativeObject.nativeAd = self.nativeAd;
                    nativeObject.nativeEvent = self.nativeEvent;
                    
                    // ✅ 关键：设置 nativeAd 的 delegate，以便接收展示、点击、关闭回调
                    self.nativeAd.delegate = self.nativeDelegate;
                    
                    // ⚠️ 传递对象数组
                    [self.adStatusBridge atOnNativeAdLoadedArray:@[nativeObject] adExtra:@{}];
                } else {
                    NSLog(@"%@: loadAD: bid ad object is empty", TAG);
                    NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid ad object is empty"}];
                    [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
                }
            } else {
                NSLog(@"%@: loadAD: bid request not found in cache", TAG);
                NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid request not found"}];
                [self.adStatusBridge atOnAdLoadFailed:error adExtra:@{}];
            }
            [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitId];
        } else {
            // 普通加载场景
            self.nativeAdLoader = [[AlxNativeAdLoader alloc] initWithAdUnitID:unitId];
            self.nativeAdLoader.delegate = self.nativeDelegate;
            
            NSLog(@"%@: start loading ad with unitId: %@", TAG, unitId);
            [self.nativeAdLoader loadAd];
        }
    });
}


#pragma mark - C2S Bidding
+ (void)bidRequestWithPlacementModel:(ATPlacementModel *)placementModel
                      unitGroupModel:(ATUnitGroupModel *)unitGroupModel
                                info:(NSDictionary *)info
                          completion:(void (^)(ATBidInfo * _Nullable, NSError * _Nullable))completion {
    NSLog(@"%@: bidRequestWithPlacementModel", TAG);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![AlxTopOnBaseManager isInitialized]) {
            [AlxTopOnBaseManager initSDKWithServerInfo:info];
        }
    });
    
    AlxTopOnNativeEvent *customEvent = [[AlxTopOnNativeEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    
    AlxTopOnBiddingRequest *request = [[AlxTopOnBiddingRequest alloc]
                                       initWithUnitGroup:unitGroupModel
                                       customEvent:customEvent
                                       unitID:info[[AlxTopOnBaseManager unitID]]
                                       placementID:placementModel.placementID
                                       extraInfo:info
                                       adType:ATAdFormatNative
                                       bidCompletion:completion];
    
    [[AlxTopOnBiddingRequestManager shared] startWithRequest:request];
}

// 实现协议中的类方法
+ (Class)rendererClass {
    NSLog(@"%@: rendererClass", TAG);
    // 返回对应的渲染类
    return [AlxTopOnNativeRender class];
}

@end
