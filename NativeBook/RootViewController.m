//
//  RootViewController.m
//  TestSwipe2
//
//  Created by Jean-André Santoni on 10/07/13.
//  Copyright (c) 2013 Jean-André Santoni. All rights reserved.
//

#import "RootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Cordova/CDVViewController.h>
int current;

@interface RootViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIView* pullviewtop;
@property (nonatomic) BOOL triggered;
@property (nonatomic) BOOL dragging;
@end

@implementation RootViewController

@synthesize masterViewController, webView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.masterViewController = [[MasterViewController alloc] init];
    [self addChildViewController:self.masterViewController];
    [self.view addSubview:self.masterViewController.tableView];
    [self.masterViewController didMoveToParentViewController:self];

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(256, 0, 768, 1004)];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    for (UIView *view in [[[self.webView subviews] objectAtIndex:0] subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://cv.kivutar.me"]]];
    
    self.webView.scrollView.delegate = self;
    
    // Top pull view
    self.pullviewtop = [[UIView alloc] initWithFrame:CGRectMake(0, -80, 768, 80)];
    self.pullviewtop.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    UIImageView* tapimgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tap.png"]];
    tapimgview.frame = CGRectMake(236, 20, 40, 40);
    [self.pullviewtop addSubview:tapimgview];
    UILabel* chapternumber = [[UILabel alloc] initWithFrame:CGRectMake(296, 20, 200, 20)];
    chapternumber.text = @"Passer au chapitre précédant";
    chapternumber.textColor = [UIColor grayColor];
    chapternumber.font = [UIFont boldSystemFontOfSize:14];
    chapternumber.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:chapternumber];
    UILabel* chaptername = [[UILabel alloc] initWithFrame:CGRectMake(296, 40, 200, 20)];
    chaptername.text = [chapters objectAtIndex:current];
    chaptername.textColor = [UIColor whiteColor];
    chaptername.font = [UIFont systemFontOfSize:14];
    chaptername.backgroundColor = [UIColor clearColor];
    [self.pullviewtop addSubview:chaptername];
    [self.webView addSubview:self.pullviewtop];

    self.triggered = NO;
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
    if (self.triggered && scrollView.contentOffset.y >= -80 && !self.dragging) {
        scrollView.contentOffset = CGPointMake(0, -80);
    }
    if (scrollView.contentOffset.y < -80 && self.dragging) {
        self.triggered = YES;
        [UIView animateWithDuration:0.15 animations:^{
            CGRect fr = self.pullviewtop.frame;
            fr.origin.y = 0;
            self.pullviewtop.frame = fr;
        }];
    }
    if (scrollView.contentOffset.y > -80 && scrollView.contentOffset.y < 0 && self.triggered) {
        self.triggered = NO;
        [UIView animateWithDuration:0.15 animations:^{
            CGRect fr = self.pullviewtop.frame;
            fr.origin.y = -80;
            self.pullviewtop.frame = fr;
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.dragging = NO;
}

@end
