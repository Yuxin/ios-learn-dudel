//
//  FreeHandTool.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FreeHandTool.h"
#import "PathDrawingInfo.h"

@interface FreeHandTool()
@property (nonatomic, strong) UIBezierPath *workingPath;
@property (nonatomic) BOOL settingFirstPoint;
@property (nonatomic) BOOL isDragging;
@property (nonatomic) CGPoint nextSegmentPoint1;
@property (nonatomic) CGPoint nextSegmentPoint2;
@property (nonatomic) CGPoint nextSegmentCp1;
@property (nonatomic) CGPoint nextSegmentCp2;
@end

@implementation FreeHandTool
@synthesize delegate = _delegate;
@synthesize workingPath = _workingPath;
@synthesize settingFirstPoint = _settingFirstPoint;
@synthesize isDragging = _isDragging;
@synthesize nextSegmentCp1 = _nextSegmentCp1, nextSegmentCp2 = _nextSegmentCp2, nextSegmentPoint1 = _nextSegmentPoint1, nextSegmentPoint2 = _nextSegmentPoint2;


static FreeHandTool *_sharedInstance;
+ (FreeHandTool *)sharedFreeHandTool
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

- (void)activate
{
    self.workingPath = [UIBezierPath bezierPath];
    self.settingFirstPoint = YES;
}
- (void)deactivate
{
    // save the workingPath
    PathDrawingInfo *info = [PathDrawingInfo pathDrawingInfoWithPath:self.workingPath 
                                                           fillColor:self.delegate.fillColor 
                                                         strokeColor:self.delegate.strokeColor];
    [self.delegate addDrawable:info];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDragging = YES;
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];
    self.nextSegmentPoint2 = touchPoint;
    self.nextSegmentCp2 = touchPoint;
    
    if (self.workingPath.empty) {
        // first touch
        self.nextSegmentCp1 = touchPoint;
        self.nextSegmentPoint1 = touchPoint;
        [self.workingPath moveToPoint:touchPoint];
    } 
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDragging = NO;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDragging = NO;
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];    
    self.nextSegmentCp2 = touchPoint;
    
    if (self.settingFirstPoint) {
        self.settingFirstPoint = NO;
    } else {
        CGPoint shiftedNextSegmentCp2 = CGPointMake(
                                                    self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x), 
                                                    self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
        [self.workingPath addCurveToPoint: self.nextSegmentPoint2 controlPoint1:self.nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
        self.nextSegmentPoint1 = self.nextSegmentPoint2;
        self.nextSegmentCp1 = self.nextSegmentCp2;
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];    
    if (self.settingFirstPoint) {
        self.nextSegmentCp1 = touchPoint;
    } else {
        self.nextSegmentCp2 = touchPoint;
    }    
}

- (void)drawTemporary
{
    [self.workingPath stroke];
    if (self.isDragging) {
        if (self.settingFirstPoint) {
            UIBezierPath *currentWorkitemSegment = [UIBezierPath bezierPath];
            [currentWorkitemSegment moveToPoint:self.nextSegmentPoint1];
            [currentWorkitemSegment addLineToPoint:self.nextSegmentCp1];
            [self.delegate.strokeColor setStroke];
            [currentWorkitemSegment stroke];
        } else {
            CGPoint shiftedNextSegmentCp2 = CGPointMake(
                                                        self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x),
                                                        self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
            UIBezierPath *currentWorkitemSegment = [UIBezierPath bezierPath];
            [currentWorkitemSegment moveToPoint:self.nextSegmentPoint1];
            [currentWorkitemSegment addCurveToPoint:self.nextSegmentPoint2 controlPoint1:self.nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
            
            [self.delegate.strokeColor setStroke];
            [currentWorkitemSegment stroke];
        }
    }
    
    if (!CGPointEqualToPoint(self.nextSegmentCp2, self.nextSegmentPoint2) && !self.settingFirstPoint) {
        UIBezierPath *currentWorkitemSegment = [UIBezierPath bezierPath];
        [currentWorkitemSegment moveToPoint:self.nextSegmentCp2];
        CGPoint shiftedNextSegmentCp2 = CGPointMake(
                                                    self.nextSegmentPoint2.x + (self.nextSegmentPoint2.x - self.nextSegmentCp2.x), 
                                                    self.nextSegmentPoint2.y + (self.nextSegmentPoint2.y - self.nextSegmentCp2.y));
        [currentWorkitemSegment addLineToPoint:shiftedNextSegmentCp2];
        
        float dashPattern[] = {10.0, 7.0};
        [currentWorkitemSegment setLineDash:dashPattern count:2 phase:0.0];
        [[UIColor redColor] setStroke];
        [currentWorkitemSegment stroke];
        
        UIBezierPath *cpointPath = [UIBezierPath bezierPath];
        [cpointPath moveToPoint:self.nextSegmentCp1];
        [cpointPath addLineToPoint:shiftedNextSegmentCp2];
        [[UIColor blueColor] setStroke];
        [cpointPath stroke];    
    }
    
    UIBezierPath *pointPath = [UIBezierPath bezierPath];
    [pointPath moveToPoint:self.nextSegmentPoint1];
    [pointPath addLineToPoint:self.nextSegmentPoint2];
    [[UIColor greenColor] setStroke];
    [pointPath stroke];
    

}
@end
