//
//  AlxTopOnCustomBaseAdapter.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBaseAdapter.h"

@interface AlxTopOnBaseAdapter ()

@property (nonatomic, strong) NSUUID *bidRequestID;
@property (nonatomic, strong, nullable) id<AlxAdDelegate> biddingAd;
@property (nonatomic, strong, nullable) NSNumber *pendingBidWin;
@property (nonatomic, copy) NSDictionary<NSString *, id> *pendingBidExtra;
@property (nonatomic, assign) BOOL didReceiveResult;
@property (nonatomic, assign) NSInteger currentNetworkFirmID;

@end

@implementation AlxTopOnBaseAdapter

#pragma mark - 适配器初始化类名定义 / Adapter Init Class Name Definition

- (Class)initializeClassName {
    // 返回创建的初始化适配器类
    // Returns the initialization adapter class to be used.
    return [AlxTopOnInitAdapter class];
}

- (AlxTopOnBindBiddingAdBlock)beginBiddingRequestWithArgument:(ATAdMediationArgument *)argument {
    NSUUID *requestID = [NSUUID UUID];
    self.bidRequestID = requestID;
    self.biddingAd = nil;
    self.pendingBidWin = nil;
    self.pendingBidExtra = @{};
    self.didReceiveResult = NO;
    self.currentNetworkFirmID = [AlxTopOnBaseAdapter extractNetworkFirmIDFromArgument:argument];

    __weak typeof(self) weakSelf = self;
    return ^BOOL(id<AlxAdDelegate> ad) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return NO;
        }
        if (![strongSelf.bidRequestID isEqual:requestID]) {
            return NO;
        }
        strongSelf.biddingAd = ad;
        [strongSelf reportPendingBidResult];
        return YES;
    };
}

- (AlxAdRequest *)buildAdRequestWithArgument:(ATAdMediationArgument *)argument {
    AlxAdRequest *request = [[AlxAdRequest alloc] init];
    if (!argument) {
        return request;
    }
    NSArray<NSString *> *floorKeys = @[AlxAdConstantKey.BIDDING_FLOOR, @"p_bidfloor", @"bidfloor"];
    for (NSString *key in floorKeys) {
        id rawValue = argument.localInfoDic[key] ?: argument.serverContentDic[key];
        if (!rawValue) {
            continue;
        }
        NSString *floorStr = [[NSString stringWithFormat:@"%@", rawValue]
                              stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        double floorPrice = [floorStr doubleValue];
        if (isfinite(floorPrice) && floorPrice > 0) {
            return [request withUserExt:@{AlxAdConstantKey.BIDDING_FLOOR: floorStr}];
        }
    }
    return request;
}

- (void)didReceiveBidResult:(ATBidWinLossResult *)result {
    if (self.didReceiveResult) {
        return;
    }
    BOOL isWin = NO;
    if (result.bidResultType == ATBidWinLossResultTypeWin) {
        isWin = YES;
    } else if (result.bidResultType == ATBidWinLossResultTypeLoss) {
        isWin = NO;
    } else {
        return;
    }
    self.didReceiveResult = YES;
    NSNumber *fallbackWinPrice = nil;
    if (self.biddingAd) {
        double adPrice = [self.biddingAd getPrice];
        if (isfinite(adPrice) && adPrice > 0) {
            fallbackWinPrice = @(adPrice);
        }
    }
    NSDictionary<NSString *, id> *extra = [AlxTopOnBaseAdapter bidExtraFromResult:result
                                                             currentNetworkFirmID:self.currentNetworkFirmID
                                                                 fallbackWinPrice:fallbackWinPrice];
    id winPriceLog = extra[AlxAdConstantKey.BIDDING_WIN_PRICE] ?: (result.winPrice ?: @"");
    if (isWin) {
        id secondPriceLog = extra[AlxAdConstantKey.BIDDING_SECOND_PRICE] ?: (result.secondPrice ?: @"");
        NSLog(@"notifyBidWin: winPrice=%@;secondPrice=%@", winPriceLog, secondPriceLog);
        NSLog(@"notifyBidDisplay: isWin=true;displayPrice=%@", winPriceLog);
    } else {
        id lossReason = extra[AlxAdConstantKey.BIDDING_LOSS_REASON] ?: @"";
        id adnId = extra[AlxAdConstantKey.BIDDING_ADN_ID] ?: @"";
        id lossPriceLog = @"";
        id bidInfoObj = result.userInfoDic[kATWinLossAdTypeKeyBidInfo];
        if ([bidInfoObj isKindOfClass:[ATBidInfo class]]) {
            NSNumber *parsedBidPrice = [AlxTopOnBaseAdapter parsePrice:((ATBidInfo *)bidInfoObj).price];
            if (parsedBidPrice && [parsedBidPrice doubleValue] > 0) {
                lossPriceLog = parsedBidPrice;
            }
        }
        if ([lossPriceLog isEqual:@""] && self.biddingAd) {
            double adPrice = [self.biddingAd getPrice];
            if (isfinite(adPrice) && adPrice >= 0) {
                lossPriceLog = @(adPrice);
            }
        }
        NSLog(@"notifyBidLoss: lossReason=%@; winPrice=%@; adnId=%@",
              lossReason, winPriceLog, adnId);
        NSLog(@"notifyBidLoss: lossPrice=%@", lossPriceLog);
    }
    self.pendingBidExtra = extra;
    self.pendingBidWin = @(isWin);
    [self reportPendingBidResult];
}

- (void)reportPendingBidResult {
    if (!self.pendingBidWin || !self.biddingAd) {
        return;
    }
    BOOL isWin = [self.pendingBidWin boolValue];
    NSMutableDictionary<NSString *, id> *extra = [NSMutableDictionary dictionaryWithDictionary:(self.pendingBidExtra ?: @{})];
    self.pendingBidWin = nil;
    self.pendingBidExtra = @{};
    if (isWin) {
        if (!extra[AlxAdConstantKey.BIDDING_WIN_PRICE]) {
            double adPrice = [self.biddingAd getPrice];
            if (isfinite(adPrice) && adPrice > 0) {
                extra[AlxAdConstantKey.BIDDING_WIN_PRICE] = @(adPrice);
                if (!extra[AlxAdConstantKey.BIDDING_SECOND_PRICE]) {
                    extra[AlxAdConstantKey.BIDDING_SECOND_PRICE] = @(adPrice);
                }
            }
        }
        [self.biddingAd reportBiddingWinWithExtra:extra];
        [self.biddingAd reportBiddingImpressionWithExtra:extra];
    } else {
        [self.biddingAd reportBiddingLossWithExtra:extra];
    }
}

+ (NSDictionary<NSString *, id> *)bidExtraFromResult:(ATBidWinLossResult *)result
                                currentNetworkFirmID:(NSInteger)currentNetworkFirmID
                                    fallbackWinPrice:(nullable NSNumber *)fallbackWinPrice {
    NSMutableDictionary<NSString *, id> *extra = [NSMutableDictionary dictionary];
    NSNumber *winPrice = [self parsePrice:result.winPrice];
    if (!winPrice) {
        id rawUserWinPrice = result.userInfoDic[kATWinLossAdTypekeyWinPrice];
        if (rawUserWinPrice) {
            winPrice = [self parsePrice:[NSString stringWithFormat:@"%@", rawUserWinPrice]];
        }
    }
    if (!winPrice && result.bidResultType == ATBidWinLossResultTypeWin) {
        winPrice = fallbackWinPrice;
    }
    if (winPrice) {
        extra[AlxAdConstantKey.BIDDING_WIN_PRICE] = winPrice;
    }
    if (result.bidResultType == ATBidWinLossResultTypeWin) {
        NSNumber *secondPrice = [self parsePrice:result.secondPrice];
        if (secondPrice && [secondPrice doubleValue] > 0) {
            extra[AlxAdConstantKey.BIDDING_SECOND_PRICE] = secondPrice;
        } else if (winPrice) {
            // 若拿不到有效二价（无其他竞争出价对手或返回 0），则二价取竞胜价本身（winPrice）
            extra[AlxAdConstantKey.BIDDING_SECOND_PRICE] = winPrice;
        }
    } else if (result.bidResultType == ATBidWinLossResultTypeLoss) {
        NSInteger reason = AlxBiddingLossReason.OTHER;
        switch (result.lossReasonType) {
            case ATBiddingLossWithLowPriceInNormal:
                reason = AlxBiddingLossReason.LOW_PRICE_IN_NORMAL;
                break;
            case ATBiddingLossWithLowPriceInHB:
                reason = AlxBiddingLossReason.LOW_PRICE_IN_HB;
                break;
            case ATBiddingLossWithBiddingTimeOut:
                reason = AlxBiddingLossReason.TIMEOUT;
                break;
            case ATBiddingLossWithExpire:
                reason = AlxBiddingLossReason.EXPIRE;
                break;
            case ATBiddingLossWithFloorFilter:
                reason = AlxBiddingLossReason.LOW_FLOOR;
                break;
            default:
                reason = AlxBiddingLossReason.OTHER;
                break;
        }
        extra[AlxAdConstantKey.BIDDING_LOSS_REASON] = @(reason);

        NSNumber *adnId = [self resolveBiddingAdnIdFromResult:result
                                         currentNetworkFirmID:currentNetworkFirmID];
        if (adnId) {
            extra[AlxAdConstantKey.BIDDING_ADN_ID] = adnId;
        }
    }
    return [extra copy];
}

+ (nullable NSNumber *)parsePrice:(nullable NSString *)raw {
    if (![raw isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSString *trimmed = [raw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimmed.length == 0) {
        return nil;
    }
    NSScanner *scanner = [NSScanner scannerWithString:trimmed];
    double value = 0;
    if ([scanner scanDouble:&value] && [scanner isAtEnd] && isfinite(value) && value >= 0) {
        return @(value);
    }
    return nil;
}

+ (NSInteger)extractNetworkFirmIDFromArgument:(nullable ATAdMediationArgument *)argument {
    if (!argument) {
        return 0;
    }
    id unitGroup = argument.serverContentDic[kATAdapterCustomInfoUnitGroupModelKey];
    if ([unitGroup respondsToSelector:NSSelectorFromString(@"networkFirmID")]) {
        id value = [unitGroup valueForKey:@"networkFirmID"];
        if ([value respondsToSelector:@selector(integerValue)]) {
            return [value integerValue];
        }
    }
    id rawFirmId = argument.serverContentDic[@"nw_firm_id"] ?: argument.serverContentDic[@"network_firm_id"];
    if ([rawFirmId respondsToSelector:@selector(integerValue)]) {
        return [rawFirmId integerValue];
    }
    return 0;
}

+ (nullable NSNumber *)resolveBiddingAdnIdFromResult:(ATBidWinLossResult *)result
                                currentNetworkFirmID:(NSInteger)currentNetworkFirmID {
    NSInteger winnerFirmID = 0;
    id rawWinner = result.userInfoDic[kATWinLossAuthNetworkKey] ?: result.userInfoDic[@"network_firm_id"];
    if ([rawWinner respondsToSelector:@selector(integerValue)]) {
        winnerFirmID = [rawWinner integerValue];
    }
    if (winnerFirmID > 0) {
        if (currentNetworkFirmID > 0 && winnerFirmID == currentNetworkFirmID) {
            NSInteger samePlatformAdnId = (result.lossReasonType == ATBiddingLossWithLowPriceInNormal)
                ? AlxBiddingAdnID.SAME_TO_NORMAL
                : AlxBiddingAdnID.SAME_TO_BIDDING;
            return @(samePlatformAdnId);
        }
        if (winnerFirmID == 35 || winnerFirmID == 42 || winnerFirmID == 66 || winnerFirmID == 67) {
            return @(AlxBiddingAdnID.OWN);
        }
        return @(AlxBiddingAdnID.OTHER);
    }
    if (result.lossReasonType == ATBiddingLossWithLowPriceInNormal ||
        result.lossReasonType == ATBiddingLossWithLowPriceInHB) {
        return @(AlxBiddingAdnID.OTHER);
    }
    return nil;
}

@end
