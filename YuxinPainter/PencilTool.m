//
//  PencilTool.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PencilTool.h"
#import "Tool.h"
#import "PathDrawingInfo.h"

@interface PencilTool() 
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *paths;
@end

@implementation PencilTool
@synthesize delegate = _delegate;
@synthesize trackingTouches = _trackingTouches, startPoints = _startPoints, paths = _paths;

static PencilTool *_sharedInstance = nil;
+ (PencilTool *)sharedPencilTool
{
    @synchronized(self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[self alloc] init];
        }
    }    
    return _sharedInstance;    
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _trackingTouches = [[NSMutableArray alloc] init];
        _startPoints = [[NSMutableArray alloc] init];
        _paths = [[NSMutableArray alloc] init];        
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
    [self.paths removeAllObjects];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        
        [self.trackingTouches addObject:touch];
        CGPoint location = [touch locationInView:touchedView];
        [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound;
        [path moveToPoint:location];
        [path setLineWidth:self.delegate.strokeWidth];
        [path addLineToPoint:location];
        [self.paths addObject:path];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self deactivate];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            UIBezierPath *path = [self.paths objectAtIndex:touchIndex];
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path 
                                                                   fillColor:[UIColor clearColor] 
                                                                 strokeColor:self.delegate.strokeColor];
            [self.delegate addDrawable:info];
            
            [self.trackingTouches removeObjectAtIndex:touchIndex];
            [self.startPoints removeObjectAtIndex:touchIndex];
            [self.paths removeObjectAtIndex:touchIndex];
        }
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            UIBezierPath *path = [self.paths objectAtIndex:touchIndex];
            [path addLineToPoint:location];
        }
    }
}

- (void)drawTemporary
{
    for (UIBezierPath *path in self.paths) {
        [self.delegate.strokeColor setStroke];
        [path stroke];
    }
}
@end
