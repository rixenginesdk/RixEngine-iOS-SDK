#import "TopOnSelfRenderView.h"
#import "UIImageView+AlxExtension.h"

@interface TopOnSelfRenderView ()

@property (nonatomic, strong) UIView *mediaContainerView;
@property (nonatomic, strong, nullable) ATNativeAdOffer *nativeAdOffer;

@end

@implementation TopOnSelfRenderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)setMediaView:(UIView *)mediaView {
    if (_mediaView) {
        [_mediaView removeFromSuperview];
    }
    _mediaView = mediaView;
    if (_mediaView) {
        [self.mediaContainerView addSubview:_mediaView];
        _mediaView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_mediaView.leadingAnchor constraintEqualToAnchor:self.mediaContainerView.leadingAnchor],
            [_mediaView.trailingAnchor constraintEqualToAnchor:self.mediaContainerView.trailingAnchor],
            [_mediaView.topAnchor constraintEqualToAnchor:self.mediaContainerView.topAnchor],
            [_mediaView.bottomAnchor constraintEqualToAnchor:self.mediaContainerView.bottomAnchor]
        ]];
    }
}

- (void)setDataWithOffer:(ATNativeAdOffer *)offer {
    self.nativeAdOffer = offer;
    [self setupUI];
    [self makeConstraints];
}

- (void)initView {
    self.advertiserLabel = [self createLabel];
    [self addSubview:self.advertiserLabel];

    self.titleLabel = [self createLabel];
    [self addSubview:self.titleLabel];

    self.textLabel = [self createLabel];
    [self addSubview:self.textLabel];

    self.ctaLabel = [self createLabel];
    self.ctaLabel.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:78.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.ctaLabel.layer.cornerRadius = 10;
    self.ctaLabel.textColor = [UIColor whiteColor];
    self.ctaLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.ctaLabel];

    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.iconImageView];

    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.logoImageView];

    self.mediaContainerView = [[UIView alloc] init];
    self.mediaContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.mediaContainerView];

    self.mainImageView = [[UIImageView alloc] init];
    self.mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.mediaContainerView addSubview:self.mainImageView];

    [self addUserInteraction];
}

- (void)makeConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.iconImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.iconImageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.iconImageView.widthAnchor constraintEqualToConstant:50],
        [self.iconImageView.heightAnchor constraintEqualToConstant:50],

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:10],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.titleLabel.centerYAnchor constraintEqualToAnchor:self.iconImageView.centerYAnchor],

        [self.mediaContainerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.mediaContainerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.mediaContainerView.topAnchor constraintEqualToAnchor:self.iconImageView.bottomAnchor constant:10],
        [self.mediaContainerView.heightAnchor constraintEqualToConstant:self.nativeAdOffer.nativeAd.mainImageHeight ?: 200],

        [self.mainImageView.leadingAnchor constraintEqualToAnchor:self.mediaContainerView.leadingAnchor],
        [self.mainImageView.trailingAnchor constraintEqualToAnchor:self.mediaContainerView.trailingAnchor],
        [self.mainImageView.topAnchor constraintEqualToAnchor:self.mediaContainerView.topAnchor],
        [self.mainImageView.bottomAnchor constraintEqualToAnchor:self.mediaContainerView.bottomAnchor],

        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.textLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.textLabel.topAnchor constraintEqualToAnchor:self.mediaContainerView.bottomAnchor constant:10],

        [self.advertiserLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.advertiserLabel.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor constant:10],
        [self.advertiserLabel.heightAnchor constraintEqualToConstant:30],

        [self.logoImageView.leadingAnchor constraintEqualToAnchor:self.advertiserLabel.trailingAnchor constant:10],
        [self.logoImageView.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor constant:10],
        [self.logoImageView.widthAnchor constraintEqualToConstant:30],
        [self.logoImageView.heightAnchor constraintEqualToConstant:30],

        [self.ctaLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.ctaLabel.topAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor constant:10],
        [self.ctaLabel.heightAnchor constraintEqualToConstant:30],
    ]];
}

- (void)addUserInteraction {
    self.advertiserLabel.userInteractionEnabled = YES;
    self.titleLabel.userInteractionEnabled = YES;
    self.iconImageView.userInteractionEnabled = YES;
    self.mainImageView.userInteractionEnabled = YES;
    self.mediaView.userInteractionEnabled = YES;
    self.textLabel.userInteractionEnabled = YES;
    self.ctaLabel.userInteractionEnabled = YES;
}

- (void)setupUI {
    if (!self.nativeAdOffer) return;
    ATNativeAd *nativeAd = self.nativeAdOffer.nativeAd;

    if (nativeAd.icon) {
        self.iconImageView.image = nativeAd.icon;
    } else if (nativeAd.iconUrl) {
        [self.iconImageView loadUrl:nativeAd.iconUrl];
    }

    if (nativeAd.logo) {
        self.logoImageView.image = nativeAd.logo;
    } else if (nativeAd.logoUrl) {
        [self.logoImageView loadUrl:nativeAd.logoUrl];
    }

    if (nativeAd.mainImage) {
        self.mainImageView.image = nativeAd.mainImage;
    } else if (nativeAd.imageUrl) {
        [self.mainImageView loadUrl:nativeAd.imageUrl];
    }

    self.titleLabel.text = nativeAd.title;
    self.textLabel.text = nativeAd.mainText;
    self.advertiserLabel.text = nativeAd.advertiser;
    self.ctaLabel.text = nativeAd.ctaText;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    return label;
}

@end
