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
@synthesize fonts = _fonts, seletedFontName = _seletedFontName, container = _container, popoverName = _popoverName;


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
}

#pragma mark -- UITableView
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
    cell.textLabel.font = [UIFont fontWithName:[self.fonts objectAtIndex:indexPath.row] size:17.0];
    if ([self.seletedFontName isEqualToString:[self.fonts objectAtIndex:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger oldSelectedRow = [self.fonts indexOfObject:self.seletedFontName];
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:oldSelectedRow inSection:0];
    
    if (oldSelectedRow != indexPath.row) {
        self.seletedFontName = [self.fonts objectAtIndex:indexPath.row];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:oldIndexPath, indexPath, nil] 
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FontListControllerDidSelect" object:self];
    return nil;
}
@end
