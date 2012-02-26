//
//  FileList.h
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileList : NSObject
+ (FileList *)sharedFileList;
@property (nonatomic, strong) NSMutableArray *allFiles;
@property (nonatomic, copy) NSString *currentFile;

- (void)deleteCurrentFile;
- (void)renameFile:(NSString *)oldFileName to:(NSString *)newFileName;
- (void)renameCurrentName:(NSString *)newFileName;
- (NSString *)createAndSelectNewUntitledFile;
@end
