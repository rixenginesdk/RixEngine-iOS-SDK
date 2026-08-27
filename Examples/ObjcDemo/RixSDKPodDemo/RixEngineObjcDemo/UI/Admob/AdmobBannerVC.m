#import "AdmobBannerVC.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "AdConfig.h"

@interface AdmobBannerVC () <GADBannerViewDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) GADBannerView *bannerView;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AdmobBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.TAG = @"Admob-banner:";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"admob_banner", @"");

    UIButton *bnLoad = [self createButtonWithTitle:NSLocalizedString(@"load_ad", @"") action:@selector(buttonLoad)];
    [self.view addSubview:bnLoad];

    self.label = [self createLabel];
    [self.view addSubview:self.label];

    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeBanner];
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bannerView];

    [NSLayoutConstraint activateConstraints:@[
        [bnLoad.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [bnLoad.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [bnLoad.heightAnchor constraintEqualToConstant:50],
        [bnLoad.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],

        [self.label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.label.heightAnchor constraintEqualToConstant:50],
        [self.label.topAnchor constraintEqualToAnchor:bnLoad.bottomAnchor constant:20],

        [self.bannerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.bannerView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:20],
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
    self.bannerView.adUnitID = [AdConfig Admob_Banner_Ad_Id];
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    [self.bannerView loadRequest:[GADRequest request]];
}

- (void)updateUI:(BOOL)loading message:(NSString *)msg {
    self.isLoading = loading;
    self.label.text = msg;
}

#pragma mark - GADBannerViewDelegate

- (void)bannerViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewDidReceiveAd", self.TAG);
    [self updateUI:NO message:NSLocalizedString(@"load_success", @"")];
}

- (void)bannerView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ bannerView: error: %@", self.TAG, msg);
    [self updateUI:NO message:[NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg]];
}

- (void)bannerViewDidRecordImpression:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewDidRecordImpression", self.TAG);
}

- (void)bannerViewDidRecordClick:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewDidRecordClick", self.TAG);
}

- (void)bannerViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewWillPresentScreen", self.TAG);
}

- (void)bannerViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewWillDismissScreen", self.TAG);
}

- (void)bannerViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"%@ bannerViewDidDismissScreen", self.TAG);
}

@end
