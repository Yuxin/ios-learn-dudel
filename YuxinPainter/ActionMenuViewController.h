//
//  ActionMenuViewController.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SelectedActionType {
    NoAction = -1,
    NewDocument,
    RenameDocument,
    DeleteDocument,
    EmailDudelDoc,
    EmailPdf,
    OpenPdfElsewhere,
    ShowAppInfo
} SelectedActionType;


@interface ActionMenuViewController : UITableViewCell
@property (nonatomic) SelectedActionType selectedActionType;
@property (nonatomic, weak) UIPopoverController *container;

@end
