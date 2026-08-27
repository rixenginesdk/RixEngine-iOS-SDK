#import "TopOnRewardVideoVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdConfig.h"

@interface TopOnRewardVideoVC () <ATAdLoadingDelegate, ATRewardedVideoDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation TopOnRewardVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"TopOn-rewardVideo:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"topOn_rewardVideo", @"");

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

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

- (void)buttonShow {
    if ([[ATAdManager sharedManager] rewardedVideoReadyForPlacementID:[AdConfig TopOn_Reward_Video_Ad_Id]]) {
        [[ATAdManager sharedManager] showRewardedVideoWithPlacementID:[AdConfig TopOn_Reward_Video_Ad_Id] inViewController:self delegate:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

- (void)loadAd {
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    extra[kATAdLoadingExtraMediaExtraKey] = @"media_val_RewardedVC";
    [[ATAdManager sharedManager] loadADWithPlacementID:[AdConfig TopOn_Reward_Video_Ad_Id] extra:extra delegate:self];
}

#pragma mark - ATAdLoadingDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"%@ didFinishLoadingAD", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ didFailToLoadAD: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

#pragma mark - ATRewardedVideoDelegate

- (void)rewardedVideoDidStartPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidStartPlaying", self.TAG);
}

- (void)rewardedVideoDidEndPlayingForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidEndPlaying", self.TAG);
}

- (void)rewardedVideoDidClickForPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidClick: click", self.TAG);
}

- (void)rewardedVideoDidCloseForPlacementID:(NSString *)placementID rewarded:(BOOL)rewarded extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidClose: close", self.TAG);
}

- (void)rewardedVideoDidRewardSuccessForPlacemenID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidRewardSuccess: reward", self.TAG);
}

- (void)rewardedVideoDidFailToPlayForPlacementID:(NSString *)placementID error:(NSError *)error extra:(NSDictionary *)extra {
    NSLog(@"%@ rewardedVideoDidFailToPlay: play error: %@", self.TAG, error.localizedDescription);
}

@end
