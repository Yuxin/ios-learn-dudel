
//
//  FileList.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FileList.h"

@implementation FileList
static FileList *_sharedInstance;
+ (FileList *)sharedFileList
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}

@synthesize allFiles = _allFiles, currentFile = _curentFile;

#define DEFAULT_FILENAME_KEY @"default_file_name"
static NSString *FileListChanged = @"FileListChangedNotification";

- (id)init
{
    if (self = [super init]) {
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dirPath = [dirs objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL];
        NSArray *sortedFiles = [[files pathsMatchingExtensions:[NSArray arrayWithObject:@"dudledoc"]] sortedArrayUsingSelector:@selector(compare:)];
        
        self.allFiles = [NSMutableArray array];
        for (NSString *file in sortedFiles) {
            [self.allFiles addObject: [dirPath stringByAppendingPathComponent:file]];
        }
        
        self.currentFile = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULT_FILENAME_KEY];
        if ([self.allFiles count] == 0) {
            [self createAndSelectNewUntitledFile];
        } else if (![self.allFiles containsObject:self.currentFile]){
            self.currentFile = [self.allFiles objectAtIndex:0];
        }
    }
    return self;    
}
- (void)setCurrentFile:(NSString *)fileName
{
    if (![fileName isEqualToString:_curentFile]) {
        _curentFile = fileName;
        [[NSUserDefaults standardUserDefaults] setObject:fileName forKey:DEFAULT_FILENAME_KEY];
        [[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];
    }
}



- (void)deleteCurrentFile
{
    if (self.currentFile) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentFile error:NULL];
        
        NSUInteger fileNameIndex = [self.allFiles indexOfObject:self.currentFile];
        if (fileNameIndex != NSNotFound) {
            [self.allFiles removeObjectAtIndex:fileNameIndex];
            
            if ([self.allFiles count] == 0) {
                [self createAndSelectNewUntitledFile];
            } else {
                if ([self.allFiles count] == fileNameIndex) {
                    fileNameIndex --;
                }
                self.currentFile = [self.allFiles objectAtIndex:fileNameIndex];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];        
    }
}
- (void)renameFile:(NSString *)oldFileName to:(NSString *)newFileName
{
    [[NSFileManager defaultManager] moveItemAtPath:oldFileName toPath:newFileName error:NULL];
    
    if ([oldFileName isEqualToString:self.currentFile]) {
        self.currentFile = newFileName;
    }
    
    NSUInteger fileNameIndex = [self.allFiles indexOfObject:oldFileName];
    if (fileNameIndex != NSNotFound) {
        [self.allFiles replaceObjectAtIndex:fileNameIndex withObject:newFileName];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];            
}
- (void)renameCurrentName:(NSString *)newFileName
{
    [self renameFile:self.currentFile to:newFileName];
}
- (NSString *)createAndSelectNewUntitledFile
{
    NSString *defaultfileName = [NSString stringWithFormat:@"Dudle %@.dudledoc", [NSDate date]];
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileName = [[dirs objectAtIndex:0] stringByAppendingPathComponent:defaultfileName];
    [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    [self.allFiles addObject:fileName];
    [self.allFiles sortUsingSelector:@selector(compare:)];
    self.currentFile = fileName;
    [[NSNotificationCenter defaultCenter] postNotificationName:FileListChanged object:self];             
    return self.currentFile;
}
@end
