#import "BaseMenuVC.h"

@interface MainVC : BaseMenuVC
@end

@interface MainMenuCardCell : UITableViewCell
+ (NSString *)reuseID;
- (void)configureWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
@end
