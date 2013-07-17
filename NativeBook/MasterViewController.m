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

    self.tableView.frame = CGRectMake(0, 0, 256, 1024);
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
    
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.0 green:0.64 blue:0.80 alpha:1];
    cell.selectedBackgroundView = myBackView;
    [myBackView release];
    
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
    if (indexPath.row ==  0) { [cell setBackgroundColor:[UIColor colorWithRed:.80 green:.00 blue:.47 alpha:1]]; }
    if (indexPath.row ==  1) { [cell setBackgroundColor:[UIColor colorWithRed:.00 green:.61 blue:.59 alpha:1]]; }
    if (indexPath.row ==  2) { [cell setBackgroundColor:[UIColor colorWithRed:.42 green:.39 blue:.25 alpha:1]]; }
    if (indexPath.row ==  3) { [cell setBackgroundColor:[UIColor colorWithRed:.83 green:.73 blue:.08 alpha:1]]; }
    if (indexPath.row ==  4) { [cell setBackgroundColor:[UIColor colorWithRed:.97 green:.11 blue:.37 alpha:1]]; }
    if (indexPath.row ==  5) { [cell setBackgroundColor:[UIColor colorWithRed:.44 green:.46 blue:.49 alpha:1]]; }
    if (indexPath.row ==  6) { [cell setBackgroundColor:[UIColor colorWithRed:.56 green:.79 blue:.93 alpha:1]]; }
    if (indexPath.row ==  7) { [cell setBackgroundColor:[UIColor colorWithRed:.21 green:.23 blue:.23 alpha:1]]; }
    if (indexPath.row ==  8) { [cell setBackgroundColor:[UIColor colorWithRed:.32 green:.51 blue:.62 alpha:1]]; }
    if (indexPath.row ==  9) { [cell setBackgroundColor:[UIColor colorWithRed:.94 green:.66 blue:.67 alpha:1]]; }
    if (indexPath.row == 10) { [cell setBackgroundColor:[UIColor colorWithRed:.73 green:.72 blue:.37 alpha:1]]; }
    if (indexPath.row == 11) { [cell setBackgroundColor:[UIColor colorWithRed:.93 green:.47 blue:.40 alpha:1]]; }
    if (indexPath.row == 12) { [cell setBackgroundColor:[UIColor colorWithRed:.93 green:.77 blue:.12 alpha:1]]; }
    if (indexPath.row == 13) { [cell setBackgroundColor:[UIColor colorWithRed:.09 green:.72 blue:.65 alpha:1]]; }
}

@end
