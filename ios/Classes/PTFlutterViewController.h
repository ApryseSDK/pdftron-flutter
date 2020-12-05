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

@property (nonatomic, assign) BOOL showNavButton;

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, assign, getter=isThumbnailEditingEnabled) BOOL thumbnailEditingEnabled;
@property (nonatomic, assign, getter=isContinuousAnnotationEditing) BOOL continuousAnnotationEditing;

@property (nonatomic, copy, nullable) NSString* annotationAuthor;

- (void)initViewerSettings;
- (void)applyViewerSettings;

- (void)setLeadingNavButtonIcon:(NSString *)leadingNavButtonIcon;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
