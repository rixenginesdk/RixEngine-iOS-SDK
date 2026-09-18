//
//  AlxTopOnSplashAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnSplashAdapter.h"
#import "AlxTopOnBaseManager.h"
#import "AlxTopOnSplashDelegate.h"
#import "AlxTopOnSplashEvent.h"
#import "AlxTopOnBiddingRequest.h"
#import "AlxTopOnBiddingRequestManager.h"
#import "AlxTopOnTool.h"

static NSString *const TAG = @"AlxTopOnSplashAdapter";

@interface AlxTopOnSplashAdapter ()

@property (nonatomic, strong) AlxSplashAd *splashAd;
@property (nonatomic, strong) AlxTopOnSplashDelegate *splashDelegate;

@end

@implementation AlxTopOnSplashAdapter

@synthesize adStatusBridge = _adStatusBridge;

#pragma mark - Lazy Load

- (AlxTopOnSplashDelegate *)getSplashDelegate {
    if (!_splashDelegate) {
        _splashDelegate = [[AlxTopOnSplashDelegate alloc] init];
        _splashDelegate.adStatusBridge = self.adStatusBridge;
    }
    return _splashDelegate;
}

#pragma mark - ATBaseSplashAdapterProtocol Ad Load

- (void)loadADWithArgument:(ATAdMediationArgument *)argument {
    NSLog(@"%@: loadAD", TAG);
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
            [self notifyLoadFailed:error];
            return;
        }
        NSLog(@"%@: loadAD: unitid = %@", TAG, unitId);

        // 自定义底部视图
        UIView *bottomView = nil;
        if ([argument.localInfoDic[kATSplashExtraNewBottomViewKey] isKindOfClass:[UIView class]]) {
            bottomView = argument.localInfoDic[kATSplashExtraNewBottomViewKey];
        } else if ([argument.serverContentDic[kATSplashExtraNewBottomViewKey] isKindOfClass:[UIView class]]) {
            bottomView = argument.serverContentDic[kATSplashExtraNewBottomViewKey];
        } else if ([argument.localInfoDic[kATSplashExtraContainerViewKey] isKindOfClass:[UIView class]]) {
            bottomView = argument.localInfoDic[kATSplashExtraContainerViewKey];
        }

        // autoCloseOnFinish
        BOOL autoClose = NO;
        if (argument.localInfoDic[@"autoCloseOnFinish"]) {
            autoClose = [argument.localInfoDic[@"autoCloseOnFinish"] boolValue];
        } else if (argument.serverContentDic[@"autoCloseOnFinish"]) {
            autoClose = [argument.serverContentDic[@"autoCloseOnFinish"] boolValue];
        } else if (argument.localInfoDic[@"auto_close"]) {
            autoClose = [argument.localInfoDic[@"auto_close"] boolValue];
        } else if (argument.serverContentDic[@"auto_close"]) {
            autoClose = [argument.serverContentDic[@"auto_close"] boolValue];
        } else if (argument.localInfoDic[@"is_auto_close"]) {
            autoClose = [argument.localInfoDic[@"is_auto_close"] boolValue];
        } else if (argument.serverContentDic[@"is_auto_close"]) {
            autoClose = [argument.serverContentDic[@"is_auto_close"] boolValue];
        }

        if (bidId) {
            // Bidding 场景
            AlxTopOnBiddingRequest *biddingRequest = (AlxTopOnBiddingRequest *)[[AlxTopOnTool shared] getRequestItemWithUnitID:unitId];
            if (biddingRequest) {
                self.splashAd = (AlxSplashAd *)biddingRequest.customObject;
                if (bottomView) {
                    self.splashAd.customBottomView = bottomView;
                }
                self.splashAd.autoCloseOnFinish = autoClose;

                if (self.splashAd) {
                    NSLog(@"%@: loadAD: bid ad loaded, notify success", TAG);
                    NSMutableDictionary *adExtra = [NSMutableDictionary dictionary];
                    adExtra[kATAdAssetsCustomObjectKey] = self.splashAd;
                    [self notifySplashLoaded:adExtra];
                } else {
                    NSLog(@"%@: loadAD: bid ad object is empty", TAG);
                    NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid ad object is empty"}];
                    [self notifyLoadFailed:error];
                }
            } else {
                NSLog(@"%@: loadAD: bid request not found in cache", TAG);
                NSError *error = [NSError errorWithDomain:@"AlxTopOnAdapter" code:-100 userInfo:@{NSLocalizedDescriptionKey: @"Bid request not found"}];
                [self notifyLoadFailed:error];
            }
            [[AlxTopOnTool shared] removeRequestItemWithUnitID:unitId];
        } else {
            // 普通加载场景
            self.splashAd = [[AlxSplashAd alloc] init];
            self.splashAd.delegate = [self getSplashDelegate];
            self.splashDelegate.splashAd = self.splashAd;
            self.splashAd.customBottomView = bottomView;
            self.splashAd.autoCloseOnFinish = autoClose;

            NSLog(@"%@: start loading splash ad with unitId: %@", TAG, unitId);
            AlxAdRequest *req = [[[AlxAdRequest alloc] init] withUserExt:@{ @"bid_floor": @"1.68" }];
            [self.splashAd loadAdWithAdUnitId:unitId request:req];
        }
    });
}

#pragma mark - Helper Notifications

- (void)notifySplashLoaded:(NSDictionary *)adExtra {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnSplashAdLoadedExtra:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:adExtra];
#pragma clang diagnostic pop
        }
    }
}

- (void)notifyLoadFailed:(NSError *)error {
    if (self.adStatusBridge) {
        SEL selector = NSSelectorFromString(@"atOnAdLoadFailed:adExtra:");
        if ([self.adStatusBridge respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.adStatusBridge performSelector:selector withObject:error withObject:@{}];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - C2S Header Bidding

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

    AlxTopOnSplashEvent *customEvent = [[AlxTopOnSplashEvent alloc] initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;

    AlxTopOnBiddingRequest *request = [[AlxTopOnBiddingRequest alloc]
                                       initWithUnitGroup:unitGroupModel
                                       customEvent:customEvent
                                       unitID:info[[AlxTopOnBaseManager unitID]]
                                       placementID:placementModel.placementID
                                       extraInfo:info
                                       adType:ATAdFormatSplash
                                       bidCompletion:completion];

    [[AlxTopOnBiddingRequestManager shared] startWithRequest:request];
}

#pragma mark - Ad Ready Check

- (BOOL)adReadySplashWithInfo:(NSDictionary *)info {
    NSLog(@"%@: adReadySplashWithInfo", TAG);
    if (self.splashAd && [self.splashAd isReady]) {
        NSLog(@"%@: adReady = YES", TAG);
        return YES;
    }
    NSLog(@"%@: adReady = NO", TAG);
    return NO;
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary *)info {
    if ([customObject isKindOfClass:[AlxSplashAd class]]) {
        return [(AlxSplashAd *)customObject isReady];
    }
    return NO;
}

#pragma mark - Show Splash Ad

- (void)showSplashAdInWindow:(UIWindow *)window inViewController:(UIViewController *)inViewController parameter:(NSDictionary *)parameter {
    NSLog(@"%@: showSplashAdInWindow:inViewController:parameter:", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.splashAd) {
            NSLog(@"%@: splashAd is nil", TAG);
            return;
        }

        if (parameter) {
            if ([parameter[kATSplashExtraNewBottomViewKey] isKindOfClass:[UIView class]]) {
                self.splashAd.customBottomView = parameter[kATSplashExtraNewBottomViewKey];
            } else if ([parameter[kATSplashExtraContainerViewKey] isKindOfClass:[UIView class]]) {
                self.splashAd.customBottomView = parameter[kATSplashExtraContainerViewKey];
            }

            if (parameter[@"autoCloseOnFinish"]) {
                self.splashAd.autoCloseOnFinish = [parameter[@"autoCloseOnFinish"] boolValue];
            } else if (parameter[@"auto_close"]) {
                self.splashAd.autoCloseOnFinish = [parameter[@"auto_close"] boolValue];
            } else if (parameter[@"is_auto_close"]) {
                self.splashAd.autoCloseOnFinish = [parameter[@"is_auto_close"] boolValue];
            }
        }

        [self.splashAd showAdInWindow:window];
    });
}

@end
