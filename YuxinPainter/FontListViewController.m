//
//  FontListViewController.m
//  YuxinPainter
//
//  Created by 杨裕欣 on 12-2-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontListViewController.h"

@interface FontListViewController ()
@end

@implementation FontListViewController
@synthesize fonts = _fonts, seletedFontName = _seletedFontName, container = _container;

#pragma mark -- UIView Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *familyNames = [UIFont familyNames];
    NSMutableArray *fontNames = [NSMutableArray array];
    for (NSString *family in familyNames) {
        [fontNames addObjectsFromArray:[UIFont fontNamesForFamilyName:family]];
    }
    self.fonts = [fontNames sortedArrayUsingSelector:@selector(compare:)];
}

- (void)viewDidAppear:(BOOL)animated   
{
    [super viewDidAppear:YES];
    NSLog(@"%@", self.tableView);
    NSLog(@"%d", self.tableView.style);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fonts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Font Name Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Font Name Cell"];
    }
    cell.textLabel.text = [self.fonts objectAtIndex:indexPath.row];
    return cell;
}
@end
