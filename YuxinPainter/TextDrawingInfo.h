//
//  TextDrawingInfo.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"

@interface TextDrawingInfo : NSObject<Drawable>
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIBezierPath *path;

- (id)initWithPath:(UIBezierPath*)p text:(NSString*)t strokeColor:(UIColor*)s font:(UIFont*)f;
+ (id)textDrawingInfoWithPath:(UIBezierPath *)p text:t strokeColor:(UIColor *)s font:(UIFont *)f;
@end
