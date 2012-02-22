//
//  EllipseTool.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EllipseTool.h"
#import "PathDrawingInfo.h"

@interface EllipseTool()
@property (nonatomic, strong) NSMutableArray *startPoints;
@property (nonatomic, strong) NSMutableArray *trackingTouches;
@property (nonatomic, strong) NSMutableArray *paths;
@end

@implementation EllipseTool
@synthesize delegate = _delegate;
@synthesize startPoints = _startPoints, trackingTouches = _trackingTouches, paths = _paths;

static EllipseTool *_sharedInstance;
+ (EllipseTool *)sharedRectangleTool
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
        _trackingTouches = [[NSMutableArray alloc] init]; 
        _paths = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)activate
{
    
}
- (void)deactivate
{
    [self.startPoints removeAllObjects];
    [self.trackingTouches removeAllObjects];    
    [self.paths removeAllObjects];        
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        
        [self.trackingTouches addObject:touch];
        CGPoint location = [touch locationInView:touchedView];
        [self.startPoints addObject:[NSValue valueWithCGPoint:location]];
        [self.paths addObject: [UIBezierPath bezierPath]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];
            
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x, startPoint.y, location.x - startPoint.x, location.y - startPoint.y)];
            [self.paths replaceObjectAtIndex:touchIndex withObject:path];
        }
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];    
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [self.trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            CGPoint startPoint = [[self.startPoints objectAtIndex:touchIndex] CGPointValue];            
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x, startPoint.y, location.x - startPoint.x, location.y - startPoint.y)];
            
            PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:path 
                                                                   fillColor:self.delegate.fillColor
                                                                 strokeColor:self.delegate.strokeColor];
            [self.delegate addDrawable:info];
        }
    }
    [self deactivate];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self deactivate];
}

- (void)drawTemporary
{
    for (UIBezierPath *path in self.paths) {
        [[UIColor redColor] setStroke];
        [[UIColor grayColor] setFill];
        [path stroke];
        [path fill];
    }
}
@end