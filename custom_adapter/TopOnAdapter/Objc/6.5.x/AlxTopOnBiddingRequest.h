//
//  AlxTopOnBiddingRequest.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnBiddingRequest : NSObject

@property (nonatomic, strong) ATUnitGroupModel *unitGroup;
@property (nonatomic, strong) ATAdCustomEvent *customEvent;
@property (nonatomic, copy, nullable) NSString *unitID;
@property (nonatomic, copy, nullable) NSString *placementID;
@property (nonatomic, strong) NSDictionary *extraInfo;
@property (nonatomic, assign) ATAdFormat adType;
@property (nonatomic, copy, nullable) void (^bidCompletion)(ATBidInfo * _Nullable, NSError * _Nullable);
@property (nonatomic, strong, nullable) id customObject;

- (instancetype)initWithUnitGroup:(ATUnitGroupModel *)unitGroup
                      customEvent:(ATAdCustomEvent *)customEvent
                           unitID:(nullable NSString *)unitID
                      placementID:(nullable NSString *)placementID
                        extraInfo:(NSDictionary *)extraInfo
                           adType:(ATAdFormat)adType
                    bidCompletion:(nullable void (^)(ATBidInfo * _Nullable, NSError * _Nullable))bidCompletion;

@end

NS_ASSUME_NONNULL_END
