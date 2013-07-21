//
//  UIMasterViewCell.m
//  TestSwipe2
//
//  Created by Jean-André Santoni on 16/07/13.
//  Copyright (c) 2013 Jean-André Santoni. All rights reserved.
//

#import "UIMasterViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIMasterViewCell

@synthesize primaryLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 246, 40)];
        primaryLabel.font = [UIFont fontWithName:@"Vdnbrcupyyaykuzyblvvwuiwntx" size:14];
        primaryLabel.backgroundColor = [UIColor clearColor];
        primaryLabel.textColor = [UIColor whiteColor];
        primaryLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25];
        primaryLabel.shadowOffset = CGSizeMake(0.0, -1.0);
        [self.contentView addSubview:primaryLabel];
    }
    return self;
}

@end
