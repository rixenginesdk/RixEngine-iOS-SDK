#import "TopOnNativeSelfRenderVC.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AdConfig.h"
#import "TopOnSelfRenderView.h"

@interface TopOnNativeSelfRenderVC () <ATAdLoadingDelegate, ATNativeADDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UIView *adContainer;
@property (nonatomic, strong, nullable) ATNativeADView *adView;
@property (nonatomic, strong, nullable) TopOnSelfRenderView *selfRenderView;
@property (nonatomic, strong, nullable) ATNativeAdOffer *nativeAdOffer;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation TopOnNativeSelfRenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"TopOn-native-selfRender:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"topOn_native_self_render", @"");

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
    NSMutableDictionary *extra = [NSMutableDictionary dictionary];
    extra[kATAdLoadingExtraMediaExtraKey] = @"media_val_NativeVC";
    extra[kATExtraInfoNativeAdSizeKey] = [NSValue valueWithCGSize:CGSizeMake(self.adContainer.frame.size.width, 350)];
    [[ATAdManager sharedManager] loadADWithPlacementID:[AdConfig TopOn_Native_Ad_Id] extra:extra delegate:self];
}

- (void)showAd {
    if ([[ATAdManager sharedManager] nativeAdReadyForPlacementID:[AdConfig TopOn_Native_Ad_Id]]) {
        [self renderAdUI];
    } else {
        [self updateUI:NO message:@"showAd: Ad wasn't ready"];
        NSLog(@"%@ Ad wasn't ready", self.TAG);
    }
}

- (void)renderAdUI {
    ATNativeADConfiguration *config = [[ATNativeADConfiguration alloc] init];
    config.ADFrame = CGRectMake(0, 0, self.adContainer.frame.size.width, 350);
    config.mediaViewFrame = CGRectMake(0, 0, self.adContainer.frame.size.width, 100);
    config.delegate = self;
    config.rootViewController = self;
    config.sizeToFit = YES;
    config.logoViewFrame = CGRectMake(0, 0, 50, 50);

    self.nativeAdOffer = [[ATAdManager sharedManager] getNativeAdOfferWithPlacementID:[AdConfig TopOn_Native_Ad_Id]];
    if (!self.nativeAdOffer) {
        NSLog(@"offer is empty");
        return;
    }

    TopOnSelfRenderView *selfRenderView = [[TopOnSelfRenderView alloc] init];
    [selfRenderView setDataWithOffer:self.nativeAdOffer];
    self.selfRenderView = selfRenderView;

    ATNativeADView *nativeAdView = [[ATNativeADView alloc] initWithConfiguration:config currentOffer:self.nativeAdOffer placementID:[AdConfig TopOn_Native_Ad_Id]];
    nativeAdView.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *mediaView = [nativeAdView getMediaView];
    if (mediaView) {
        NSLog(@"mediaView exists");
        selfRenderView.mediaView = mediaView;
    }

    NSMutableArray *clickableViewArray = [NSMutableArray arrayWithArray:@[
        selfRenderView.iconImageView,
        selfRenderView.titleLabel,
        selfRenderView.logoImageView,
        selfRenderView.textLabel,
        selfRenderView.ctaLabel
    ]];
    if (selfRenderView.mediaView) {
        [clickableViewArray addObject:selfRenderView.mediaView];
    }
    [nativeAdView registerClickableViewArray:clickableViewArray];

    ATNativePrepareInfo *info = [ATNativePrepareInfo loadPrepareInfo:^(ATNativePrepareInfo * _Nonnull prepareInfo) {
        prepareInfo.textLabel = selfRenderView.textLabel;
        prepareInfo.advertiserLabel = selfRenderView.advertiserLabel;
        prepareInfo.titleLabel = selfRenderView.titleLabel;
        prepareInfo.iconImageView = selfRenderView.iconImageView;
        prepareInfo.mainImageView = selfRenderView.mainImageView;
        prepareInfo.logoImageView = selfRenderView.logoImageView;
        prepareInfo.ctaLabel = selfRenderView.ctaLabel;
        if (selfRenderView.mediaView) {
            prepareInfo.mediaView = selfRenderView.mediaView;
        }
    }];
    [nativeAdView prepareWithNativePrepareInfo: info];

    [self.nativeAdOffer rendererWithConfiguration:config selfRenderView:selfRenderView nativeADView:nativeAdView];
    self.adView = nativeAdView;

    [self clearSubView:self.adContainer];
    [self.adContainer addSubview:nativeAdView];

    [NSLayoutConstraint activateConstraints:@[
        [nativeAdView.widthAnchor constraintEqualToAnchor:self.adContainer.widthAnchor],
        [nativeAdView.heightAnchor constraintEqualToAnchor:self.adContainer.heightAnchor],
    ]];
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

#pragma mark - ATNativeADDelegate

- (void)didShowNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ didShowNativeAd: impression", self.TAG);
}

- (void)didClickNativeAdInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ didClickNativeAd: click", self.TAG);
}

- (void)didTapCloseButtonInAdView:(ATNativeADView *)adView placementID:(NSString *)placementID extra:(NSDictionary *)extra {
    NSLog(@"%@ didTapCloseButton: close", self.TAG);
}

@end
