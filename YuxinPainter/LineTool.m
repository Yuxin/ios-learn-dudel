//
//  LineTool.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LineTool.h"
#import "Tool.h"
#import "PathDrawingInfo.h"

@interface LineTool()
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@end

@implementation LineTool
@synthesize delegate = _delegate;
@synthesize startPoints = _startPoints, paths = _paths, trackingTouches = _trackingTouches;

static LineTool *_sharedInstance;
+ (LineTool *)sharedLineTool
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
        _startPoints = [[NSMutableArray alloc] init];
        _paths = [[NSMutableArray alloc] init];
        _trackingTouches = [[NSMutableArray alloc] init]; 
    }
    return self;
}

- (void)activate
{
    
}
- (void)deactivate
{
    [self.startPoints removeAllObjects];
    [self.paths removeAllObjects];
    [self.trackingTouches removeAllObjects];    
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
    UIView *touchedView = [self.delegate viewForUseWithTool:self];    
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:startPoint];
            [path addLineToPoint:location];
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path 
                                                                   fillColor:self.delegate.fillColor
                                                                 strokeColor:self.delegate.strokeColor];
            [self.delegate addDrawable:info];
        }
    }
    [self deactivate];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            UIBezierPath *path = [self.paths objectAtIndex:touchIndex];
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            [path removeAllPoints];
            [path moveToPoint:startPoint];
            [path addLineToPoint:location];
        }
    }
}

- (void)drawTemporary
{
    for (UIBezierPath *path in self.paths) {
        [[UIColor redColor] setStroke];
        [path stroke];
    }
}


@end
