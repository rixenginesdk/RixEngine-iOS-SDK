#import "AlxInterstitialBannerVC.h"
#import <AlxAds/AlxAds-Swift.h>
#import "AdConfig.h"

@interface AlxInterstitialBannerVC () <AlxInterstitialAdDelegate>

@property (nonatomic, strong) AlxInterstitialAd *interstitialAd;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AlxInterstitialBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Alx-interstitial:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"interstitial_banner_ad", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(loadAd)];
    [self.view addSubview:bnLoad];

    UIButton *bnShow = [self createButtonWithTitle:NSLocalizedString(@"show_ad", @"") action:@selector(showAd)];
    [self.view addSubview:bnShow];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],

        [bnShow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnShow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnShow.heightAnchor constraintEqualToConstant:50],
        [bnShow.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],

        [self.label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50],
        [self.label.topAnchor constraintEqualToAnchor:bnShow.bottomAnchor constant:20],
    ]];

    [self createAd];
}

- (void)createAd {
    self.interstitialAd = [[AlxInterstitialAd alloc] init];
}

- (void)loadAd {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    self.label.text = NSLocalizedString(@"loading", @"");

    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAdWithAdUnitId:[AdConfig Alx_Interstitial_Banner_Ad_Id]];
}

- (void)showAd {
    if ([self.interstitialAd isReady]) {
        [self.interstitialAd showAdWithPresent:self];
    }
}

#pragma mark - AlxInterstitialAdDelegate

- (void)interstitialAdLoad:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdLoaded", self.TAG);
    self.isLoading = NO;
    self.label.text = NSLocalizedString(@"load_success", @"");
}

- (void)interstitialAdFailToLoad:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ interstitialAdFailedToLoad: %@", self.TAG, msg);
    self.isLoading = NO;
    self.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg];
}

- (void)interstitialAdImpression:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdImpression", self.TAG);
}

- (void)interstitialAdClick:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdClick", self.TAG);
}

- (void)interstitialAdClose:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdClose", self.TAG);
}

- (void)interstitialAdRenderFail:(AlxInterstitialAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@ interstitialAdRenderFailed: %@", self.TAG, error.localizedDescription);
}

- (void)interstitialAdVideoStart:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdVideoStart", self.TAG);
}

- (void)interstitialAdVideoEnd:(AlxInterstitialAd *)ad {
    NSLog(@"%@ interstitialAdVideoEnd", self.TAG);
}

@end
