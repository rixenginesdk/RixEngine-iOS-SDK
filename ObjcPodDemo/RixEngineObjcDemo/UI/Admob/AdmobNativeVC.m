#import "AdmobNativeVC.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdConfig.h"
#import "UIImageView+AlxExtension.h"

@interface AdmobNativeVC () <GADNativeAdLoaderDelegate, GADNativeAdDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong, nullable) GADAdLoader *adLoader;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AdmobNativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Admob-native:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"admob_native", @"");

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

    self.adContainer = [[UIView alloc] init];
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
    GADMultipleAdsAdLoaderOptions *multipleAdOptions = [[GADMultipleAdsAdLoaderOptions alloc] init];
    self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:[AdConfig Admob_Native_Ad_Id]
                                       rootViewController:self
                                                  adTypes:@[GADAdLoaderAdTypeNative]
                                                  options:@[multipleAdOptions]];
    self.adLoader.delegate = self;
    [self.adLoader loadRequest:[GADRequest request]];
}

- (void)renderAdUI:(GADNativeAd *)nativeAd {
    GADNativeAdView *rootView = [[GADNativeAdView alloc] init];
    rootView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *topRootView = [[UIView alloc] init];
    topRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:topRootView];

    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [topRootView addSubview:iconView];

    UILabel *titleView = [self createLabel];
    titleView.textAlignment = NSTextAlignmentLeft;
    [topRootView addSubview:titleView];

    GADMediaView *mediaView = [[GADMediaView alloc] init];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:mediaView];

    UILabel *descView = [self createLabel];
    descView.textAlignment = NSTextAlignmentLeft;
    [rootView addSubview:descView];

    UILabel *advertiserView = [self createLabel];
    advertiserView.backgroundColor = [UIColor grayColor];
    [rootView addSubview:advertiserView];

    UILabel *callToActionView = [self createLabel];
    callToActionView.backgroundColor = [UIColor grayColor];
    [rootView addSubview:callToActionView];

    rootView.headlineView = titleView;
    rootView.bodyView = descView;
    rootView.iconView = iconView;
    rootView.mediaView = mediaView;
    rootView.callToActionView = callToActionView;
    rootView.advertiserView = advertiserView;

    rootView.mediaView.contentMode = UIViewContentModeScaleAspectFill;
    rootView.callToActionView.userInteractionEnabled = NO;

    [self clearSubView:self.adContainer];
    [self.adContainer addSubview:rootView];

    [NSLayoutConstraint activateConstraints:@[
        [rootView.leadingAnchor constraintEqualToAnchor:self.adContainer.leadingAnchor],
        [rootView.trailingAnchor constraintEqualToAnchor:self.adContainer.trailingAnchor],
        [rootView.topAnchor constraintEqualToAnchor:self.adContainer.topAnchor],
        [rootView.bottomAnchor constraintEqualToAnchor:self.adContainer.bottomAnchor],

        [topRootView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor],
        [topRootView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
        [topRootView.topAnchor constraintEqualToAnchor:rootView.topAnchor],
        [topRootView.heightAnchor constraintEqualToConstant:50],

        [iconView.leadingAnchor constraintEqualToAnchor:topRootView.leadingAnchor],
        [iconView.widthAnchor constraintEqualToConstant:50],
        [iconView.heightAnchor constraintEqualToConstant:50],

        [titleView.leadingAnchor constraintEqualToAnchor:iconView.trailingAnchor constant:10],
        [titleView.trailingAnchor constraintEqualToAnchor:topRootView.trailingAnchor],
        [titleView.centerYAnchor constraintEqualToAnchor:iconView.centerYAnchor],

        [mediaView.topAnchor constraintEqualToAnchor:topRootView.bottomAnchor constant:10],
        [mediaView.widthAnchor constraintEqualToAnchor:rootView.widthAnchor],
        [mediaView.heightAnchor constraintEqualToConstant:200],

        [descView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor],
        [descView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
        [descView.topAnchor constraintEqualToAnchor:mediaView.bottomAnchor constant:10],

        [advertiserView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor constant:10],
        [advertiserView.topAnchor constraintEqualToAnchor:descView.bottomAnchor constant:10],

        [callToActionView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
        [callToActionView.topAnchor constraintEqualToAnchor:descView.bottomAnchor constant:10],
    ]];

    titleView.text = nativeAd.headline;
    descView.text = nativeAd.body;
    advertiserView.text = nativeAd.advertiser;
    callToActionView.text = nativeAd.callToAction;
    mediaView.mediaContent = nativeAd.mediaContent;

    if (nativeAd.icon.image) {
        iconView.image = nativeAd.icon.image;
    } else if (nativeAd.icon.imageURL) {
        [iconView loadUrl:nativeAd.icon.imageURL.absoluteString];
    }

    nativeAd.delegate = self;
    rootView.nativeAd = nativeAd;
}

#pragma mark - GADNativeAdLoaderDelegate

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    NSLog(@"%@ adLoader", self.TAG);
    [self renderAdUI:nativeAd];
}

- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader {
    NSLog(@"%@ adLoaderDidFinishLoading", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
}

- (void)adLoader:(GADAdLoader *)adLoader didFailToReceiveAdWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ adLoader: error: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

#pragma mark - GADNativeAdDelegate

- (void)nativeAdDidRecordImpression:(GADNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdDidRecordImpression", self.TAG);
}

- (void)nativeAdDidRecordClick:(GADNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdDidRecordClick", self.TAG);
}

- (void)nativeAdWillPresentScreen:(GADNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdWillPresentScreen", self.TAG);
}

@end
