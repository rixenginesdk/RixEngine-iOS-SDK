//
//  AlxTopOnRewardVideoAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnRewardVideoAdapter.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnRewardVideoDelegate.h"
#import "AlxTopOnRewardVideoEvent.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnTool.h"

static NSString *const TAG = @"AlxTopOnRewardVideoAdapter";

@interface AlxTopOnRewardVideoAdapter ()
@property (nonatomic, strong) AlxRewardVideoAd *rewardedAd;
@property (nonatomic, strong) AlxTopOnRewardVideoDelegate *rewardVideoDelegate;
@end

@implementation AlxTopOnRewardVideoAdapter

#pragma mark - lazy load
- (AlxTopOnRewardVideoDelegate *)rewardVideoDelegate {
    if (_rewardVideoDelegate == nil) {
        _rewardVideoDelegate = [[AlxTopOnRewardVideoDelegate alloc] init];
        _rewardVideoDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _rewardVideoDelegate;
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
            // Bidding 场景：从缓存中取出已加载的广告 / Bidding scenario: retrieve the pre-loaded ad from cache
            AlxTopOnBiddingRequest *biddingRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:unitId];
            if (biddingRequest) {
                self.rewardedAd = (AlxRewardVideoAd *)biddingRequest.customObject;
                
                if (self.rewardedAd) {
                    NSLog(@"%@: loadAD: bid ad loaded, notify success", TAG);
                    // ⚠️ 注意：将广告对象传给 TopOn SDK / Note: pass the ad object to TopOn SDK
                    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
                    adExtra[kATAdAssetsCustomObjectKey] = self.rewardedAd;
                    [self.adStatusBridge atOnRewardedAdLoadedExtra:adExtra];
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
            // 普通加载场景 / Normal loading scenario
            self.rewardedAd = [[AlxRewardVideoAd alloc] init];
            self.rewardedAd.delegate = self.rewardVideoDelegate;
            // 设置 Delegate 的广告对象引用 / Set the delegate's ad object reference
            self.rewardVideoDelegate.rewardedAd = self.rewardedAd;
            
            NSLog(@"%@: start loading ad with unitId: %@", TAG, unitId);
            [self.rewardedAd loadAdWithAdUnitId:unitId];
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
    
    AlxTopOnRewardVideoEvent *customEvent = [[AlxTopOnRewardVideoEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    
    AlxTopOnBiddingRequest *request = [[AlxTopOnBiddingRequest alloc]
                                       initWithUnitGroup:unitGroupModel
                                       customEvent:customEvent
                                       unitID:info[[AlxTopOnBaseManager unitID]]
                                       placementID:placementModel.placementID
                                       extraInfo:info
                                       adType:ATAdFormatRewardedVideo
                                       bidCompletion:completion];
    
    [[AlxTopOnBiddingRequestManager shared] startWithRequest:request];
}

#pragma mark - Ad Ready Check (实例方法 / Instance Method)
- (BOOL)adReadyRewardedWithInfo:(NSDictionary *)info {
    NSLog(@"%@: adReadyRewardedWithInfo", TAG);
    
    // 检查广告对象是否准备好 / Check if the ad object is ready
    if (self.rewardedAd) {
        // 可以调用 isReady 或其他检查方法 / Can call isReady or other check methods
        NSLog(@"%@: adReady = YES", TAG);
        return YES;
    }
    
    NSLog(@"%@: adReady = NO", TAG);
    return NO;
}

#pragma mark - Show Ad (实例方法 / Instance Method)
- (void)showRewardedVideoInViewController:(UIViewController *)viewController {
    NSLog(@"%@: showRewardedVideoInViewController", TAG);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.rewardedAd) {
            // 展示广告 / Show the ad
            [self.rewardedAd showAdWithPresent:viewController];
            NSLog(@"%@: ad shown", TAG);
        } else {
            NSLog(@"%@: rewardedAd is nil", TAG);
        }
    });
}

@end
