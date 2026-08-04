#import "MenuItem.h"

@implementation MenuItem

- (instancetype)initWithTitle:(NSString *)title makeVC:(UIViewController *(^)(void))makeVC {
    self = [super init];
    if (self) {
        _title = title;
        _makeVC = makeVC;
    }
    return self;
}

@end
