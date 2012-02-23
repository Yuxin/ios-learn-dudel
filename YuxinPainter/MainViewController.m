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
#import <MessageUI/MessageUI.h>

@interface MainViewController() <ToolDelegate, DudelViewDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawDotsItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawLineItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawRectangleItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawEllipseItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawBezierItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawTextItem;
@property (strong, nonatomic) IBOutlet DudelView *dudelView;

@property (strong, nonatomic) id <Tool> currentTool;

@end

@implementation MainViewController
@synthesize drawDotsItem;
@synthesize drawBezierItem;
@synthesize drawTextItem;
@synthesize dudelView;
@synthesize drawLineItem;
@synthesize drawRectangleItem;
@synthesize drawEllipseItem;
@synthesize currentTool = _currentTool;
@synthesize fillColor = _fillColor, strokeColor = _strokeColor, strokeWidth = _strokeWidth, font = _font;

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
    self.currentTool = [PencilTool sharedPencilTool];
    
    self.fillColor = [UIColor lightGrayColor];
    self.strokeColor = [UIColor blackColor];
    self.strokeWidth = 2.0f;
    self.font = [UIFont systemFontOfSize:24.0f];
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

@end
