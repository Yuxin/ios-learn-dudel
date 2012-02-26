//
//  PopoverContentViewController.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverContentViewController
@property (nonatomic, weak) UIPopoverController *container;
@property (nonatomic, copy) NSString *popoverName;
@end
