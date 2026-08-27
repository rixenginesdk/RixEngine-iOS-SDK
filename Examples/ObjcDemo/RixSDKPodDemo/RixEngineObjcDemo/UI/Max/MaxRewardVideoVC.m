#import "MaxRewardVideoVC.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AdConfig.h"

@interface MaxRewardVideoVC () <MARewardedAdDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong, nullable) MARewardedAd *rewardAd;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation MaxRewardVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Max-rewardVideo:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"max_rewardVideo", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    UIButton *bnShow = [self createButtonWithTitle:NSLocalizedString(@"show_ad", @"") action:@selector(buttonShow)];
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
}

- (void)buttonLoad {
    NSLog(@"bnLoad");
    if (self.isLoading) {
        return;
    }
    [self updateUI:YES message:NSLocalizedString(@"loading", @"")];
    [self loadAd];
}

- (void)buttonShow {
    if (self.rewardAd && [self.rewardAd isReady]) {
        [self.rewardAd showAd];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (void)loadAd {
    self.rewardAd = [MARewardedAd sharedWithAdUnitIdentifier:[AdConfig Max_Reward_Video_Ad_Id]];
    self.rewardAd.delegate = self;
    [self.rewardAd loadAd];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - MARewardedAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    NSLog(@"%@ didLoad", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.description];
    NSLog(@"%@ didFailToLoadAd: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

- (void)didDisplayAd:(MAAd *)ad {
    NSLog(@"%@ didDisplay", self.TAG);
}

- (void)didHideAd:(MAAd *)ad {
    NSLog(@"%@ didHide", self.TAG);
}

- (void)didClickAd:(MAAd *)ad {
    NSLog(@"%@ didClick", self.TAG);
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    NSLog(@"%@ didFail:%ld %@", self.TAG, (long)error.code, error.description);
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    NSLog(@"%@ didRewardUser", self.TAG);
}

@end
