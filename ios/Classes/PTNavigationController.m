#import "PTFlutterDocumentController.h"
#import "PTNavigationController.h"

@implementation PTNavigationController

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [self.flutterDocumentController shouldSetNavigationBarHidden:hidden animated:animated];

    if (allowed) {
        [super setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [self.flutterDocumentController shouldSetToolbarHidden:hidden animated:animated];

    if (allowed) {
        [super setToolbarHidden:hidden animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated
{
    [UINavigationBar appearance].barTintColor = UIColor.whiteColor;
    [UIToolbar appearance].barTintColor = UIColor.whiteColor;
}

@end
