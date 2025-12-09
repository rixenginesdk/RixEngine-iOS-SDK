//
//  OmAdType.h
//  AlxAds
//
//  Created by liu weile on 2025/11/25.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, OmAdType) {
    // html display banner rendered by WKWebView
    OmAdTypeHtmlDisplay = 1,
    
    // html video asset rendered by WKWebView
    OmAdTypeHtmlVideo = 2,
    
    // image rendered by UIImageView
    OmAdTypeNativeDisplay = 3,
    
    // video asset rendered by AVPlayer
    OmAdTypeNativeVideo = 4,
    
    // Audio ad played with AVPlayer
    OmAdTypeNativeAudio = 5
};

