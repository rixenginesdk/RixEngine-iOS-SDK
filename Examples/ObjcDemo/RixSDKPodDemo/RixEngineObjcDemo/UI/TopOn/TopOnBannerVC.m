#import "TopOnBannerVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdConfig.h"

@interface TopOnBannerVC () <ATAdLoadingDelegate, ATBannerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong, nullable) ATBannerView *bannerView;
@property (nonatomic, assign) CGSize bannerSize;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation TopOnBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"TopOn-banner:";
    self.bannerSize = CGSizeMake(320, 50);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"topOn_banner", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    self.adContainer = [[UIView alloc] init];
    self.adContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adContainer];

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],

        [self.label.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],
        [self.label.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50],

        [self.adContainer.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:20],
        [self.adContainer.widthAnchor constraintEqualToAnchor:self.view.widthAnchor],
        [self.adContainer.heightAnchor constraintEqualToConstant:100],
    ]];
}

- (void)buttonLoad {
    NSLog(@"load ad");
    if (self.isLoading) {
        return;
    }
    [self updateUI:YES message:NSLocalizedString(@"loading", @"")];
    [self loadAd];
}

- (void)loadAd {
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    extra[kATAdLoadingExtraMediaExtraKey] = @"media_val_BannerVC";
    [[ATAdManager sharedManager] loadADWithPlacementID:[AdConfig TopOn_Banner_Ad_Id] extra:extra delegate:self];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

- (void)showAd {
    if (![[ATAdManager sharedManager] bannerAdReadyForPlacementID:[AdConfig TopOn_Banner_Ad_Id]]) {
        NSLog(@"Ad wasn't ready");
        self.label.text = @"Ad wasn't ready";
        return;
    }

    ATBannerView *bannerView = [[ATAdManager sharedManager] retrieveBannerViewForPlacementID:[AdConfig TopOn_Banner_Ad_Id]];
    if (bannerView) {
        bannerView.delegate = self;
        bannerView.presentingViewController = self;
        bannerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.bannerView = bannerView;

        [self clearSubView:self.adContainer];
        [self.adContainer addSubview:bannerView];

        [NSLayoutConstraint activateConstraints:@[
            [bannerView.topAnchor constraintEqualToAnchor:self.adContainer.topAnchor],
            [bannerView.bottomAnchor constraintEqualToAnchor:self.adContainer.bottomAnchor],
            [bannerView.centerXAnchor constraintEqualToAnchor:self.adContainer.centerXAnchor],
            [bannerView.widthAnchor constraintEqualToConstant:self.bannerSize.width],
            [bannerView.heightAnchor constraintEqualToConstant:self.bannerSize.height],
        ]];
    } else {
        self.label.text = @"TopOn BannerView is empty";
    }
}

- (void)close {
    if (self.bannerView) {
        // Note: destroyBanner might not be available in all versions, 
        // but following the Swift version's logic.
        // [self.bannerView destroyBanner];
        [self.bannerView removeFromSuperview];
        self.bannerView = nil;
    }
}

#pragma mark - ATAdLoadingDelegate

- (void)didFinishLoadingADWithPlacementID:(NSString *)placementID {
    NSLog(@"%@ didFinishLoadingAD", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
    [self showAd];
}

- (void)didFailToLoadADWithPlacementID:(NSString *)placementID error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ didFailToLoadAD: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

#pragma mark - ATBannerDelegate

- (void)bannerView:(ATBannerView *)bannerView didShowAdWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ bannerView: Impression", self.TAG);
}

- (void)bannerView:(ATBannerView *)bannerView didClickWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ bannerView: click", self.TAG);
}

- (void)bannerView:(ATBannerView *)bannerView didTapCloseButtonWithPlacementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ bannerView: close", self.TAG);
    [self close];
}

@end
