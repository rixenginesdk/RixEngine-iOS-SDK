#import "TopOnMainVC.h"
#import "TopOnBannerVC.h"
#import "TopOnRewardVideoVC.h"
#import "TopOnInterstitialVC.h"
#import "TopOnNativeVC.h"
#import "TopOnNativeSelfRenderVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdConfig.h"

@implementation TopOnMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"topOn_ad", @"");
}

- (MenuAppearance)menuAppearance {
    return MenuAppearanceCard;
}

- (NSArray<MenuItem *> *)menuItems {
    return @[
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad", @"") makeVC:^UIViewController *{ return [[TopOnBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"rewardVideo_ad", @"") makeVC:^UIViewController *{ return [[TopOnRewardVideoVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_ad", @"") makeVC:^UIViewController *{ return [[TopOnInterstitialVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"native_ad_template", @"") makeVC:^UIViewController *{ return [[TopOnNativeVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"native_ad_self_render", @"") makeVC:^UIViewController *{ return [[TopOnNativeSelfRenderVC alloc] init]; }]
    ];
}

- (NSString *)menuSubtitleAtIndex:(NSInteger)index {
    NSArray *subtitles = @[
        @"Flexible formats at the top, middle or bottom of your app.",
        @"Users engage with a video ad in exchange for in-app rewards.",
        @"Full-screen ads at natural breaks or transition points.",
        @"Native template rendering with prebuilt layouts.",
        @"Custom native rendering with full UI control."
    ];
    if (index >= 0 && index < subtitles.count) {
        return subtitles[index];
    }
    return nil;
}

- (void)setupSDK {
    [ATAPI setLogEnabled:YES];
    [ATAPI integrationChecking];

    [[ATAPI sharedInstance] startWithAppID:[AdConfig TopOn_App_Id] appKey:[AdConfig TopOn_App_Key] error: nil];
}

@end
