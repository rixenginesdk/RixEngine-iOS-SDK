#import "LevelPlayMainVC.h"
#import "LevelPlayBannerVC.h"
#import "LevelPlayRewardVideoVC.h"
#import "LevelPlayInterstitialVC.h"
#import <IronSource/IronSource.h>
#import "AdConfig.h"

@implementation LevelPlayMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"levelPlay_ad", @"");
}

- (MenuAppearance)menuAppearance {
    return MenuAppearanceCard;
}

- (NSArray<MenuItem *> *)menuItems {
    return @[
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"banner_ad", @"") makeVC:^UIViewController *{ return [[LevelPlayBannerVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"rewardVideo_ad", @"") makeVC:^UIViewController *{ return [[LevelPlayRewardVideoVC alloc] init]; }],
        [[MenuItem alloc] initWithTitle:NSLocalizedString(@"interstitial_ad", @"") makeVC:^UIViewController *{ return [[LevelPlayInterstitialVC alloc] init]; }]
    ];
}

- (NSString *)menuSubtitleAtIndex:(NSInteger)index {
    NSArray *subtitles = @[
        @"Flexible formats at the top, middle or bottom of your app.",
        @"Users engage with a video ad in exchange for in-app rewards.",
        @"Full-screen ads at natural breaks or transition points."
    ];
    if (index >= 0 && index < subtitles.count) {
        return subtitles[index];
    }
    return nil;
}

- (void)setupSDK {
    LPMInitRequest *initRequest = [[[LPMInitRequestBuilder alloc] initWithAppKey: AdConfig.LevelPlay_App_Key] build];
    [LevelPlay initWithRequest:initRequest completion:^(LPMConfiguration * _Nullable config, NSError * _Nullable error) {
        if (error) {
            NSLog(@"LevelPlayMainVC: initSDK failed: %@", error.localizedDescription);
        } else {
            NSLog(@"LevelPlayMainVC: initSDK success");
        }
    }];
}

@end
