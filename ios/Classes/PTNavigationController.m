#import "PTNavigationController.h"

@interface PTNavigationController()

@property (nonatomic, weak, readonly, nullable) PTFlutterDocumentController* currentFlutterDocumentController;

@end

@implementation PTNavigationController

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [self.currentFlutterDocumentController shouldSetNavigationBarHidden:hidden animated:animated];

    if (allowed) {
        [super setNavigationBarHidden:hidden animated:animated];
    }
}

- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated
{
    BOOL allowed = [self.currentFlutterDocumentController shouldSetToolbarHidden:hidden animated:animated];

    if (allowed) {
        [super setToolbarHidden:hidden animated:animated];
    }
}

- (PTFlutterDocumentController *)currentFlutterDocumentController {
    return (PTFlutterDocumentController *)[PdftronFlutterPlugin PT_getSelectedDocumentController:self.tabbedDocumentViewController];
}

@end
