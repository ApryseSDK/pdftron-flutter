#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTFlutterViewController : PTDocumentViewController

@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, strong) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;

//viewer options

// long-press menu customization
@property (nonatomic, assign, getter=isLongPressMenuEnabled) BOOL longPressMenuEnabled;
@property (nonatomic, copy, nullable) NSArray<NSString*>* longPressMenuItems;
@property (nonatomic, copy, nullable) NSArray<NSString*>* overrideLongPressMenuBehavior;

// annotation selection menu customization
@property (nonatomic, copy, nullable) NSArray<NSNumber *> *hideAnnotMenuTools;
@property (nonatomic, copy, nullable) NSArray<NSString*>* annotationMenuItems;
@property (nonatomic, copy, nullable) NSArray<NSString*>* overrideAnnotationMenuBehavior;

- (void)initViewerSettings;
- (void)applyViewerSettings;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
