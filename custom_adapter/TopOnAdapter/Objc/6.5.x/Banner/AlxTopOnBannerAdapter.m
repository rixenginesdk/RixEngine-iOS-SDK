//
//  AlxTopOnBannerAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBannerAdapter.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnBannerEvent.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnTool.h"
#import "AlxTopOnBannerDelegate.h"

static NSString *const TAG = @"AlxTopOnBannerAdapter";

/**
 * 告诉编译器：这个类其实是会这个协议的。
 * Tell the compiler that this class actually conforms to this protocol.
 */
@interface ATBannerAdStatusBridge (AlxDelegate) <AlxBannerViewAdDelegate>
@end

@interface AlxTopOnBannerAdapter ()
/**
 * Alx SDK 的 banner 广告对象。
 * Alx SDK banner ad object.
 */
@property (nonatomic, strong) AlxBannerAdView *bannerAd;
// delegate
@property (nonatomic, strong) AlxTopOnBannerDelegate *bannerDelegate;
@end

@implementation AlxTopOnBannerAdapter

#pragma mark - lazy load
/**
 * 初始化bannerDelegate属性。
 * Initialize the bannerDelegate property.
 */
- (AlxTopOnBannerDelegate *)bannerDelegate {
    if (_bannerDelegate == nil) {
        _bannerDelegate = [[AlxTopOnBannerDelegate alloc] init];
        _bannerDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _bannerDelegate;
}

#pragma mark - Ad load
/**
 * 实现广告加载方法。
 * Implement the ad loading method.
 */
- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    NSLog(@"%@: loadAD", TAG);
    NSLog(@"%@: loadAD: isMainThread=%@", TAG, [NSThread isMainThread] ? @"YES" : @"NO");
    
    NSString *bidId = argument.serverContentDic[kATAdapterCustomInfoBuyeruIdKey];
    NSLog(@"%@: loadAD: bidId=%@", TAG, bidId ?: @"空");
    
    // 文档要求，通常需要在主线程执行 / As required by the documentation, this usually needs to run on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *uuitKeyStr = [AlxTopOnBaseManager unitID];
        NSString *uuitId = argument.serverContentDic[uuitKeyStr];
        if (!uuitId || uuitId.length == 0) {
            NSString *errorStr = @"uuitid is empty";
            NSLog(@"%@: loadAD: error = %@", TAG, errorStr);
            [AlxTopOnBaseManager errorWithCode:-100 message:errorStr];
            return;
        }
        NSLog(@"%@: loadAD: uuitid = %@", TAG, uuitId);
        
        if (bidId) {
            // Bidding 场景：从缓存中取出已加载的广告 / Bidding scenario: retrieve the pre-loaded ad from cache
            AlxTopOnBiddingRequest *biddingRequest = [[AlxTopOnTool shared] getRequestItemWithUnitID:uuitId];
            if (biddingRequest) {
                self.bannerAd = (AlxBannerAdView *)biddingRequest.customObject;
                
                if (self.bannerAd) {
                    NSLog(@"%@: loadAD: bid ad loaded, notify success", TAG);
                    [self.adStatusBridge atOnBannerAdLoadedWithView:self.bannerAd adExtra:nil];
                } else {
                    NSLog(@"%@: loadAD: bid ad object is empty", TAG);
                    NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid ad object is empty"}];
                    [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
                }
            } else {
                NSLog(@"%@: loadAD: bid request not found in cache", TAG);
                NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid request not found"}];
                [self.adStatusBridge atOnAdLoadFailed:error adExtra:nil];
            }
            // ⚠️ 注意：移除缓存 / ⚠️ Note: Remove from cache
            [[AlxTopOnTool shared] removeRequestItemWithUnitID:uuitId];
        } else {
            ATUnitGroupModel *unitGroupModel = argument.serverContentDic[kATAdapterCustomInfoUnitGroupModelKey];
            // 通过argument对象获取必要的加载信息，如尺寸等，创建好必要的参数，准备传入给第三方的横幅加载方法，开始加载广告
            // Get necessary loading info (e.g. size) from the argument object, prepare parameters, and pass them to the third-party banner loading method to start loading the ad
            CGSize bannerSize = CGSizeMake(320, 50);
            if (!CGSizeEqualToSize(argument.bannerSize, CGSizeZero) && unitGroupModel) {
                bannerSize = argument.bannerSize;
                NSLog(@"%@: loadAD: width = %.2f, height = %.2f", TAG, bannerSize.width, bannerSize.height);
            }
            
            self.bannerAd = [[AlxBannerAdView alloc] initWithFrame:CGRectMake(0, 0, bannerSize.width, bannerSize.height)];
            
            // ⚠️ 注意：delegate 应该设置为 bannerDelegate，而不是 adStatusBridge
            // ⚠️ Note: delegate should be set to bannerDelegate, not adStatusBridge
            self.bannerAd.delegate = self.bannerDelegate;
            self.bannerAd.refreshInterval = 0;
            self.bannerAd.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLog(@"%@: start loading ad with unitId: %@", TAG, uuitId);
            [self.bannerAd loadAdWithAdUnitId:uuitId];
        }
    });
}


//- (instancetype)initWithNetworkCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
//    self = [super init];
//    if (self) {
//        NSLog(@"%@: init", TAG);
//        NSLog(@"%@: init: isMainThread=%@", TAG, [NSThread isMainThread] ? @"YES" : @"NO");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![AlxTopOnBaseManager isInitialized]) {
//                [AlxTopOnBaseManager initSDKWithServerInfo:serverInfo];
//            }
//        });
//    }
//    return self;
//}

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
    
    AlxTopOnBannerEvent *customEvent = [[AlxTopOnBannerEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    
    AlxTopOnBiddingRequest *request = [[AlxTopOnBiddingRequest alloc]
                                       initWithUnitGroup:unitGroupModel
                                       customEvent:customEvent
                                       unitID:info[[AlxTopOnBaseManager unitID]]
                                       placementID:placementModel.placementID
                                       extraInfo:info
                                       adType:ATAdFormatBanner
                                       bidCompletion:completion];
    
    [[AlxTopOnBiddingRequestManager shared] startWithRequest:request];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    NSLog(@"%@: adReady", TAG);
    if ([customObject isKindOfClass:[AlxBannerAdView class]]) {
        NSLog(@"%@: adReady true", TAG);
        return YES;
    } else {
        NSLog(@"%@: adReady false", TAG);
        return NO;
    }
}

+ (void)showBanner:(ATBanner *)banner inView:(UIView *)view presentingViewController:(UIViewController *)viewController {
    NSLog(@"%@: showBanner", TAG);
    AlxBannerAdView *bannerView = banner.customObject;
    if (!bannerView) {
        NSLog(@"%@: showBanner banner is nil", TAG);
        return;
    }
    
    bannerView.rootViewController = viewController;
    for (UIView *subview in view.subviews) {
        [subview removeFromSuperview];
    }
    [view addSubview:bannerView];
}

@end
