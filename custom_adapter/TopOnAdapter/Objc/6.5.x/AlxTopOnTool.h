//
//  AlxTopOnTool.h
//  AlxAdsOCDemo
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlxTopOnTool : NSObject

+ (instancetype)shared;

- (void)saveRequestItem:(id)request withUnitId:(NSString *)unitID;
- (nullable id)getRequestItemWithUnitID:(NSString *)unitID;
- (void)removeRequestItemWithUnitID:(NSString *)unitID;

@end

NS_ASSUME_NONNULL_END
