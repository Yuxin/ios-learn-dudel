//
//  TextTool.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

@interface TextTool : NSObject<Tool>
+ (TextTool *)sharedTextTool;
@end
