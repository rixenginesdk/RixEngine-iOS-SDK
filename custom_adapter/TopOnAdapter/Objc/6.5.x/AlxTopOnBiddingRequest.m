//
//  AlxTopOnBiddingRequest.m
//  AlxAdsOCDemo
//

#import "AlxTopOnBiddingRequest.h"

@implementation AlxTopOnBiddingRequest

- (instancetype)initWithUnitGroup:(ATUnitGroupModel *)unitGroup
                      customEvent:(ATAdCustomEvent *)customEvent
                           unitID:(NSString *)unitID
                      placementID:(NSString *)placementID
                        extraInfo:(NSDictionary *)extraInfo
                           adType:(ATAdFormat)adType
                    bidCompletion:(void (^)(ATBidInfo * _Nullable, NSError * _Nullable))bidCompletion {
    self = [super init];
    if (self) {
        _unitGroup = unitGroup;
        _customEvent = customEvent;
        _unitID = unitID;
        _placementID = placementID;
        _extraInfo = extraInfo;
        _adType = adType;
        _bidCompletion = bidCompletion;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"AlxTopOnBiddingRequest: dealloc");
}

@end
