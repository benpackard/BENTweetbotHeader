//
//  BENMainView.m
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import "BENMainView.h"

#import "BENHeaderView.h"

@interface BENMainView ()

@property BENHeaderView *headerView;
@property UIImageView *contentImage;

@end

@implementation BENMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		UIColor *offWhite = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
		
		self.scrollView = [[UIScrollView alloc] init];
		self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
		self.scrollView.backgroundColor = offWhite;
		self.scrollView.alwaysBounceVertical = YES;
		[self addSubview:self.scrollView];
		
		self.headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.JPG"]];
		self.headerImage.translatesAutoresizingMaskIntoConstraints = NO;
		[self.scrollView addSubview:self.headerImage];
		
		self.headerView = [[BENHeaderView alloc] init];
		self.headerView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.scrollView addSubview:self.headerView];
		
		self.contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content"]];
		self.contentImage.backgroundColor = [UIColor yellowColor];
		self.contentImage.translatesAutoresizingMaskIntoConstraints = NO;
		[self.scrollView addSubview:self.contentImage];
		
		NSDictionary *views = @{@"scrollView":self.scrollView, @"header":self.headerView, @"content":self.contentImage, @"background":self.headerImage};
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
		
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header][content]|" options:0 metrics:nil views:views]];
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[header]|" options:0 metrics:nil views:views]];
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[content]|" options:0 metrics:nil views:views]];
		
		for (UIView *view in @[self.headerView, self.contentImage])
		{
			[self addConstraint:[NSLayoutConstraint constraintWithItem:view
															 attribute:NSLayoutAttributeWidth
															 relatedBy:NSLayoutRelationEqual
																toItem:self
															 attribute:NSLayoutAttributeWidth
															multiplier:1
															  constant:0]];
		}
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerImage
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationGreaterThanOrEqual
															toItem:self
														 attribute:NSLayoutAttributeWidth
														multiplier:1
														  constant:0]];
		
		//the header image's center is vertically aligned with the header view's
		self.headerCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.headerImage
																	attribute:NSLayoutAttributeCenterY
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self.headerView
																	attribute:NSLayoutAttributeCenterY
																   multiplier:1
																	 constant:0];
		[self.scrollView addConstraint:self.headerCenterYConstraint];
		
		//the imageview's height is set to the image's native value - this is actually the default, but we need a constraint to play with
		self.headerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerImage
																   attribute:NSLayoutAttributeHeight
																   relatedBy:NSLayoutRelationEqual
																	  toItem:nil
																   attribute:NSLayoutAttributeNotAnAttribute
																  multiplier:1
																	constant:self.headerImage.image.size.height];
		[self.scrollView addConstraint:self.headerHeightConstraint];
		
		//maintain the aspect ratio of the image as its height changes
		CGFloat aspectRatio = self.headerImage.image.size.width / self.headerImage.image.size.height;
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerImage
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationGreaterThanOrEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeHeight
														multiplier:aspectRatio
														  constant:-0.5]];
		
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.headerImage
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationLessThanOrEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeHeight
														multiplier:aspectRatio
														  constant:0.5]];
    }
    return self;
}

@end
