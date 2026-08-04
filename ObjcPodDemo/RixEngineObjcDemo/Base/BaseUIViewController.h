#import <UIKit/UIKit.h>

@interface BaseUIViewController : UIViewController

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action;
- (UILabel *)createLabel;
- (void)clearSubView:(UIView *)containerView;

@end
