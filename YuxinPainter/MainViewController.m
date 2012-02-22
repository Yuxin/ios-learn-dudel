//
//  MainViewController.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawDotsItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawLineItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawRectangleItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawEllipseItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawBezierItem;
@end

@implementation MainViewController
@synthesize drawDotsItem;
@synthesize drawBezierItem;
@synthesize drawLineItem;
@synthesize drawRectangleItem;
@synthesize drawEllipseItem;

- (void)deselectAllBarItems
{
    self.drawDotsItem.image = [UIImage imageNamed:@"button_cdots.png"];
    self.drawLineItem.image = [UIImage imageNamed:@"button_line.png"];
    self.drawRectangleItem.image = [UIImage imageNamed:@"button_rectangle.png"];
    self.drawEllipseItem.image = [UIImage imageNamed:@"button_ellipse.png"];
    self.drawBezierItem.image = [UIImage imageNamed:@"button_bezier.png"];
}

- (IBAction)touchDrawDotsItem:(id)sender {
    [self deselectAllBarItems];
    self.drawDotsItem.image = [UIImage imageNamed:@"button_cdots_selected.png"];
}


- (IBAction)touchDrawLineItem:(id)sender {
    [self deselectAllBarItems];    
    self.drawLineItem.image = [UIImage imageNamed:@"button_line_selected.png"];
}

- (IBAction)touchDrawRectangleItem:(id)sender {
    [self deselectAllBarItems];    
    self.drawRectangleItem.image = [UIImage imageNamed:@"button_rectangle_selected.png"];
}

- (IBAction)touchDrawEclipseItem:(id)sender {
    [self deselectAllBarItems];    
    self.drawEllipseItem.image = [UIImage imageNamed:@"button_ellipse_selected.png"];    
}
- (IBAction)touchDrawBezierItem:(id)sender {
    [self deselectAllBarItems];    
    self.drawBezierItem.image = [UIImage imageNamed:@"button_bezier_selected.png"];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setDrawDotsItem:nil];
    [self setDrawLineItem:nil];
    [self setDrawBezierItem:nil];
    [self setDrawDotsItem:nil];
    [self setDrawLineItem:nil];
    [self setDrawRectangleItem:nil];
    [self setDrawEllipseItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
