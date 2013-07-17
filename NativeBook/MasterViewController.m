//
//  MasterViewController.m
//  TestSwipe2
//
//  Created by Jean-André Santoni on 16/07/13.
//  Copyright (c) 2013 Jean-André Santoni. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "UIMasterViewCell.h"
#import <QuartzCore/QuartzCore.h>
NSArray* chapters;

@interface MasterViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.frame = CGRectMake(0, 0, 256, 1004);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [[[UIView alloc] init] autorelease];
    self.tableView.backgroundColor = [UIColor colorWithRed:.13 green:.13 blue:.13 alpha:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MasterCellIdentifier = @"MasterCell";

    UIMasterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MasterCellIdentifier];
    
    if (cell == nil) {
        cell = [[[UIMasterViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterCellIdentifier] autorelease];
    }

    cell.primaryLabel.text = [chapters objectAtIndex:indexPath.row];

    UIImageView* activeimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active.png"]];
    activeimgview.frame = CGRectMake(216, 0, 40, 40);
    cell.selectedBackgroundView = activeimgview;
    [activeimgview release];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[colors objectAtIndex:indexPath.row]];
}

@end
