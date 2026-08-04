#import "MaxNativeVC.h"
#import <AppLovinSDK/AppLovinSDK.h>
#import "AdConfig.h"

@interface MaxNativeVC () <MANativeAdDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong, nullable) MANativeAdLoader *adLoader;
@property (nonatomic, strong, nullable) MAAd *nativeAd;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation MaxNativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Max-native:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"max_native", @"");

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    scrollView.scrollEnabled = YES;

    UIStackView *contentView = [[UIStackView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];
    contentView.axis = UILayoutConstraintAxisVertical;
    contentView.spacing = 20;

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [contentView addArrangedSubview:bnLoad];

    self.label = [self createLabel];
    [contentView addArrangedSubview:self.label];

    self.adContainer = [[UIStackView alloc] init];
    self.adContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addArrangedSubview:self.adContainer];

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
        [self.label.heightAnchor constraintEqualToConstant:50],
        [self.adContainer.heightAnchor constraintEqualToConstant:500],
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

- (void)loadAd {
    self.adLoader = [[MANativeAdLoader alloc] initWithAdUnitIdentifier:[AdConfig Max_Native_Ad_Id]];
    self.adLoader.nativeAdDelegate = self;
    [self.adLoader loadAd];
}

- (void)renderAdTemplatesUI:(MANativeAdView *)nativeAdView {
    [self clearSubView:self.adContainer];
    nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adContainer addSubview:nativeAdView];

    [NSLayoutConstraint activateConstraints:@[
        [nativeAdView.widthAnchor constraintEqualToAnchor:self.adContainer.widthAnchor],
        [nativeAdView.heightAnchor constraintEqualToConstant:500],
        [nativeAdView.topAnchor constraintEqualToAnchor:self.adContainer.topAnchor],
    ]];
}

#pragma mark - MANativeAdDelegate

- (void)didLoadNativeAd:(MANativeAdView *)nativeAdView forAd:(MAAd *)ad {
    NSLog(@"%@ didLoadNativeAd", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];

    if (self.nativeAd) {
        [self.adLoader destroyAd:self.nativeAd];
    }
    self.nativeAd = ad;

    if (nativeAdView) {
        [self renderAdTemplatesUI:nativeAdView];
    } else {
        NSLog(@"%@ no template ui", self.TAG);
    }
}

- (void)didFailToLoadNativeAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.description];
    NSLog(@"%@ didFailToLoadNativeAd: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

- (void)didClickNativeAd:(MAAd *)ad {
    NSLog(@"%@ didClickNativeAd", self.TAG);
}

@end
