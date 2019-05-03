#import "PdftronFlutterPlugin.h"


@implementation PdftronFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"pdftron_flutter"
            binaryMessenger:[registrar messenger]];
  PdftronFlutterPlugin* instance = [[PdftronFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

-(void)configureDocumentViewController:(PTDocumentViewController*)documentViewController withConfig:(NSString*)config
{
    //convert from json to dict
    NSData* jsonData = [config dataUsingEncoding:NSUTF8StringEncoding];
    id foundationObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:Nil];

    NSAssert( [foundationObject isKindOfClass:[NSDictionary class]], @"config JSON object not in expected dictionary format." );
    
    if( [foundationObject isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary* configPairs = (NSDictionary*)foundationObject;
        
        for (NSString* key in configPairs.allKeys) {
            if( [key isEqualToString:@"foo"] )
            {
                
            }
            else if( [key isEqualToString:@"bar"] )
            {
                
            }
        }
    }
    else
    {
        NSLog(@"config JSON object not in expected dictionary format.");
    }
    
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"getVersion" isEqualToString:call.method]) {
      result([@"PDFNet " stringByAppendingFormat:@"%f", [PTPDFNet GetVersion]]);
  } else if ([@"initialize" isEqualToString:call.method]) {
      NSString *licenseKey = call.arguments[@"licenseKey"];
      [PTPDFNet Initialize:licenseKey];
  } else if ([@"openDocument" isEqualToString:call.method]) {
      NSString *document = call.arguments[@"document"];
      
     
      
      if (document == nil || document.length == 0) {
          // error handling
          return;
      }
      
      // Create and wrap a tabbed controller in a navigation controller.
      self.documentViewController = [[PTDocumentViewController alloc] init];
      
      
      UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.documentViewController];
      
      self.documentViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(topLeftButtonPressed:)];
      
       NSString* config = call.arguments[@"config"];
      
      [self configureDocumentViewController:self.documentViewController withConfig:config];
    
      // Open a file URL.
      NSURL *fileURL = [[NSBundle mainBundle] URLForResource:document withExtension:@"pdf"];
      if ([document containsString:@"://"]) {
          fileURL = [NSURL URLWithString:document];
      } else if ([document hasPrefix:@"/"]) {
          fileURL = [NSURL fileURLWithPath:document];
      }
      
      [self.documentViewController openDocumentWithURL:fileURL];
      
      UIViewController *presentingViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      
      // Show navigation (and tabbed) controller.
      [presentingViewController presentViewController:navigationController animated:YES completion:nil];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)topLeftButtonPressed:(UIBarButtonItem *)barButtonItem
{
    
    [[UIApplication sharedApplication].delegate.window.rootViewController.presentedViewController dismissViewControllerAnimated:YES completion:Nil];
    
}

@end
