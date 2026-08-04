#import "MaxBannerVC.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AdConfig.h"

@interface MaxBannerVC () <MAAdViewAdDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) MAAdView *bannerView;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation MaxBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Max-banner:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"max_banner", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    self.bannerView = [[MAAdView alloc] initWithAdUnitIdentifier:[AdConfig Max_Banner_Ad_Id]];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];

    CGFloat height = [MAAdFormat banner].adaptiveSize.height;

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],

        [self.label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50],
        [self.label.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],

        [self.bannerView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:20],
        [self.bannerView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.bannerView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.bannerView.heightAnchor constraintEqualToConstant:height],
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
    self.bannerView.delegate = self;
    [self.bannerView setExtraParameterForKey:@"adaptive_banner" value:@"true"];
    [self.bannerView setLocalExtraParameterForKey:@"adaptive_banner_width" value:@400];
    [self.bannerView loadAd];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - MAAdViewAdDelegate

- (void)didExpandAd:(MAAd *)ad {
    NSLog(@"%@ didExpand", self.TAG);
}

- (void)didCollapseAd:(MAAd *)ad {
    NSLog(@"%@ didCollapse", self.TAG);
}

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
    NSLog(@"%@ didFail: %ld %@", self.TAG, (long)error.code, error.description);
}

@end
