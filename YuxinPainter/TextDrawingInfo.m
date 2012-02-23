//
//  TextDrawingInfo.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TextDrawingInfo.h"

@implementation TextDrawingInfo
@synthesize path = _path, text = _text, color = _color, font = _font;

- (id)initWithPath:(UIBezierPath*)p text:(NSString*)t strokeColor:(UIColor*)s font:(UIFont*)f
{
    self = [super init];
    if (self != nil) {
        self.path = p;
        self.text = t;
        self.color = s;
        self.font = f;
    }
    return self;
}
+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:t strokeColor:(UIColor *)s font:(UIFont *)f
{
    return [[TextDrawingInfo alloc] initWithPath:p text:t strokeColor:s font:f];
}

#pragma mark -- Drawable Delegate
- (void)draw
{
    //todo ...
}
@end
