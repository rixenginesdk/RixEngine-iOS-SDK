#import "AdmobRewardVideoVC.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdConfig.h"

@interface AdmobRewardVideoVC () <GADFullScreenContentDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong, nullable) GADRewardedAd *rewardAd;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AdmobRewardVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Admob-rewardVideo:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"admob_rewardVideo", @"");

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
    if (self.rewardAd) {
        [self.rewardAd presentFromRootViewController:self userDidEarnRewardHandler:^{
            GADAdReward *reward = self.rewardAd.adReward;
            NSLog(@"Reward received with currency %@, amount %@", reward.type, reward.amount);
        }];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (void)loadAd {
    GADRequest *request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:[AdConfig Admob_Reward_Video_Ad_Id]
                            request:request
                  completionHandler:^(GADRewardedAd * _Nullable ad, NSError * _Nullable error) {
        if (error) {
            NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
            NSLog(@"%@ load: error: %@", self.TAG, msg);
            [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
            return;
        }
        NSLog(@"%@ load: success", self.TAG);
        [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
        self.rewardAd = ad;
        self.rewardAd.fullScreenContentDelegate = self;
    }];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - GADFullScreenContentDelegate

- (void)ad:(id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ ad: error:%@", self.TAG, msg);
}

- (void)adWillPresentFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%@ adWillPresentFullScreenContent", self.TAG);
}

- (void)adDidDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%@ adDidDismissFullScreenContent", self.TAG);
}

- (void)adDidRecordImpression:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%@ adDidRecordImpression", self.TAG);
}

- (void)adDidRecordClick:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%@ adDidRecordClick", self.TAG);
}

- (void)adWillDismissFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    NSLog(@"%@ adWillDismissFullScreenContent", self.TAG);
}

@end
