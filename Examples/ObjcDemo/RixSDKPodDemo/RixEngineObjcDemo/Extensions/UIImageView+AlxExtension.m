#import "UIImageView+AlxExtension.h"

@implementation UIImageView (AlxExtension)

- (void)loadUrl:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString: urlString];
    if (!url) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: url];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData: data];
                if (image) {
                    self.image = image;
                }
            });
        }
    });
}

@end
