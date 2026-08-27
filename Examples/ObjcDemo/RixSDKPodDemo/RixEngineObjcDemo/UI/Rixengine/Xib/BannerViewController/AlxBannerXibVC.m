#import "AlxBannerXibVC.h"
#import "AdConfig.h"

@interface AlxBannerXibVC ()

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, copy) NSString *TAG;

@end

@implementation AlxBannerXibVC

- (instancetype)init {
    self = [super initWithNibName:@"AlxBannerXibVC" bundle:nil];
    if (self) {
        _TAG = @"Alx-banner:";
        _isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Alx_banner", @"");
    
    [self setupLayout];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear", self.TAG);
    [self.bannerView destroy];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%@ viewDidDisappear", self.TAG);
}

- (void)setupLayout {
    [self.bnLoadAndShow setTitle:NSLocalizedString(@"load_and_show_ad", @"") forState:UIControlStateNormal];
    [self.bnLoadAndShow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bnLoadAndShow.backgroundColor = [UIColor darkGrayColor];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
    self.label.numberOfLines = 0;
    self.label.text = @"";
}

- (IBAction)bnLoadAndShow:(id)sender {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    self.label.text = NSLocalizedString(@"loading", @"");
    
    self.bannerView.delegate = self;
    self.bannerView.rootViewController = self;
    self.bannerView.isHideClose = NO;
    [self.bannerView loadAdWithAdUnitId:[AdConfig Alx_Banner_Ad_Id]];
}

#pragma mark - AlxBannerViewAdDelegate

- (void)bannerViewAdLoad:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdLoad: price: %f", self.TAG, [bannerView getPrice]);
    [bannerView reportBiddingUrl];
    [bannerView reportChargingUrl];
    
    self.isLoading = NO;
    self.label.text = NSLocalizedString(@"load_success", @"");
}

- (void)bannerViewAdFailToLoad:(AlxBannerAdView *)bannerView didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"%ld: %@", (long)error.code, error.localizedDescription];
    NSLog(@"%@ bannerViewAdFailToLoad: %@", self.TAG, msg);
    
    self.isLoading = NO;
    self.label.text = [NSString stringWithFormat:NSLocalizedString(@"load_failed", @""), msg];
}

- (void)bannerViewAdImpression:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdImpression", self.TAG);
}

- (void)bannerViewAdClick:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClick", self.TAG);
}

- (void)bannerViewAdClose:(AlxBannerAdView *)bannerView {
    NSLog(@"%@ bannerViewAdClose", self.TAG);
}

@end
