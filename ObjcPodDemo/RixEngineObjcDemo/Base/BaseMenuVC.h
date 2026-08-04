#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
#import "MenuItem.h"

typedef NS_ENUM(NSInteger, MenuAppearance) {
    MenuAppearancePlain,
    MenuAppearanceCard
};

@interface BaseMenuVC : BaseUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<MenuItem *> *menuItems;

- (void)setupSDK;
- (MenuAppearance)menuAppearance;
- (NSString *)menuSubtitleAtIndex:(NSInteger)index;

@end

@interface MenuCardCell : UITableViewCell

+ (NSString *)reuseID;

- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@end
