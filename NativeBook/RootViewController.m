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

@interface RootViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, readwrite, strong) UITapGestureRecognizer *tapGRtop;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer *tapGRbottom;
@end

@implementation RootViewController

@synthesize masterViewController, cdvViewController, triggeredtop, triggeredbottom;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // CordovaView
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
    
    // MasterView (menu)
    self.masterViewController = [[MasterViewController alloc] init];
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.tableView];
    [self.masterViewController didMoveToParentViewController:self];
    
    // Top pull view
    self.pullviewtop = [[UIView alloc] initWithFrame:CGRectMake(0, -80, 768, 80)];
    self.pullviewtop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    UIImageView* tapimgviewtop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap.png"]];
    tapimgviewtop.frame = CGRectMake(236, 20, 40, 40);
    [self.pullviewtop addSubview:tapimgviewtop];
    UILabel* chapternumbertop = [[UILabel alloc] initWithFrame:CGRectMake(296, 20, 200, 20)];
    chapternumbertop.text = @"Passer au chapitre précédant";
    chapternumbertop.textColor = [UIColor grayColor];
    chapternumbertop.font = [UIFont italicSystemFontOfSize:14];
    chapternumbertop.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:chapternumbertop];
    self.chapternametop = [[UILabel alloc] initWithFrame:CGRectMake(296, 40, 200, 20)];
    if (current > 0) self.chapternametop.text = [chapters objectAtIndex:current-1];
    self.chapternametop.textColor = [UIColor whiteColor];
    self.chapternametop.font = [UIFont boldSystemFontOfSize:14];
    self.chapternametop.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:self.chapternametop];
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
    chapternumberbottom.text = @"Passer au chapitre suivant";
    chapternumberbottom.textColor = [UIColor grayColor];
    chapternumberbottom.font = [UIFont italicSystemFontOfSize:14];
    chapternumberbottom.backgroundColor = [UIColor clearColor];
    [self.pullviewbottom addSubview:chapternumberbottom];
    self.chapternamebottom = [[UILabel alloc] initWithFrame:CGRectMake(296, 40, 200, 20)];
    if (current < [chapters count] - 1) self.chapternamebottom.text = [chapters objectAtIndex:current+1];
    self.chapternamebottom.textColor = [UIColor whiteColor];
    self.chapternamebottom.font = [UIFont boldSystemFontOfSize:14];
    self.chapternamebottom.backgroundColor = [UIColor clearColor];
    [self.pullviewbottom addSubview:self.chapternamebottom];
    [self.cdvViewController.webView addSubview:self.pullviewbottom];
    
    self.tapGRtop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.tapGRtop.delegate = self;
    [self.pullviewtop addGestureRecognizer:self.tapGRtop];
    [self.tapGRtop release];
    
    self.tapGRbottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.tapGRbottom.delegate = self;
    [self.pullviewbottom addGestureRecognizer:self.tapGRbottom];
    [self.tapGRbottom release];
    
    self.view.backgroundColor = [UIColor colorWithRed:.44 green:.46 blue:.49 alpha:1];
    self.view.autoresizesSubviews = YES;

    self.triggeredtop = NO;
    self.triggeredbottom = NO;
    self.dragging = NO;
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
    if (current < [chapters count] - 1) {
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

- (void)handleGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    int next = self.triggeredbottom ? current + 1 : current -1;
    
    NSString* call = [NSString stringWithFormat:@"loadpage(%i)", next];
    
    [self.cdvViewController.webView stringByEvaluatingJavaScriptFromString:call];
    
    if (self.triggeredtop) {
        self.triggeredtop = NO;
        [UIView animateWithDuration:0.15 animations:^{
            CGRect fr = self.pullviewtop.frame;
            fr.origin.y = -80;
            self.pullviewtop.frame = fr;
        }];
    }
    
    if (self.triggeredbottom) {
        self.triggeredbottom = NO;
        [UIView animateWithDuration:0.15 animations:^{
            CGRect fr = self.pullviewbottom.frame;
            fr.origin.y = self.cdvViewController.webView.scrollView.frame.size.height;
            self.pullviewbottom.frame = fr;
        }];
    }

    if (next > 0) self.chapternametop.text = [chapters objectAtIndex:next-1];
    if (next < [chapters count]-1) self.chapternamebottom.text = [chapters objectAtIndex:next+1];
    
    NSIndexPath *ip=[NSIndexPath indexPathForRow:next inSection:0];
    [self.masterViewController.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    current = next;
}

@end
