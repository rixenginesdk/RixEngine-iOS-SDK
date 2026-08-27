#import "LevelPlayInterstitialVC.h"
#import <IronSource/IronSource.h>
#import "AdConfig.h"

static NSString *const TAG = @"LevelPlay-interstitial:";

@interface LevelPlayInterstitialVC () <LPMInterstitialAdDelegate>
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) LPMInterstitialAd *interstitialAd;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LevelPlayInterstitialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"levelPlay_interstitial", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    UIButton *bnShow = [self createButtonWithTitle:NSLocalizedString(@"show_ad", @"") action:@selector(buttonShow)];
    [self.view addSubview:bnShow];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],

        [bnShow.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],
        [bnShow.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnShow.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnShow.heightAnchor constraintEqualToConstant:50],

        [self.label.topAnchor constraintEqualToAnchor:bnShow.bottomAnchor constant:20],
        [self.label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)buttonLoad {
    NSLog(@"%@ buttonLoad", TAG);
    if (self.isLoading) return;
    [self updateUI:YES message:NSLocalizedString(@"loading", @"")];
    [self loadAd];
}

- (void)buttonShow {
    if (self.interstitialAd && [self.interstitialAd isAdReady]) {
        [self.interstitialAd showAdWithViewController:self placementName:nil];
    } else {
        NSLog(@"%@ Ad wasn't ready", TAG);
    }
}

- (void)loadAd {
    self.interstitialAd = [[LPMInterstitialAd alloc] initWithAdUnitId:AdConfig.LevelPlay_Interstitial_Ad_Id];
    [self.interstitialAd setDelegate:self];
    [self.interstitialAd loadAd];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - LPMInterstitialAdDelegate

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didLoadAd", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
    });
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ didFailToLoadAd: %@", TAG, msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
    });
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didDisplayAd", TAG);
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@ didFailToDisplayAd: %@", TAG, error.localizedDescription);
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didClickAd", TAG);
}

- (void)didCloseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didCloseAd", TAG);
}

@end
