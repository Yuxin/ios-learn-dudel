//
//  TextTool.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TextTool.h"
#import "TextDrawingInfo.h"

static CGFloat distance_between_two_points(const CGPoint p1, const CGPoint p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
}

@interface TextTool() <UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) UIBezierPath *completedPath;
@property (nonatomic) CGFloat viewSlideDistance;
@end

@implementation TextTool

@synthesize delegate = _delegate;
@synthesize trackingTouches = _trackingTouches, startPoints = _startPoints, completedPath = _completedPath, viewSlideDistance = _viewSlideDistance;

static TextTool *_sharedInstance;
+ (TextTool *)sharedTextTool
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}

-(id)init
{
    self = [super init];
    if (self != nil) {
        self.trackingTouches = [NSMutableArray array];
        self.startPoints = [NSMutableArray array];
    }
    return self;
}

- (void)activate
{
    
}
- (void)deactivate
{
    [self.trackingTouches removeAllObjects];
    [self.startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    [touchedView endEditing: YES];
    UITouch *touch = [[event allTouches] anyObject];
    [self.trackingTouches addObject:touch];
    
    CGPoint location = [touch locationInView:touchedView];
    [self.startPoints addObject:[NSValue valueWithCGPoint: location]];
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            [self.trackingTouches removeAllObjects];
            [self.startPoints removeAllObjects];
            
            if (distance_between_two_points(startPoint, endPoint) < 5.0) return;
            
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
            self.completedPath = [UIBezierPath bezierPathWithRect:rect];
            
            UIView *backgoundShade = [[UIView alloc] initWithFrame:touchedView.bounds];
            backgoundShade.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            backgoundShade.tag = 10000;
            backgoundShade.userInteractionEnabled = NO;
            [touchedView addSubview:backgoundShade];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:rect];
            textView.delegate = self;
            [touchedView addSubview:textView];
            
            
            // NSNotificationCenter
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];            
            
            
            CGFloat keyboardHeight = 0;
            UIInterfaceOrientation orientation = ((UIViewController*)(self.delegate)).interfaceOrientation;
            
            if (UIInterfaceOrientationIsPortrait(orientation)) {
                keyboardHeight = 264;
            } else {
                keyboardHeight = 352;
            }
            CGFloat maxRectY = rect.origin.y + rect.size.height;
            CGFloat availableHeight = touchedView.bounds.size.height - keyboardHeight;
            if (maxRectY > availableHeight) {
                self.viewSlideDistance = maxRectY - availableHeight;
            } else {
                self.viewSlideDistance = 0;
            }
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)drawTemporary
{
    if (self.completedPath) {
        [self.delegate.strokeColor setStroke];
        [self.completedPath stroke];
    } else {
        UIView *touchedView = [self.delegate viewForUseWithTool:self];
        for (UITouch *touch in self.trackingTouches) {
            NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x - startPoint.x, endPoint.y - startPoint.y);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            [self.delegate.strokeColor setStroke];
            [path stroke];
        }
    }
}

- (void)keyboardWillShow:(id)sender
{
    UIInterfaceOrientation orientation = ((UIViewController *)(self.delegate)).interfaceOrientation;
    [UIView beginAnimations:@"view slide up" context:NULL];
    UIView *view = [self.delegate viewForUseWithTool:self];
    CGRect frame = view.frame;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x -= self.viewSlideDistance;
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame.origin.x += self.viewSlideDistance;
            break;
        case UIInterfaceOrientationPortrait:
            frame.origin.y -= self.viewSlideDistance;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y += self.viewSlideDistance;
            break; 
        default:
            break;
    }
    view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(id)sender
{
    UIInterfaceOrientation orientation = ((UIViewController *)(self.delegate)).interfaceOrientation;
    [UIView beginAnimations:@"view slide up" context:NULL];
    UIView *view = [self.delegate viewForUseWithTool:self];
    CGRect frame = view.frame;
    switch (orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x += self.viewSlideDistance;
            break;
        case UIInterfaceOrientationLandscapeRight:
            frame.origin.x -= self.viewSlideDistance;
            break;
        case UIInterfaceOrientationPortrait:
            frame.origin.y += self.viewSlideDistance;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y -= self.viewSlideDistance;
            break; 
        default:
            break;
    }
    view.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - TextView Delegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    // add drawable...
    TextDrawingInfo *drawInfo = [TextDrawingInfo textDrawingInfoWithPath:self.completedPath text:textView.text strokeColor:self.delegate.strokeColor font:self.delegate.font];
    [self.delegate addDrawable:drawInfo];
    
    self.completedPath = nil;
    [[textView.superview viewWithTag:10000] removeFromSuperview];
    [textView resignFirstResponder];
    [textView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
