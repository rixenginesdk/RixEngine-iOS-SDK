//
//  AlxTopOnBiddingRequestManager.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>

@class AlxTopOnBiddingRequest;

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnBiddingRequestManager : NSObject

+ (instancetype)shared;

- (void)startWithRequest:(AlxTopOnBiddingRequest *)request;

+ (void)disposeLoadSuccessWithPrice:(double)price unitID:(nullable NSString *)unitID;
+ (void)disposeLoadFailWithError:(NSError *)error unitID:(nullable NSString *)unitID;

@end

NS_ASSUME_NONNULL_END
