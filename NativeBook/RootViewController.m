//
//  RootViewController.m
//  TestSwipe2
//
//  Created by Jean-André Santoni on 10/07/13.
//  Copyright (c) 2013 Jean-André Santoni. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
int current;

@interface RootViewController () <UIScrollViewDelegate>

@end

@implementation RootViewController

@synthesize masterViewController, cdvViewController, triggeredtop, triggeredbottom;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.masterViewController = [[MasterViewController alloc] init];
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.tableView];
    [self.masterViewController didMoveToParentViewController:self];

    self.cdvViewController = [CDVViewController new];
    self.cdvViewController.view.frame = CGRectMake(0, 0, 768, 1004);
    self.cdvViewController.view.backgroundColor = [UIColor clearColor];
    self.cdvViewController.webView.backgroundColor = [UIColor clearColor];
    self.cdvViewController.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    for (UIView *view in [[[self.cdvViewController.webView subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    self.cdvViewController.webView.scrollView.delegate = self;
    [self.view addSubview:self.cdvViewController.view];
    
    // Top pull view
    self.pullviewtop = [[UIView alloc] initWithFrame:CGRectMake(0, -80, 768, 80)];
    self.pullviewtop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    UIImageView* tapimgviewtop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap.png"]];
    tapimgviewtop.frame = CGRectMake(236, 20, 40, 40);
    [self.pullviewtop addSubview:tapimgviewtop];
    UILabel* chapternumbertop = [[UILabel alloc] initWithFrame:CGRectMake(296, 20, 200, 20)];
    chapternumbertop.text = @"Passer au chapitre précédant";
    chapternumbertop.textColor = [UIColor grayColor];
    chapternumbertop.font = [UIFont boldSystemFontOfSize:14];
    chapternumbertop.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:chapternumbertop];
    UILabel* chapternametop = [[UILabel alloc] initWithFrame:CGRectMake(296, 40, 200, 20)];
    if (current > 0) chapternametop.text = [chapters objectAtIndex:current-1];
    chapternametop.textColor = [UIColor whiteColor];
    chapternametop.font = [UIFont systemFontOfSize:14];
    chapternametop.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:chapternametop];
    [self.cdvViewController.webView addSubview:self.pullviewtop];
    
    // Bottom pull view
    NSLog(@"%f",self.cdvViewController.webView.scrollView.contentSize.height);
    self.pullviewbottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.cdvViewController.webView.scrollView.frame.size.height, 768, 80)];
    self.pullviewbottom.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.pullviewbottom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    UIImageView* tapimgviewbottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap.png"]];
    tapimgviewbottom.frame = CGRectMake(236, 20, 40, 40);
    [self.pullviewbottom addSubview:tapimgviewbottom];
    UILabel* chapternumberbottom = [[UILabel alloc] initWithFrame:CGRectMake(296, 20, 200, 20)];
    chapternumberbottom.text = @"Passer au chapitre précédant";
    chapternumberbottom.textColor = [UIColor grayColor];
    chapternumberbottom.font = [UIFont boldSystemFontOfSize:14];
    chapternumberbottom.backgroundColor = [UIColor clearColor];
    [self.pullviewbottom addSubview:chapternumberbottom];
    UILabel* chapternamebottom = [[UILabel alloc] initWithFrame:CGRectMake(296, 40, 200, 20)];
    if (current <= 13) chapternamebottom.text = [chapters objectAtIndex:current+1];
    chapternamebottom.textColor = [UIColor whiteColor];
    chapternamebottom.font = [UIFont systemFontOfSize:14];
    chapternamebottom.backgroundColor = [UIColor clearColor];
    [self.pullviewbottom addSubview:chapternamebottom];
    [self.cdvViewController.webView addSubview:self.pullviewbottom];

    self.triggeredtop = NO;
    self.triggeredbottom = NO;
    self.dragging = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:.44 green:.46 blue:.49 alpha:1];
    self.view.autoresizesSubviews = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.dragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (current > 0) {
        if (self.triggeredtop && scrollView.contentOffset.y >= -80 && !self.dragging) {
            scrollView.contentOffset = CGPointMake(0, -80);
        }
        if (scrollView.contentOffset.y < -80 && self.dragging) {
            self.triggeredtop = YES;
            [UIView animateWithDuration:0.15 animations:^{
                CGRect fr = self.pullviewtop.frame;
                fr.origin.y = 0;
                self.pullviewtop.frame = fr;
            }];
        }
        if (scrollView.contentOffset.y > -80 && scrollView.contentOffset.y < 0 && self.triggeredtop) {
            self.triggeredtop = NO;
            [UIView animateWithDuration:0.15 animations:^{
                CGRect fr = self.pullviewtop.frame;
                fr.origin.y = -80;
                self.pullviewtop.frame = fr;
            }];
        }
    }
    if (current <= 13) {
        float frh = scrollView.frame.size.height;
        if (self.triggeredbottom && scrollView.contentOffset.y + frh <= scrollView.contentSize.height + 80 && !self.dragging) {
            scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height - frh + 80);
        }
        if (scrollView.contentOffset.y + frh > scrollView.contentSize.height + 80 && self.dragging) {
            self.triggeredbottom = YES;
            [UIView animateWithDuration:0.15 animations:^{
                CGRect fr = self.pullviewbottom.frame;
                fr.origin.y = frh - 80;
                self.pullviewbottom.frame = fr;
            }];
        }
        if (scrollView.contentOffset.y + frh < scrollView.contentSize.height + 80 && scrollView.contentOffset.y + 1024 > scrollView.contentSize.height && self.triggeredbottom) {
            self.triggeredbottom = NO;
            [UIView animateWithDuration:0.15 animations:^{
                CGRect fr = self.pullviewbottom.frame;
                fr.origin.y = frh;
                self.pullviewbottom.frame = fr;
            }];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.dragging = NO;
}

@end
