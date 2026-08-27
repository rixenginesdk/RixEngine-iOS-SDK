#import "AlxRewardVideoVC.h"
#import <AlxAds/AlxAds-Swift.h>
#import "AdConfig.h"

@interface AlxRewardVideoVC () <AlxRewardVideoAdDelegate>

@property (nonatomic, strong) AlxRewardVideoAd *rewardAd;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AlxRewardVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Alx-rewardVideo:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"rewardVideo_ad", @"");

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
    self.rewardAd = [[AlxRewardVideoAd alloc] init];
}

- (void)loadAd {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    self.label.text = NSLocalizedString(@"loading", @"");

    self.rewardAd.delegate = self;
    [self.rewardAd loadAdWithAdUnitId:[AdConfig Alx_Reward_Video_Ad_Id]];
}

- (void)showAd {
    if ([self.rewardAd isReady]) {
        [self.rewardAd showAdWithPresent:self];
    }
}

#pragma mark - AlxRewardVideoAdDelegate

- (void)rewardVideoAdLoad:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdLoad", self.TAG);
    self.isLoading = NO;
    self.label.text = NSLocalizedString(@"load_success", @"");
}

- (void)rewardVideoAdFailToLoad:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ rewardVideoAdFailToLoad: %@", self.TAG, msg);
    self.isLoading = NO;
    self.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg];
}

- (void)rewardVideoAdImpression:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdImpression", self.TAG);
}

- (void)rewardVideoAdClick:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdClick", self.TAG);
}

- (void)rewardVideoAdClose:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdClose", self.TAG);
}

- (void)rewardVideoAdPlayStart:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdPlayStart", self.TAG);
}

- (void)rewardVideoAdPlayEnd:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdPlayEnd", self.TAG);
}

- (void)rewardVideoAdReward:(AlxRewardVideoAd *)ad {
    NSLog(@"%@ rewardVideoAdReward", self.TAG);
}

- (void)rewardVideoAdPlayFail:(AlxRewardVideoAd *)ad didFailWithError:(NSError *)error {
    NSLog(@"%@ rewardVideoAdPlayFail %@", self.TAG, error.localizedDescription);
}

@end
