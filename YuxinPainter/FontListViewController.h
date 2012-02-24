//
//  FontListViewController.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontListViewController : UITableViewController
@property (nonatomic, strong) NSArray *fonts;
@property (nonatomic, copy) NSString *seletedFontName;
@property (nonatomic, strong) UIPopoverController *container;
@end
