#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "Tools/Tools.h"
#include "MyFlutterDocumentController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [PTOverrides overrideClass:[PTFlutterDocumentController class] withClass:[MyFlutterDocumentController class]];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
