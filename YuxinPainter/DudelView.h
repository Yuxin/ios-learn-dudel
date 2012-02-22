//
//  DudelView.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DudelView;

@protocol DudelViewDelegate
- (void)drawTemporary;

@end

@interface DudelView : UIView
@property (nonatomic, strong) NSMutableArray *drawbles;
@property (nonatomic, strong) IBOutlet id <DudelViewDelegate> delegate;
@end
