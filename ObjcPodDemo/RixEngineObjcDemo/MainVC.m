#import "MainVC.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <AlxAds/AlxAds-Swift.h>
#import "AlxMainVC.h"
#import "AdmobMainVC.h"
#import "MaxMainVC.h"
#import "TopOnMainVC.h"
#import "LevelPlayMainVC.h"

@interface MainMenuItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) UIViewController *(^makeVC)(void);
@end

@implementation MainMenuItem
@end

@interface PaddingLabel : UILabel
@end

@implementation PaddingLabel
- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    return CGSizeMake(size.width + 16, size.height + 4);
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:CGRectInset(rect, 8, 2)];
}
@end

@interface MainMenuCardCell ()
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *chevronImageView;
@end

@implementation MainMenuCardCell

+ (NSString *)reuseID { return @"MainMenuCardCell"; }

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    CGFloat scale = highlighted ? 0.98 : 1.0;
    CGFloat alpha = highlighted ? 0.78 : 1.0;
    [UIView animateWithDuration:animated ? 0.15 : 0 animations:^{
        self.cardView.transform = CGAffineTransformMakeScale(scale, scale);
        self.cardView.alpha = alpha;
    }];
}

- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
    self.chevronImageView.tintColor = [UIColor colorWithRed:0.78 green:0.79 blue:0.84 alpha:1];
    self.titleLabel.textColor = [UIColor colorWithRed:0.12 green:0.13 blue:0.20 alpha:1];
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 18;
    self.cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardView.layer.shadowOpacity = 0.02;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 2);
    self.cardView.layer.shadowRadius = 8;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.titleLabel.textColor = [UIColor colorWithRed:0.12 green:0.13 blue:0.20 alpha:1];
    self.titleLabel.numberOfLines = 1;

    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.56 green:0.57 blue:0.64 alpha:1];
    self.subtitleLabel.numberOfLines = 2;

    self.chevronImageView = [[UIImageView alloc] init];
    self.chevronImageView.translatesAutoresizingMaskIntoConstraints = NO;
    if (@available(iOS 13.0, *)) {
        self.chevronImageView.image = [UIImage systemImageNamed:@"chevron.right"];
    }
    self.chevronImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.chevronImageView.tintColor = [UIColor colorWithRed:0.78 green:0.79 blue:0.84 alpha:1];

    [self.contentView addSubview:self.cardView];
    [self.cardView addSubview:self.titleLabel];
    [self.cardView addSubview:self.subtitleLabel];
    [self.cardView addSubview:self.chevronImageView];

    NSLayoutConstraint *cardBottom = [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6];
    cardBottom.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *subtitleBottom = [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-14];
    subtitleBottom.priority = UILayoutPriorityDefaultHigh;

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:6],
        cardBottom,

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:14],
        [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.chevronImageView.leadingAnchor constant:-12],

        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.subtitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.chevronImageView.leadingAnchor constant:-12],
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        subtitleBottom,

        [self.chevronImageView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [self.chevronImageView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.chevronImageView.widthAnchor constraintEqualToConstant:14],
        [self.chevronImageView.heightAnchor constraintEqualToConstant:14]
    ]];
}

@end

@interface MainVC ()
@property (nonatomic, strong) NSArray<MainMenuItem *> *items;
@property (nonatomic, assign) CGFloat lastHeaderWidth;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = nil;
    [self configureMainListAppearance];
    [self setupTopHeaderView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat currentWidth = self.tableView.bounds.size.width;
    if (currentWidth > 0 && fabs(currentWidth - self.lastHeaderWidth) > 0.5) {
        self.lastHeaderWidth = currentWidth;
        [self setupTopHeaderView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self requestATTPermission];
    });
}

- (NSArray<MainMenuItem *> *)items {
    if (!_items) {
        MainMenuItem *alx = [[MainMenuItem alloc] init];
        alx.title = NSLocalizedString(@"Alx_ad", @"");
        alx.subtitle = @"Direct integration with RixEngine ad serving.";
        alx.makeVC = ^UIViewController *{ return [[AlxMainVC alloc] init]; };

        MainMenuItem *admob = [[MainMenuItem alloc] init];
        admob.title = NSLocalizedString(@"admob_ad", @"");
        admob.subtitle = @"Google AdMob mediation integration.";
        admob.makeVC = ^UIViewController *{ return [[AdmobMainVC alloc] init]; };

        MainMenuItem *max = [[MainMenuItem alloc] init];
        max.title = NSLocalizedString(@"max_ad", @"");
        max.subtitle = @"AppLovin MAX mediation integration.";
        max.makeVC = ^UIViewController *{ return [[MaxMainVC alloc] init]; };

        MainMenuItem *topOn = [[MainMenuItem alloc] init];
        topOn.title = NSLocalizedString(@"topOn_ad", @"");
        topOn.subtitle = @"TopOn mediation integration.";
        topOn.makeVC = ^UIViewController *{ return [[TopOnMainVC alloc] init]; };

        MainMenuItem *levelPlay = [[MainMenuItem alloc] init];
        levelPlay.title = NSLocalizedString(@"levelPlay_ad", @"");
        levelPlay.subtitle = @"ironSource LevelPlay mediation integration.";
        levelPlay.makeVC = ^UIViewController *{ return [[LevelPlayMainVC alloc] init]; };

        _items = @[alx, admob, max, topOn, levelPlay];
    }
    return _items;
}

- (void)configureMainListAppearance {
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(6, 0, 24, 0);
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[MainMenuCardCell class] forCellReuseIdentifier:[MainMenuCardCell reuseID]];
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)setupTopHeaderView {
    CGFloat horizontalInset = 24;
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];

    UIView *iconWrap = [[UIView alloc] init];
    iconWrap.backgroundColor = [UIColor colorWithRed:0.90 green:0.92 blue:0.98 alpha:1];
    iconWrap.layer.cornerRadius = 22;
    iconWrap.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.translatesAutoresizingMaskIntoConstraints = NO;
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    iconImage.layer.cornerRadius = 18;
    iconImage.clipsToBounds = YES;
    iconImage.image = [UIImage imageNamed:@"appLogo"];
    [iconWrap addSubview:iconImage];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = @"SDK Demo";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor colorWithRed:0.10 green:0.11 blue:0.20 alpha:1];

    // Version badge
    PaddingLabel *versionLabel = [[PaddingLabel alloc] init];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    versionLabel.text = [self appVersionText];
    versionLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    versionLabel.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.55 alpha:1];
    versionLabel.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.97 alpha:1];
    versionLabel.layer.cornerRadius = 10;
    versionLabel.clipsToBounds = YES;
    
    // ObjC language badge
    UIView *ocBadge = [[UIView alloc] init];
    ocBadge.backgroundColor = [UIColor colorWithRed:0.93 green:0.96 blue:0.98 alpha:1];
    ocBadge.layer.cornerRadius = 10;
    ocBadge.clipsToBounds = YES;
    ocBadge.translatesAutoresizingMaskIntoConstraints = NO;

    UIImageView *objcIcon = [[UIImageView alloc] init];
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:11 weight:UIFontWeightMedium];
        objcIcon.image = [UIImage systemImageNamed:@"chevron.left.forwardslash.chevron.right" withConfiguration:config];
    }
    objcIcon.translatesAutoresizingMaskIntoConstraints = NO;
    objcIcon.tintColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.8 alpha:1];
    objcIcon.contentMode = UIViewContentModeScaleAspectFit;

    UILabel *objcLabel = [[UILabel alloc] init];
    objcLabel.translatesAutoresizingMaskIntoConstraints = NO;
    objcLabel.text = @"ObjC";
    objcLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightMedium];
    objcLabel.textColor = [UIColor colorWithRed:0.5 green:0.35 blue:0.55 alpha:1];

    UILabel *idfaLabel = [[UILabel alloc] init];
    idfaLabel.translatesAutoresizingMaskIntoConstraints = NO;
    idfaLabel.text = [NSString stringWithFormat:@"IDFA:%@", [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString];
    idfaLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    idfaLabel.textColor = [UIColor colorWithRed:0.64 green:0.66 blue:0.74 alpha:1];
    idfaLabel.numberOfLines = 2;

    UIStackView *titleStack = [[UIStackView alloc] initWithArrangedSubviews:@[titleLabel, versionLabel, objcIcon, objcLabel]];
    titleStack.translatesAutoresizingMaskIntoConstraints = NO;
    titleStack.axis = UILayoutConstraintAxisHorizontal;
    titleStack.alignment = UIStackViewAlignmentCenter;
    titleStack.spacing = 8;
    [titleStack setCustomSpacing:12 afterView:titleLabel];
    [titleStack setCustomSpacing:12 afterView:versionLabel];
    [titleStack setCustomSpacing:3 afterView:objcIcon];

    [container addSubview:iconWrap];
    [container addSubview:titleStack];
    [container addSubview:idfaLabel];

    NSLayoutConstraint *idfaTopPreferred = [idfaLabel.topAnchor constraintEqualToAnchor:iconWrap.bottomAnchor constant:14];
    idfaTopPreferred.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *idfaBottomPreferred = [idfaLabel.bottomAnchor constraintEqualToAnchor:container.bottomAnchor constant:-8];
    idfaBottomPreferred.priority = UILayoutPriorityDefaultHigh;

    [NSLayoutConstraint activateConstraints:@[
        [iconWrap.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:horizontalInset],
        [iconWrap.topAnchor constraintEqualToAnchor:container.topAnchor constant:6],
        [iconWrap.widthAnchor constraintEqualToConstant:44],
        [iconWrap.heightAnchor constraintEqualToConstant:44],

        [iconImage.centerXAnchor constraintEqualToAnchor:iconWrap.centerXAnchor],
        [iconImage.centerYAnchor constraintEqualToAnchor:iconWrap.centerYAnchor],
        [iconImage.widthAnchor constraintEqualToConstant:36],
        [iconImage.heightAnchor constraintEqualToConstant:36],

        [titleStack.leadingAnchor constraintEqualToAnchor:iconWrap.trailingAnchor constant:10],
        [titleStack.centerYAnchor constraintEqualToAnchor:iconWrap.centerYAnchor],
        [titleStack.trailingAnchor constraintLessThanOrEqualToAnchor:container.trailingAnchor constant:-horizontalInset],

        [objcIcon.widthAnchor constraintEqualToConstant:14],
        [objcIcon.heightAnchor constraintEqualToConstant:14],

        [idfaLabel.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:horizontalInset],
        [idfaLabel.trailingAnchor constraintEqualToAnchor:container.trailingAnchor constant:-horizontalInset],
        [idfaLabel.topAnchor constraintGreaterThanOrEqualToAnchor:iconWrap.bottomAnchor constant:14],
        idfaTopPreferred,
        [idfaLabel.bottomAnchor constraintLessThanOrEqualToAnchor:container.bottomAnchor constant:-8],
        idfaBottomPreferred
    ]];

    CGFloat fittingWidth = self.tableView.bounds.size.width;
    if (fittingWidth > 0) {
        CGFloat textWidth = MAX(0, fittingWidth - (horizontalInset * 2));
        CGSize idfaSize = [idfaLabel sizeThatFits:CGSizeMake(textWidth, CGFLOAT_MAX)];
        CGFloat idfaHeight = ceil(idfaSize.height);
        CGFloat headerHeight = 6 + 44 + 14 + idfaHeight + 8;
        container.frame = CGRectMake(0, 0, fittingWidth, headerHeight);
        self.tableView.tableHeaderView = container;
    }
}

- (NSString *)appVersionText {
    return [AlxSdk getSDKVersion];
}

- (void)requestATTPermission {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRequestedTrackingAuthorization"];
            NSString *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            NSLog(@"idfa: %@", idfa);
        }];
    } else {
        NSString *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
        NSLog(@"idfa: %@", idfa);
    }
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor clearColor];

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = @"Ad Platforms";
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
    label.textColor = [UIColor colorWithRed:0.46 green:0.47 blue:0.55 alpha:1];
    [container addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:container.leadingAnchor constant:24],
        [label.trailingAnchor constraintLessThanOrEqualToAnchor:container.trailingAnchor constant:-24],
        [label.bottomAnchor constraintLessThanOrEqualToAnchor:container.bottomAnchor constant:-8],
        [label.topAnchor constraintGreaterThanOrEqualToAnchor:container.topAnchor constant:6],
        [label.centerYAnchor constraintEqualToAnchor:container.centerYAnchor]
    ]];
    return container;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainMenuCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainMenuCardCell reuseID] forIndexPath:indexPath];
    MainMenuItem *item = self.items[indexPath.row];
    [cell configureWithTitle:item.title subtitle:item.subtitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MainMenuItem *item = self.items[indexPath.row];
    [self.navigationController pushViewController:item.makeVC() animated:YES];
}

@end
