//---------------------------------------------------------------------------------------
// Copyright (c) 2001-2020 by PDFTron Systems Inc. All Rights Reserved.
// Consult legal.txt regarding legal and license information.
//---------------------------------------------------------------------------------------

#import "MyFlutterDocumentController.h"

@interface MyFlutterDocumentController ()

@end

@implementation MyFlutterDocumentController

// Do the conversion on the new page when the page number changes
- (void)pdfViewCtrl:(PTPDFViewCtrl *)pdfViewCtrl pageNumberChangedFrom:(int)oldPageNumber To:(int)newPageNumber
{
    /* Uncomment this to do it when the page changes instead of over the whole doc in `didOpenDocument`
     * You will also need to remove the code in `didOpenDocument`
    [self.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        [self convertActionsToGoToForDocument:doc onPageNumber:newPageNumber];
    } error:nil];
     */
}


// Do the conversion over the whole document as soon as it's opened
- (void)didOpenDocument
{
    [super didOpenDocument];
    [self.pdfViewCtrl DocLock:YES withBlock:^(PTPDFDoc * _Nullable doc) {
        PTPageIterator* itr;
        int pageNumber = 1;
        for (itr = [doc GetPageIterator: 1]; [itr HasNext]; [itr Next])
        {
            [self convertActionsToGoToForDocument:doc onPageNumber:pageNumber];
        }
    } error:nil];
}

-(void)convertActionsToGoToForDocument:(PTPDFDoc*)doc onPageNumber:(int)pageNumber
{
    PTPage* page = [doc GetPage:pageNumber];
    int num_annots = [page GetNumAnnots];
    int i = 0;
    for (i=0; i<num_annots; ++i)
    {
        PTAnnot* annot = [page GetAnnot: i];
        if (![annot IsValid]) continue;
        if (annot.extendedAnnotType == PTExtendedAnnotTypeLink) {
            PTLink *link = [[PTLink alloc] initWithAnn:annot];
            PTAction *action = [link GetAction];
            
            PTActionType actionType = [action GetType];
            if (actionType == e_ptJavaScript) {
                PTObj *js = [[action GetSDFObj] FindObj:@"JS"];
                NSString * const actionString = [js GetAsPDFText];
                NSLog(@"action string: %@", actionString); // likely something like `this.pageNum=201`
                
                // Regex approach (unused in this example)
                NSError *error = NULL;
                NSRegularExpression *regex = [NSRegularExpression
                                              regularExpressionWithPattern:@"this.pageNum=(.*)"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:&error];
                
                [regex enumerateMatchesInString:actionString options:0 range:NSMakeRange(0, [actionString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    NSRange pageNumberRange = [match rangeAtIndex:1];
                    NSString *pageNumberString = [actionString substringWithRange:pageNumberRange];
                    NSLog(@"page number string: %@", pageNumberString);
                }];
                
                // Substring approach (used here)
                NSArray<NSString*> *actionArray = [actionString componentsSeparatedByString:@"="];
                NSString *pageNumber = actionArray[1];
                int pageNum = [pageNumber intValue]+1; // page is offset by 1
                PTPage *destinationPage = [doc GetPage:pageNum];
                PTDestination *destination = [PTDestination CreateFit:destinationPage];
                PTAction *goToAction = [PTAction CreateGoto:destination];
                [link SetAction:goToAction];
            }
        }
    }
}

@end
