#import "BaseUIViewController.h"

@implementation BaseUIViewController

- (UIButton *)createButtonWithTitle:(NSString *)title action:(SEL)action {
    UIColor *tintColor = [UIColor colorWithRed:76/255.0 green:190/255.0 blue:196/255.0 alpha:1.0];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.cornerRadius = 8.0;
    button.layer.borderWidth = 1.5;
    button.layer.borderColor = tintColor.CGColor;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setTitleColor:tintColor forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.numberOfLines = 0;
    return label;
}

- (void)clearSubView:(UIView *)containerView {
    for (UIView *view in containerView.subviews) {
        [view removeFromSuperview];
    }
}

@end
