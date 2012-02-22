//
//  LineTool.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface LineTool : NSObject <Tool>
+ (LineTool *)sharedLineTool;
@end
