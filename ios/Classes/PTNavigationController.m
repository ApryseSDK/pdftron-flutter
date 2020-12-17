#import "PTNavigationController.h"

@implementation PTNavigationController

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [[self getCurrentFlutterDocumentController] shouldSetNavigationBarHidden:hidden animated:animated];

    if (allowed) {
        [super setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [[self getCurrentFlutterDocumentController] shouldSetToolbarHidden:hidden animated:animated];

    if (allowed) {
        [super setToolbarHidden:hidden animated:animated];
    }
}

- (PTFlutterDocumentController *)getCurrentFlutterDocumentController {
    return (PTFlutterDocumentController *)[PdftronFlutterPlugin PT_getSelectedDocumentController:self.tabbedDocumentViewController];
}

@end
