//
//  MainViewController.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "Tool.h"
#import "DudelView.h"
#import "PencilTool.h"
#import "LineTool.h"
#import "RectangleTool.h"
#import "EllipseTool.h"
#import "FreeHandTool.h"
#import "TextTool.h"
#import "FontListViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController() <ToolDelegate, DudelViewDelegate, MFMailComposeViewControllerDelegate, UIPopoverControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawDotsItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawLineItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawRectangleItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawEllipseItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawBezierItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawTextItem;
@property (strong, nonatomic) IBOutlet DudelView *dudelView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) UIPopoverController *currentPopoverViewController;

@property (strong, nonatomic) id <Tool> currentTool;

@end

@implementation MainViewController
@synthesize drawDotsItem;
@synthesize drawBezierItem;
@synthesize drawTextItem;
@synthesize dudelView;
@synthesize toolbar;
@synthesize drawLineItem;
@synthesize drawRectangleItem;
@synthesize drawEllipseItem;
@synthesize currentTool = _currentTool;
@synthesize fillColor = _fillColor, strokeColor = _strokeColor, strokeWidth = _strokeWidth, font = _font;
@synthesize currentPopoverViewController = _currentPopoverViewController;

- (void)setCurrentTool:(id<Tool>)currentTool
{
    [self.currentTool deactivate];
    if (_currentTool != currentTool) {
        _currentTool = currentTool;
        _currentTool.delegate = self;
    }
    [_currentTool activate];
    [self.dudelView setNeedsDisplay];
}

- (void)deselectAllBarItems
{
    self.drawDotsItem.image = [UIImage imageNamed:@"button_cdots.png"];
    self.drawLineItem.image = [UIImage imageNamed:@"button_line.png"];
    self.drawRectangleItem.image = [UIImage imageNamed:@"button_rectangle.png"];
    self.drawEllipseItem.image = [UIImage imageNamed:@"button_ellipse.png"];
    self.drawBezierItem.image = [UIImage imageNamed:@"button_bezier.png"];
    self.drawTextItem.image = [UIImage imageNamed:@"button_text.png"];    
}

- (IBAction)touchDrawDotsItem:(id)sender {
    [self deselectAllBarItems];
    self.currentTool = [PencilTool sharedPencilTool];
    self.drawDotsItem.image = [UIImage imageNamed:@"button_cdots_selected.png"];
}


- (IBAction)touchDrawLineItem:(id)sender {
    [self deselectAllBarItems];    
    self.currentTool = [LineTool sharedLineTool];
    self.drawLineItem.image = [UIImage imageNamed:@"button_line_selected.png"];
}

- (IBAction)touchDrawRectangleItem:(id)sender {
    [self deselectAllBarItems];    
    self.currentTool = [RectangleTool sharedRectangleTool];    
    self.drawRectangleItem.image = [UIImage imageNamed:@"button_rectangle_selected.png"];
}

- (IBAction)touchDrawEclipseItem:(id)sender {
    [self deselectAllBarItems];    
    self.currentTool = [EllipseTool sharedRectangleTool];
    self.drawEllipseItem.image = [UIImage imageNamed:@"button_ellipse_selected.png"];    
}
- (IBAction)touchDrawBezierItem:(id)sender {
    [self deselectAllBarItems];    
    self.currentTool = [FreeHandTool sharedFreeHandTool];
    self.drawBezierItem.image = [UIImage imageNamed:@"button_bezier_selected.png"];
}
- (IBAction)touchDrawTextItem:(id)sender {
    [self deselectAllBarItems];
    self.currentTool = [TextTool sharedTextTool];
    self.drawTextItem.image = [UIImage imageNamed:@"button_text_selected.png"];
}


- (void)setupPopoverViewController:(id <PopoverContentViewController>)contentController WithPopoverName: (NSString *)popoverName
{
    self.currentPopoverViewController = [[UIPopoverController alloc] initWithContentViewController:(UIViewController *)contentController];
    self.currentPopoverViewController.delegate = self;    

    contentController.container = self.currentPopoverViewController;       
    contentController.popoverName = popoverName;
    
    self.currentPopoverViewController.popoverContentSize = CGSizeMake(320.0f, 480.0f);
}
- (IBAction)touchFontNameItem:(id)sender {
    FontListViewController *fontListViewController = [[FontListViewController alloc] initWithNibName:@"FontListViewController" bundle:nil];
    fontListViewController.seletedFontName = self.font.fontName;
    [self setupPopoverViewController:fontListViewController WithPopoverName:@"FontListViewControler"];
    
    [self.currentPopoverViewController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontListControllerDidSelect:) name:@"FontListControllerDidSelect" object:fontListViewController];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentTool touchesBegan:touches withEvent:event];
    [self.dudelView setNeedsDisplay];    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentTool touchesCancelled:touches withEvent:event];
    [self.dudelView setNeedsDisplay];    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentTool touchesEnded:touches withEvent:event];
    [self.dudelView setNeedsDisplay];    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentTool touchesMoved:touches withEvent:event];
    [self.dudelView setNeedsDisplay];
}


- (IBAction)sendPDF:(id)sender {
    NSMutableData *pdfData = [NSMutableData data];
    
    UIGraphicsBeginPDFContextToData(pdfData, self.dudelView.bounds, nil);
    UIGraphicsBeginPDFPage();
    
    [self.dudelView drawRect: self.dudelView.bounds];
    
    UIGraphicsEndPDFContext();
    
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController addAttachmentData:pdfData mimeType:@"application/pdf" fileName:@"myPainter.pdf"];
    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.splitViewController.delegate = self;
    
    self.currentTool = [PencilTool sharedPencilTool];
    
    self.fillColor = [UIColor lightGrayColor];
    self.strokeColor = [UIColor blackColor];
    self.strokeWidth = 2.0f;
    self.font = [UIFont systemFontOfSize:24.0f];
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"Untitled.dudledoc"];
    [self loadFromFile:fileName];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:[UIApplication sharedApplication]];
}

- (void)viewDidUnload
{
    [self setDrawDotsItem:nil];
    [self setDrawLineItem:nil];
    [self setDrawBezierItem:nil];
    [self setDrawDotsItem:nil];
    [self setDrawLineItem:nil];
    [self setDrawRectangleItem:nil];
    [self setDrawEllipseItem:nil];
    [self setDudelView:nil];
    [self setDrawTextItem:nil];
    [self setToolbar:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -- Tool Delegate
- (void)addDrawable:(id <Drawable>)d
{
    [self.dudelView.drawbles addObject:d];
    [dudelView setNeedsDisplay];
}
- (UIView *)viewForUseWithTool:(id <Tool>)t
{
    return self.view;
}

#pragma mark -- DudelView Delegate
- (void)drawTemporary
{
    [self.currentTool drawTemporary];
}

#pragma mark -- Mail Compose Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -- UISplitViewController Delegate
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc
{
    NSMutableArray *newItems = [self.toolbar.items mutableCopy];
    [newItems insertObject:barButtonItem atIndex:0];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [newItems insertObject:spacer atIndex:1];
    [self.toolbar setItems:newItems animated:YES];
    barButtonItem.title = @"My Dudles";
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *newItems = [self.toolbar.items mutableCopy];
    [newItems removeObject:barButtonItem];
    [newItems removeObjectAtIndex:0];
    [self.toolbar setItems:newItems animated:YES];
}


- (void)splitViewController: (UISplitViewController*)svc popoverController: (UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
    if (self.currentPopoverViewController != nil) {
        [self.currentPopoverViewController dismissPopoverAnimated:YES];
        [self handleDismissedPopoverController:self.currentPopoverViewController];
    }
    self.currentPopoverViewController = pc;
}

#pragma mark -- UIPopoverViewController

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self handleDismissedPopoverController:popoverController];
}


- (void)handleDismissedPopoverController:(UIPopoverController*)popoverController {
    if ([popoverController.contentViewController isMemberOfClass:[FontListViewController class]]) {
        // this is the font list, grab the new selection
        FontListViewController *flc = (FontListViewController *)popoverController.contentViewController;
        self.font = [UIFont fontWithName:flc.seletedFontName size:self.font.pointSize];
    }
    //    else if ([popoverController.contentViewController isMemberOfClass:[FontSizeController class]]) {
    //        FontSizeController *fsc = (FontSizeController *)popoverController.contentViewController;
    //        self.font = fsc.font;
    //    } else if ([popoverController.contentViewController isMemberOfClass:[StrokeWidthController class]]) {
    //        StrokeWidthController *swc = (StrokeWidthController *)popoverController.contentViewController;
    //        self.strokeWidth = swc.strokeWidth;
    //    } else if ([popoverController.contentViewController isMemberOfClass:[StrokeColorController class]]) {
    //        StrokeColorController *scc = (StrokeColorController *)popoverController.contentViewController;
    //        self.strokeColor = scc.selectedColor;
    //    } else if ([popoverController.contentViewController isMemberOfClass:[FillColorController class]]) {
    //        FillColorController *fcc = (FillColorController *)popoverController.contentViewController;
    //        self.fillColor = fcc.selectedColor;
    //    }
    self.currentPopoverViewController = nil;
}


#pragma mark -- Notification Center Callback
- (void)fontListControllerDidSelect:(NSNotification *)notification
{
    FontListViewController *fontListViewController = [notification object];
    UIPopoverController *popoverController = fontListViewController.container;
    [popoverController dismissPopoverAnimated:YES];
    [self handleDismissedPopoverController:popoverController];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    NSLog(@"App will terminate");
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[dirs objectAtIndex:0] stringByAppendingPathComponent:@"Untitled.dudledoc"];
    [self saveCurrentToFile:filename];
}


#pragma mark -- File Saver
- (BOOL)saveCurrentToFile:(NSString *)fileName
{
    return [NSKeyedArchiver archiveRootObject:self.dudelView.drawbles toFile:fileName];
}

- (BOOL)loadFromFile:(NSString *)fileName
{
    id root = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    if (root) {
        self.dudelView.drawbles = root;
        [self.dudelView setNeedsDisplay];
    }
    return (root != nil);
}
@end
