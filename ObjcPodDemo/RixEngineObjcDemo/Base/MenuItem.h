#import <UIKit/UIKit.h>

@interface MenuItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIViewController *(^makeVC)(void);

- (instancetype)initWithTitle:(NSString *)title makeVC:(UIViewController *(^)(void))makeVC;

@end
