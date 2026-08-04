#import <UIKit/UIKit.h>
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopOnSelfRenderView : UIView

@property (nonatomic, strong) UILabel *advertiserLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *ctaLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong, nullable) UIView *mediaView;

- (void)setDataWithOffer:(ATNativeAdOffer *)offer;

@end

NS_ASSUME_NONNULL_END
