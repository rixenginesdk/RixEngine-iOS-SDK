#import "BaseMenuVC.h"

@interface MenuCardCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *chevronImageView;

@end

@implementation MenuCardCell

+ (NSString *)reuseID {
    return @"MenuCardCell";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    CGFloat scale = highlighted ? 0.985 : 1.0;
    CGFloat alpha = highlighted ? 0.82 : 1.0;
    [UIView animateWithDuration:animated ? 0.15 : 0 animations:^{
        self.cardView.transform = CGAffineTransformMakeScale(scale, scale);
        self.cardView.alpha = alpha;
    }];
}

- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    self.titleLabel.text = title;
    self.subtitleLabel.text = subtitle;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 18;

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

    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:6],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6],

        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:14],
        [self.titleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.chevronImageView.leadingAnchor constant:-12],

        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.subtitleLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.chevronImageView.leadingAnchor constant:-12],
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:6],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-14],

        [self.chevronImageView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [self.chevronImageView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.chevronImageView.widthAnchor constraintEqualToConstant:14],
        [self.chevronImageView.heightAnchor constraintEqualToConstant:14]
    ]];
}

@end

@implementation BaseMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self menuAppearance] == MenuAppearanceCard) {
        self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.98 alpha:1.0];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupSDK];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuCell"];
    [self.tableView registerClass:[MenuCardCell class] forCellReuseIdentifier:[MenuCardCell reuseID]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self applyMenuAppearance];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (void)applyMenuAppearance {
    switch ([self menuAppearance]) {
        case MenuAppearancePlain:
            self.tableView.backgroundColor = [UIColor whiteColor];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.showsVerticalScrollIndicator = YES;
            self.tableView.contentInset = UIEdgeInsetsZero;
            self.tableView.estimatedRowHeight = 54;
            self.tableView.rowHeight = 54;
            if (@available(iOS 15.0, *)) {
                self.tableView.sectionHeaderTopPadding = 0;
            }
            break;
        case MenuAppearanceCard:
            self.tableView.backgroundColor = self.view.backgroundColor;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.showsVerticalScrollIndicator = NO;
            self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 18, 0);
            self.tableView.estimatedRowHeight = 92;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            if (@available(iOS 15.0, *)) {
                self.tableView.sectionHeaderTopPadding = 0;
            }
            break;
    }
}

- (void)setupSDK {}
- (MenuAppearance)menuAppearance { return MenuAppearancePlain; }
- (NSString *)menuSubtitleAtIndex:(NSInteger)index { return nil; }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self menuAppearance] == MenuAppearanceCard) {
        MenuCardCell *cell = [tableView dequeueReusableCellWithIdentifier:[MenuCardCell reuseID] forIndexPath:indexPath];
        MenuItem *item = self.menuItems[indexPath.row];
        [cell configureWithTitle:item.title subtitle:[self menuSubtitleAtIndex:indexPath.row] ?: @""];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
        cell.textLabel.text = self.menuItems[indexPath.row].title;
        cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self menuAppearance] == MenuAppearanceCard ? UITableViewAutomaticDimension : 54;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self menuAppearance] == MenuAppearanceCard ? 92 : 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = self.menuItems[indexPath.row].makeVC();
    [self.navigationController pushViewController:vc animated:YES];
}

@end
