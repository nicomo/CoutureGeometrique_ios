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
@property (nonatomic, retain) UIImageView* splashImageView;
@property (nonatomic, strong) UIButton* burger;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer* tapGRtop;
@property (nonatomic, readwrite, strong) UITapGestureRecognizer* tapGRbottom;
@end

@implementation RootViewController

@synthesize masterViewController, cdvViewController, triggeredtop, triggeredbottom, triggeredburger, activeview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // SplashImageView
    self.splashImageView = [[UIImageView alloc] init];
    
    // MasterView (menu)
    self.masterViewController = [[MasterViewController alloc] init];
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.tableView];
    [self.masterViewController didMoveToParentViewController:self];
    
    // CordovaView
    self.cdvViewController = [CDVViewController new];
    self.cdvViewController.view.frame = CGRectMake(0, 0, 778, 1004);
    self.cdvViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    self.cdvViewController.view.backgroundColor = [UIColor colorWithRed:.44 green:.46 blue:.49 alpha:1];
    self.cdvViewController.view.layer.masksToBounds = NO;
    self.cdvViewController.view.layer.shadowOffset = CGSizeMake(0, 0);
    self.cdvViewController.view.layer.shadowRadius = 10;
    self.cdvViewController.view.layer.shadowOpacity = 0.5;
    self.cdvViewController.view.layer.shouldRasterize = YES;
    self.cdvViewController.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cdvViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.cdvViewController.view.bounds].CGPath;
    self.cdvViewController.webView.backgroundColor = [UIColor clearColor];
    for (UIView *view in [[[self.cdvViewController.webView subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    self.cdvViewController.webView.scrollView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewDidFinishLoad:)
                                                 name:CDVPageDidLoadNotification object:self.cdvViewController.webView];
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
    
    // Burger
    self.burger = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.burger setImage:[UIImage imageNamed:@"burger.png"] forState:UIControlStateNormal];
    self.burger.frame = CGRectMake(0, 0, 75, 75);
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        self.burger.hidden = YES;
    }
    [self.burger addTarget:self action:@selector(burgerPushed:) forControlEvents:UIControlEventTouchUpInside];
    [self.cdvViewController.webView addSubview:self.burger];
    [self.cdvViewController.webView bringSubviewToFront:self.burger];
    
    // Active view
    self.activeview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"active.png"]];
    self.activeview.frame = CGRectMake(-40, 40*current, 40, 40);
    [self.cdvViewController.webView addSubview:self.activeview];
    [self.cdvViewController.webView bringSubviewToFront:self.activeview];
    
    self.tapGRtop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnPullView:)];
    self.tapGRtop.delegate = self;
    [self.pullviewtop addGestureRecognizer:self.tapGRtop];
    [self.tapGRtop release];
    
    self.tapGRbottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnPullView:)];
    self.tapGRbottom.delegate = self;
    [self.pullviewbottom addGestureRecognizer:self.tapGRbottom];
    [self.tapGRbottom release];
    
    self.view.backgroundColor = [UIColor colorWithRed:.44 green:.46 blue:.49 alpha:1];
    self.view.autoresizesSubviews = YES;

    self.triggeredtop = NO;
    self.triggeredbottom = NO;
    self.triggeredburger = NO;
    self.dragging = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    UIImage *defaultImage;
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])){
        defaultImage = [UIImage imageNamed:@"Default-Landscape.png"];
    } else {
        defaultImage = [UIImage imageNamed:@"Default-Portrait.png"];
    }
    self.splashImageView = [[UIImageView alloc] initWithImage:defaultImage];
    [self.view addSubview:self.splashImageView];
}

- (void) webViewDidFinishLoad:(UIWebView*) theWebView {
    [UIView animateWithDuration:1.0f animations:^(void) {
        [self.splashImageView setAlpha:0.0];
    } completion:^(BOOL finished){
        [self.splashImageView removeFromSuperview];
    }];
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

- (void)handleTapOnPullView:(UITapGestureRecognizer *)gestureRecognizer
{
    int next = self.triggeredbottom ? current + 1 : current -1;
    
    NSString* call = [NSString stringWithFormat:@"loadpage(%i, %i)", next, self.triggeredtop];
    
    [UIView animateWithDuration:0.35 animations:^{
        CGRect fr = self.activeview.frame;
        fr.origin.y = 40*next;
        self.activeview.frame = fr;
        
        if (self.triggeredtop) {
            self.triggeredtop = NO;
            CGRect fr = self.pullviewtop.frame;
            fr.origin.y = -80;
            self.pullviewtop.frame = fr;
            [self.cdvViewController.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        if (self.triggeredbottom) {
            self.triggeredbottom = NO;
            CGRect fr = self.pullviewbottom.frame;
            fr.origin.y = self.cdvViewController.webView.scrollView.frame.size.height;
            self.pullviewbottom.frame = fr;
            [self.cdvViewController.webView.scrollView setContentOffset:CGPointMake(0, self.cdvViewController.webView.scrollView.contentOffset.y-80) animated:YES];
        }
        
    } completion:^(BOOL finished){
        [self.cdvViewController.webView stringByEvaluatingJavaScriptFromString:call];
        if (next > 0) self.chapternametop.text = [chapters objectAtIndex:next-1];
        if (next < [chapters count]-1) self.chapternamebottom.text = [chapters objectAtIndex:next+1];
        NSIndexPath *ip=[NSIndexPath indexPathForRow:next inSection:0];
        [self.masterViewController.tableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionNone];
        current = next;
    }];
}

- (void)burgerPushed:(id)sender
{
    if (! self.triggeredburger) {
        [UIView animateWithDuration:0.35 animations:^{
            CGRect fr2 = self.cdvViewController.view.frame;
            fr2.origin.x = 256;
            self.cdvViewController.view.frame = fr2;
            self.cdvViewController.webView.scrollView.userInteractionEnabled = NO;
            self.triggeredburger = YES;
            if (self.triggeredtop) {
                self.triggeredtop = NO;
                CGRect fr3 = self.pullviewtop.frame;
                fr3.origin.y = -80;
                self.pullviewtop.frame = fr3;
                [self.cdvViewController.webView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            if (self.triggeredbottom) {
                self.triggeredbottom = NO;
                CGRect fr3 = self.pullviewbottom.frame;
                fr3.origin.y = self.cdvViewController.webView.scrollView.frame.size.height;
                self.pullviewbottom.frame = fr3;
                [self.cdvViewController.webView.scrollView setContentOffset:CGPointMake(0, self.cdvViewController.webView.scrollView.contentOffset.y-80) animated:YES];
            }
        }];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            CGRect fr2 = self.cdvViewController.view.frame;
            fr2.origin.x = 0;
            self.cdvViewController.view.frame = fr2;
            self.cdvViewController.webView.scrollView.userInteractionEnabled = YES;
            self.triggeredburger = NO;
        }];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toOrientation duration:(NSTimeInterval)duration
{
    if (toOrientation == UIInterfaceOrientationPortrait ||
        toOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self.burger setHidden:NO];
    } else if (toOrientation == UIInterfaceOrientationLandscapeLeft ||
        toOrientation == UIInterfaceOrientationLandscapeRight) {
        [self.burger setHidden:YES];
        if (self.triggeredburger) {
            self.cdvViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
            self.cdvViewController.webView.scrollView.userInteractionEnabled = YES;
        } else {
            self.cdvViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        }
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        if (self.triggeredtop) {
            self.triggeredtop = NO;
            CGRect fr3 = self.pullviewtop.frame;
            fr3.origin.y = -80;
            self.pullviewtop.frame = fr3;
        }
        if (self.triggeredbottom) {
            self.triggeredbottom = NO;
            CGRect fr3 = self.pullviewbottom.frame;
            fr3.origin.y = self.cdvViewController.webView.scrollView.frame.size.height;
            self.pullviewbottom.frame = fr3;
        }
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait ||
        fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (self.triggeredburger) {
            self.cdvViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
            self.cdvViewController.webView.scrollView.userInteractionEnabled = YES;
            self.triggeredburger = NO;
        }
    }
}

@end
