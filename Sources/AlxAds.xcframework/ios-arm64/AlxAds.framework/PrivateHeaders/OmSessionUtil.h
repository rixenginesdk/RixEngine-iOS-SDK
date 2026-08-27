//
//  OmSessionUtil.h
//  AlxAds
//
//  Created by liu weile on 2025/11/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


#import <AlxAds/OmAdType.h>


@class AlxOmidBean;


NS_ASSUME_NONNULL_BEGIN

@interface OmSessionUtil : NSObject

/**
 创建 OMID 广告会话
 @param adType 广告类型（需与 Swift 的 OmAdType 对应）
 @param adView 广告视图
 @param omidJSContext WKWebView 上下文（用于 HTML 广告）
 @param bean OMID 配置信息
 @return OMID 广告会话实例。返回一个 OMIDAlgorixcoAdSession 实例（实际类型为 OMIDAlgorixcoAdSession*，但此处隐藏实现）
 */
+ (nullable id)createAdSessionWithAdType:(OmAdType)adType
                                  adView:(nullable UIView *)adView
                           omidJSContext:(nullable WKWebView *)omidJSContext
                                    bean:(nullable AlxOmidBean *)bean;

/**
 向 HTML 中注入 OMID JS 脚本（用于展示类广告）
 @param html 原始 HTML 内容
 @return 注入脚本后的 HTML
 */
+ (NSString *)addOmJSIntoHtml:(NSString *)html
NS_SWIFT_NAME(addOmJSIntoHtml(html:));

/**
 向 HTML 广告注入 OMID 验证脚本（针对 Banner/插屏广告）
 @param html 原始 HTML 内容
 @param omid OMID 配置信息
 @return 注入脚本后的 HTML
 */
+ (NSString *)injectDisplayHtmlScriptWithHtml:(NSString *)html
                                                 omid:(nullable AlxOmidBean *)omid
NS_SWIFT_NAME(injectDisplayHtmlScript(html:omid:));

@end

NS_ASSUME_NONNULL_END
