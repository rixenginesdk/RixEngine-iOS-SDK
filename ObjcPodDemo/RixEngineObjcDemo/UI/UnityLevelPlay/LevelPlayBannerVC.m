#import "LevelPlayBannerVC.h"
#import <IronSource/IronSource.h>
#import "AdConfig.h"

static NSString *const TAG = @"LevelPlay-banner:";

@interface LevelPlayBannerVC () <LPMBannerAdViewDelegate>
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) LPMBannerAdView *bannerAdView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation LevelPlayBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"levelPlay_banner", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],

        [self.label.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],
        [self.label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50]
    ]];
}

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (void)buttonLoad {
    NSLog(@"%@ buttonLoad", TAG);
    if (self.isLoading) return;
    [self updateUI:YES message:NSLocalizedString(@"loading", @"")];
    [self loadAd];
}

- (void)loadAd {
    [self.bannerAdView destroy];
    [self.bannerAdView removeFromSuperview];
    self.bannerAdView = nil;

    CGFloat width = self.view.safeAreaLayoutGuide.layoutFrame.size.width;
    if (width <= 0) width = [UIScreen mainScreen].bounds.size.width;

    LPMAdSize *adSize = [LPMAdSize createAdaptiveAdSizeWithWidth:width];
    
    LPMBannerAdViewConfigBuilder *configBuilder = [[LPMBannerAdViewConfigBuilder alloc] init];
    [configBuilder setWithAdSize:adSize];
    LPMBannerAdViewConfig *config = [configBuilder build];

    self.bannerAdView = [[LPMBannerAdView alloc] initWithAdUnitId:AdConfig.LevelPlay_Banner_Ad_Id config:config];
    [self.bannerAdView setDelegate:self];
    self.bannerAdView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.bannerAdView];
    [NSLayoutConstraint activateConstraints:@[
        [self.bannerAdView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerAdView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:20],
        [self.bannerAdView.widthAnchor constraintEqualToConstant:adSize.width],
        [self.bannerAdView.heightAnchor constraintEqualToConstant:adSize.height]
    ]];

    [self.bannerAdView loadAdWithViewController:self];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - LPMBannerAdViewDelegate

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didLoadAd", TAG);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
    });
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ didFailToLoadAd: %@", TAG, msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
    });
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didDisplayAd", TAG);
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didClickAd", TAG);
}

- (void)didLeaveAppWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didLeaveApp", TAG);
}

- (void)didExpandAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didExpandAd", TAG);
}

- (void)didCollapseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSLog(@"%@ didCollapseAd", TAG);
}

@end
