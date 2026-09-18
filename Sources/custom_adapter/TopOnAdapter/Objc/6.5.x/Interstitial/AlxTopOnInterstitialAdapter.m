//
//  AlxTopOnInterstitialAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnInterstitialAdapter.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnInterstitialDelegate.h"
#import "AlxTopOnInterstitialEvent.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnTool.h"

static NSString *const TAG = @"AlxTopOnInterstitialAdapter";

@interface AlxTopOnInterstitialAdapter ()
// Alx SDK 插屏广告对象 / Alx SDK interstitial ad object
@property (nonatomic, strong) AlxInterstitialAd *interstitialAd;
// 广告事件代理 / Ad event delegate
@property (nonatomic, strong) AlxTopOnInterstitialDelegate *interstitialDelegate;
@end

@implementation AlxTopOnInterstitialAdapter

#pragma mark - 懒加载 / Lazy Load

- (AlxTopOnInterstitialDelegate *)interstitialDelegate {
    if (_interstitialDelegate == nil) {
        _interstitialDelegate = [[AlxTopOnInterstitialDelegate alloc] init];
        _interstitialDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _interstitialDelegate;
}

#pragma mark - 广告加载 / Ad Load

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
            // Bidding scenario: retrieve the pre-loaded ad from cache
            AlxTopOnBiddingRequest *biddingRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:unitId];
            if (biddingRequest) {
                self.interstitialAd = (AlxInterstitialAd *)biddingRequest.customObject;
                
                if (self.interstitialAd) {
                    NSLog(@"%@: loadAD: bid ad loaded, notify success", TAG);
                    // ⚠️ 注意：将广告对象传给 TopOn SDK
                    // ⚠️ Note: Pass the ad object to the TopOn SDK
                    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
                    adExtra[kATAdAssetsCustomObjectKey] = self.interstitialAd;
                    [self.adStatusBridge atOnInterstitialAdLoadedExtra:adExtra];
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
            // 普通加载场景 / Normal (non-bidding) load scenario
            self.interstitialAd = [[AlxInterstitialAd alloc] init];
            self.interstitialAd.delegate = self.interstitialDelegate;
            // 设置 Delegate 的广告对象引用 / Set the ad object reference on the delegate
            self.interstitialDelegate.interstitialAd = self.interstitialAd;
            
            NSLog(@"%@: start loading ad with unitId: %@", TAG, unitId);
            [self.interstitialAd loadAdWithAdUnitId:unitId];
        }
    });
}

#pragma mark - C2S 竞价 / C2S Bidding

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
    
    AlxTopOnInterstitialEvent *customEvent = [[AlxTopOnInterstitialEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    
    AlxTopOnBiddingRequest *request = [[AlxTopOnBiddingRequest alloc]
                                       initWithUnitGroup:unitGroupModel
                                       customEvent:customEvent
                                       unitID:info[[AlxTopOnBaseManager unitID]]
                                       placementID:placementModel.placementID
                                       extraInfo:info
                                       adType:ATAdFormatInterstitial
                                       bidCompletion:completion];
    
    [[AlxTopOnBiddingRequestManager shared] startWithRequest:request];
}

#pragma mark - 广告就绪检查（实例方法）/ Ad Ready Check (Instance Method)

- (BOOL)adReadyInterstitialWithInfo:(NSDictionary *)info {
    NSLog(@"%@: adReadyInterstitialWithInfo", TAG);
    
    // 检查广告对象是否准备好 / Check whether the ad object is ready
    if (self.interstitialAd) {
        NSLog(@"%@: adReady = YES", TAG);
        return YES;
    }
    
    NSLog(@"%@: adReady = NO", TAG);
    return NO;
}

#pragma mark - 展示广告（实例方法）/ Show Ad (Instance Method)

- (void)showInterstitialInViewController:(UIViewController *)viewController {
    NSLog(@"%@: showInterstitialInViewController", TAG);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.interstitialAd) {
            // 展示广告 / Show the ad
            [self.interstitialAd showAdWithPresent:viewController];
            NSLog(@"%@: ad shown", TAG);
        } else {
            NSLog(@"%@: interstitialAd is nil", TAG);
        }
    });
}

@end
