#import "MaxMainVC.h"
#import "MaxBannerVC.h"
#import "MaxRewardVideoVC.h"
#import "MaxInterstitialVC.h"
#import "MaxNativeVC.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AdConfig.h"

@implementation MaxMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"max_ad", @"");
}

- (MenuAppearance)menuAppearance {
    return MenuAppearanceCard;
}

- (NSArray<MenuItem *> *)menuItems {
    return @[
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad", @"") makeVC:^UIViewController *{ return [[MaxBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"rewardVideo_ad", @"") makeVC:^UIViewController *{ return [[MaxRewardVideoVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_ad", @"") makeVC:^UIViewController *{ return [[MaxInterstitialVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"native_ad", @"") makeVC:^UIViewController *{ return [[MaxNativeVC alloc] init]; }]
    ];
}

- (NSString *)menuSubtitleAtIndex:(NSInteger)index {
    NSArray *subtitles = @[
        @"Flexible formats at the top, middle or bottom of your app.",
        @"Users engage with a video ad in exchange for in-app rewards.",
        @"Full-screen ads at natural breaks or transition points.",
        @"Ads that match the look and feel of your app."
    ];
    if (index >= 0 && index < subtitles.count) {
        return subtitles[index];
    }
    return nil;
}

- (void)setupSDK {
    ALSdkInitializationConfiguration *initConfig = [ALSdkInitializationConfiguration configurationWithSdkKey:[AdConfig Max_App_Key] builderBlock:^(ALSdkInitializationConfigurationBuilder *builder) {
        builder.mediationProvider = ALMediationProviderMAX;
    }];

    ALSdkSettings *settings = [ALSdk shared].settings;
    [settings setExtraParameterForKey:@"uid2_token" value:@"liuweileliuweile"];

    // Note: ALPrivacySettings might be deprecated or moved in newer SDKs, 
    // but following the Swift version's logic.
    // [ALPrivacySettings setDoNotSell:NO];
    // [ALPrivacySettings setHasUserConsent:YES];

    [[ALSdk shared] initializeWithConfiguration:initConfig completionHandler:^(ALSdkConfiguration *config) {
        // Initialization complete
    }];
}

@end
