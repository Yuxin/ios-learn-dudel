//
//  DudelView.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DudelView.h"
#import "Drawable.h"

@implementation DudelView
@synthesize drawbles = _drawbles;
@synthesize delegate = _delegate;

- (NSMutableArray *)drawbles
{
    if (_drawbles == nil) {
        _drawbles = [[NSMutableArray alloc] init];
    }
    return _drawbles;
}

- (void)drawRect:(CGRect)rect
{
    for (id <Drawable> d in self.drawbles) {
        [d draw];
    }
    [self.delegate drawTemporary];
}


@end
