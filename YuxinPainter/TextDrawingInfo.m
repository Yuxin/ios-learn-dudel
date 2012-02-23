//
//  TextDrawingInfo.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TextDrawingInfo.h"
#import <CoreText/CoreText.h>

static NSString *fontFaceNameFromString(NSString *attrData) {
    NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
    NSString *faceName = nil;
    if ([attributeDataScanner scanUpToString:@"face=\"" intoString:NULL]) {
        [attributeDataScanner scanString:@"face=\"" intoString:NULL];
        if ([attributeDataScanner scanUpToString:@"\"" intoString:&faceName]) {
            return faceName;
        }
    }
    return nil;
}
static CGFloat fontSizeFromString(NSString *attrData) {
    NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
    NSString *sizeString = nil;
    if ([attributeDataScanner scanUpToString:@"size=\"" intoString:NULL]) {
        [attributeDataScanner scanString:@"size=\"" intoString:NULL];
        if ([attributeDataScanner scanUpToString:@"\"" intoString:&sizeString]) {
            return [sizeString floatValue];
        }
    }
    return 0.0;
}
static UIColor *fontColorFromString(NSString *attrData) {
//    NSScanner *attributeDataScanner = [NSScanner scannerWithString:attrData];
//    NSString *sizeString = nil;
//    if ([attributeDataScanner scanUpToString:@"color=\"" intoString:NULL]) {
//        [attributeDataScanner scanString:@"color=\"" intoString:NULL];
//        if ([attributeDataScanner scanUpToString:@"\"" intoString:&sizeString]) {
//            return [sizeString floatValue];
//        }
//    }
//    return 0.0;
    return nil;
}

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

- (NSAttributedString *)attributedStringFromMarkup: (NSString *)markup
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSString *nextTextChunk = nil;
    NSScanner *markupScanner = [NSScanner scannerWithString:markup];
    
    CGFloat fontSize = 0.0f;
    NSString *fontFace;
    UIColor *fontColor;
    while (![markupScanner isAtEnd]) {
        [markupScanner scanUpToString:@"<" intoString:&nextTextChunk];
        [markupScanner scanString:@"<" intoString:NULL];
        if ([nextTextChunk length] > 0) {
            // render texts
            CTFontRef currentFont = CTFontCreateWithName((__bridge CFStringRef)(fontFace ? fontFace : self.font.fontName), 
                                                         fontSize ? fontSize : self.font.pointSize, NULL);
            UIColor *color = fontColor ? fontColor : self.color;
            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   (id)color.CGColor, kCTForegroundColorAttributeName,
                                   (__bridge id)currentFont, kCTFontAttributeName, nil];
            NSAttributedString *pieceOfString = [[NSAttributedString alloc] initWithString:nextTextChunk attributes:attrs];
            [attrString appendAttributedString:pieceOfString];
            CFRelease(currentFont);
            nextTextChunk = nil;
        }
        NSString *elementData;
        [markupScanner scanUpToString:@">" intoString:&elementData];
        [markupScanner scanString:@">" intoString:NULL];
        if (elementData) {
            NSLog(@"encountered element data %@", elementData);
            if ([elementData length] > 3 && [[elementData substringToIndex:4] isEqual:@"font"]) {
                fontFace = fontFaceNameFromString(elementData);
                fontSize = fontSizeFromString(elementData);
                fontColor = fontColorFromString(elementData);
            } else if ([elementData length] > 4 && [[elementData substringToIndex:5] isEqual:@"/font"]) {
                // reset all values
                fontSize = 0.0;
                fontFace = nil;
                fontColor = nil;
            }
        }
    }
    return attrString;
}

#pragma mark -- Drawable Delegate
- (void)draw
{
    CGContextRef context = UIGraphicsGetCurrentContext();
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
//    [attrString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
//                       value:(id)self.color.CGColor 
//                       range:NSMakeRange(0, [self.text length])];
    NSAttributedString *attrString = [self attributedStringFromMarkup:self.text];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), self.path.CGPath, NULL);
    CFRelease(framesetter);
    
    if (frame) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, self.path.bounds.origin.y);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -(self.path.bounds.origin.y + self.path.bounds.size.height));
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
        CFRelease(frame);
    }
    
}
@end
