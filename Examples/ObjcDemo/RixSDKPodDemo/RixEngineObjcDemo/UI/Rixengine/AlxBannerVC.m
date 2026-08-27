#import "AlxBannerVC.h"
#import <AlxAds/AlxAds.h>
#import "AdConfig.h"

static NSString *const TAG = @"Alx-banner:";

@interface AlxBannerVC () <AlxBannerViewAdDelegate>
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) AlxBannerAdView *bannerView;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong) AlxBannerAdView *bannerView2;
@property (nonatomic, assign) BOOL isBanner2;
@end

@implementation AlxBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"alx_banner", @"");

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];

    UIStackView *contentView = [[UIStackView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    contentView.axis = UILayoutConstraintAxisVertical;
    contentView.spacing = 20;
    [scrollView addSubview:contentView];

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(preloadAd)];
    [contentView addArrangedSubview:bnLoad];

    UIButton *bnShow = [self createButtonWithTitle:NSLocalizedString(@"show_ad", @"") action:@selector(showAd)];
    [contentView addArrangedSubview:bnShow];

    self.label = [self createLabel];
    [contentView addArrangedSubview:self.label];

    self.adContainer = [[UIView alloc] init];
    self.adContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addArrangedSubview:self.adContainer];

    UIButton *bnLoadAndShow = [self createButtonWithTitle:NSLocalizedString(@"load_and_show_ad", @"") action:@selector(loadAndShowAd)];
    [contentView addArrangedSubview:bnLoadAndShow];

    self.bannerView = [[AlxBannerAdView alloc] init];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addArrangedSubview:self.bannerView];

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [contentView.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor constant:20],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],
        [bnShow.heightAnchor constraintEqualToConstant:50],
        [self.label.heightAnchor constraintEqualToConstant:50],
        [bnLoadAndShow.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)preloadAd {
    self.isBanner2 = YES;
    if (self.isLoading) return;
    self.isLoading = YES;
    self.label.text = NSLocalizedString(@"loading", @"");
    self.bannerView2 = [[AlxBannerAdView alloc] init];
    self.bannerView2.refreshInterval = 0;
    self.bannerView2.delegate = self;
    self.bannerView2.rootViewController = self;
    [self.bannerView2 loadAdWithAdUnitId:AdConfig.Alx_Banner_Ad_Id];
}

- (void)showAd {
    if (self.isLoading) {
        NSLog(@"%@", NSLocalizedString(@"show_ad_no_load", @""));
        return;
    }
    if (self.bannerView2 && [self.bannerView2 isReady]) {
        [self.adContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.bannerView2.translatesAutoresizingMaskIntoConstraints = NO;
        [self.adContainer addSubview:self.bannerView2];
        [NSLayoutConstraint activateConstraints:@[
            [self.bannerView2.topAnchor constraintEqualToAnchor:self.adContainer.topAnchor],
            [self.bannerView2.bottomAnchor constraintEqualToAnchor:self.adContainer.bottomAnchor],
            [self.bannerView2.leadingAnchor constraintEqualToAnchor:self.adContainer.leadingAnchor],
            [self.bannerView2.trailingAnchor constraintEqualToAnchor:self.adContainer.trailingAnchor]
        ]];
    }
}

- (void)loadAndShowAd {
    self.isBanner2 = NO;
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    self.bannerView.isHideClose = NO;
    [self.bannerView loadAdWithAdUnitId:AdConfig.Alx_Banner_Ad_Id];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.bannerView destroy];
    [self.bannerView2 destroy];
}

#pragma mark - AlxBannerViewAdDelegate

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdLoad", TAG);
    if (self.isBanner2) {
        self.isLoading = NO;
        self.label.text = NSLocalizedString(@"load_success", @"");
    }
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ bannerViewAdFailToLoad: %@", TAG, msg);
    if (self.isBanner2) {
        self.isLoading = NO;
        self.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg];
    }
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdImpression", TAG);
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClick", TAG);
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClose", TAG);
    if (self.isBanner2) {
        [self.adContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

@end
