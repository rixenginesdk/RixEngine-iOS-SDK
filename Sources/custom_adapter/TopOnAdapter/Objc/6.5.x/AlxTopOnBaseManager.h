//
//  AlxTopOnBaseManager.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnBaseManager : NSObject

@property (class, nonatomic, assign) BOOL isInitialized;
+ (NSString *)unitID;

+ (nullable NSString *)initSDKWithServerInfo:(NSDictionary *)serverInfo;
+ (void)sdkInfo;
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
