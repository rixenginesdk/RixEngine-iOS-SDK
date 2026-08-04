#import "AlxNativeVC.h"
#import <AlxAds/AlxAds-Swift.h>
#import "AdConfig.h"
#import "UIImageView+AlxExtension.h"

@interface AlxNativeVC () <AlxNativeAdLoaderDelegate, AlxNativeAdDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong, nullable) AlxNativeAd *nativeAd;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AlxNativeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Alx-native:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"native_ad", @"");

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    scrollView.scrollEnabled = YES;

    UIStackView *contentView = [[UIStackView alloc] init];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];
    contentView.axis = UILayoutConstraintAxisVertical;
    contentView.spacing = 20;

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(loadAd)];
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

- (void)loadAd {
    NSLog(@"load ad");
    if (self.isLoading) {
        return;
    }

    self.isLoading = YES;
    self.label.text = NSLocalizedString(@"loading", @"");

    AlxNativeAdLoader *loader = [[AlxNativeAdLoader alloc] initWithAdUnitID:[AdConfig Alx_Native_Ad_Id]];
    loader.delegate = self;
    [loader loadAd];
}

- (void)showNativeAd:(AlxNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    [self createTemplateView];
}

- (void)createTemplateView {
    if (!self.nativeAd) {
        return;
    }
    AlxNativeAd *nativeAd = self.nativeAd;

    UIView *rootView = [[UIView alloc] init];
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

    AlxMediaView *mediaView = [[AlxMediaView alloc] init];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:mediaView];

    UILabel *descView = [self createLabel];
    descView.textAlignment = NSTextAlignmentLeft;
    [rootView addSubview:descView];

    UIView *bottomRootView = [[UIView alloc] init];
    bottomRootView.translatesAutoresizingMaskIntoConstraints = NO;
    [rootView addSubview:bottomRootView];

    UIStackView *adFlagContainer = [[UIStackView alloc] init];
    adFlagContainer.translatesAutoresizingMaskIntoConstraints = NO;
    adFlagContainer.axis = UILayoutConstraintAxisHorizontal;
    adFlagContainer.backgroundColor = [UIColor colorWithRed:169.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:0.71];
    adFlagContainer.spacing = 4;
    adFlagContainer.layoutMarginsRelativeArrangement = YES;
    adFlagContainer.layoutMargins = UIEdgeInsetsMake(0, 2, 0, 2);
    [bottomRootView addSubview:adFlagContainer];

    UILabel *adTagView = [self createLabel];
    adTagView.textColor = [UIColor whiteColor];
    adTagView.font = [UIFont systemFontOfSize:14];
    [adFlagContainer addArrangedSubview:adTagView];

    UIImageView *adLogoView = [[UIImageView alloc] init];
    adLogoView.translatesAutoresizingMaskIntoConstraints = NO;
    [adFlagContainer addArrangedSubview:adLogoView];

    UILabel *adSourceView = [self createLabel];
    [bottomRootView addSubview:adSourceView];

    UILabel *callToActionView = [self createLabel];
    callToActionView.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:78.0/255.0 blue:243.0/255.0 alpha:1.0];
    callToActionView.layer.cornerRadius = 10;
    callToActionView.textColor = [UIColor whiteColor];
    callToActionView.textAlignment = NSTextAlignmentCenter;
    [bottomRootView addSubview:callToActionView];

    UIImageView *closeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_close"]];
    closeView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomRootView addSubview:closeView];

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

        [bottomRootView.leadingAnchor constraintEqualToAnchor:rootView.leadingAnchor],
        [bottomRootView.trailingAnchor constraintEqualToAnchor:rootView.trailingAnchor],
        [bottomRootView.topAnchor constraintEqualToAnchor:descView.bottomAnchor],
        [bottomRootView.heightAnchor constraintEqualToConstant:50],

        [adFlagContainer.leadingAnchor constraintEqualToAnchor:bottomRootView.leadingAnchor constant:5],
        [adFlagContainer.centerYAnchor constraintEqualToAnchor:bottomRootView.centerYAnchor],

        [adLogoView.widthAnchor constraintEqualToConstant:10],
        [adLogoView.heightAnchor constraintEqualToConstant:10],

        [adSourceView.leadingAnchor constraintEqualToAnchor:adFlagContainer.trailingAnchor constant:10],
        [adSourceView.centerYAnchor constraintEqualToAnchor:bottomRootView.centerYAnchor],
        [adSourceView.heightAnchor constraintEqualToConstant:20],

        [closeView.trailingAnchor constraintEqualToAnchor:bottomRootView.trailingAnchor],
        [closeView.centerYAnchor constraintEqualToAnchor:bottomRootView.centerYAnchor],
        [closeView.widthAnchor constraintEqualToConstant:20],
        [closeView.heightAnchor constraintEqualToConstant:20],

        [callToActionView.trailingAnchor constraintEqualToAnchor:closeView.leadingAnchor constant:-10],
        [callToActionView.centerYAnchor constraintEqualToAnchor:bottomRootView.centerYAnchor],
        [callToActionView.widthAnchor constraintEqualToConstant:70],
        [callToActionView.heightAnchor constraintEqualToConstant:30],
    ]];

    adTagView.text = @"AD";
    adLogoView.image = nativeAd.adLogo;
    titleView.text = nativeAd.title;
    descView.text = nativeAd.desc;
    adSourceView.text = nativeAd.adSource;
    callToActionView.text = nativeAd.callToAction;

    if (nativeAd.icon.url) {
        [iconView loadUrl:nativeAd.icon.url];
    }
    [mediaView setMediaContent:nativeAd.mediaContent];

    nativeAd.delegate = self;
    nativeAd.rootViewController = self;
    [nativeAd registerViewWithContainer:rootView clickableViews:@[titleView, iconView, mediaView, callToActionView] closeView:closeView];
}

- (void)closeAd {
    [self clearSubView:self.adContainer];
}

- (void)dealloc {
    NSLog(@"deinit");
}

#pragma mark - AlxNativeAdLoaderDelegate

- (void)nativeAdLoadedWithDidReceive:(NSArray<AlxNativeAd *> *)ads {
    NSLog(@"%@ nativeAdLoaded", self.TAG);
    self.isLoading = NO;
    self.label.text = NSLocalizedString(@"load_success", @"");

    if (ads.firstObject) {
        AlxNativeAd *ad = ads.firstObject;
        [ad reportBiddingUrl];
        [ad reportChargingUrl];

        [self showNativeAd:ad];
    }
}

- (void)nativeAdFailToLoadWithDidFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ nativeAdFailedToLoad: %@", self.TAG, msg);

    self.isLoading = NO;
    self.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg];
}

#pragma mark - AlxNativeAdDelegate

- (void)nativeAdImpression:(AlxNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdImpression", self.TAG);
}

- (void)nativeAdClick:(AlxNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdClick", self.TAG);
}

- (void)nativeAdClose:(AlxNativeAd *)nativeAd {
    NSLog(@"%@ nativeAdClose", self.TAG);
    [self closeAd];
}

@end
