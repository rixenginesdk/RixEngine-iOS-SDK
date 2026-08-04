#import "AlxMainVC.h"
#import "AlxBannerVC.h"
#import "AlxBannerXibVC.h"
#import "AlxRewardVideoVC.h"
#import "AlxInterstitialVC.h"
#import "AlxInterstitialBannerVC.h"
#import "AlxNativeVC.h"

@implementation AlxMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Alx_ad", @"");
}

- (MenuAppearance)menuAppearance {
    return MenuAppearanceCard;
}

- (NSArray<MenuItem *> *)menuItems {
    return @[
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad", @"") makeVC:^UIViewController *{ return [[AlxBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad_xib", @"") makeVC:^UIViewController *{ return [[AlxBannerXibVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"rewardVideo_ad", @"") makeVC:^UIViewController *{ return [[AlxRewardVideoVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_video_ad", @"") makeVC:^UIViewController *{ return [[AlxInterstitialVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_banner_ad", @"") makeVC:^UIViewController *{ return [[AlxInterstitialBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"native_ad", @"") makeVC:^UIViewController *{ return [[AlxNativeVC alloc] init]; }]
    ];
}

- (NSString *)menuSubtitleAtIndex:(NSInteger)index {
    NSArray *subtitles = @[
        @"Flexible formats at the top, middle or bottom of your app.",
        @"Load banner ads using Interface Builder (Xib).",
        @"Users engage with a video ad in exchange for in-app rewards.",
        @"Full-screen video ads at natural breaks or transition points.",
        @"Full-screen banner ads at natural breaks or transition points.",
        @"Ads that match the look and feel of your app."
    ];
    if (index >= 0 && index < subtitles.count) {
        return subtitles[index];
    }
    return nil;
}

@end
