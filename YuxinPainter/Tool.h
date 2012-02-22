//
//  Tool.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Drawable.h"

@protocol Drawable;
@protocol ToolDelegate;

@protocol Tool
@property (nonatomic, weak) id <ToolDelegate> delegate;

- (void)activate;
- (void)deactivate;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)drawTemporary;
@end


@protocol ToolDelegate

- (void)addDrawable:(id <Drawable>)d;
- (UIView *)viewForUseWithTool:(id <Tool>)t;
- (UIColor *)strokeColor;
- (UIColor *)fillColor;
- (CGFloat)strokeWidth;

@end