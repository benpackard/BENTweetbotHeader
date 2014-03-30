//
//  BENMainController.m
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import "BENMainController.h"

#import "BENMainView.h"

@interface BENMainController ()

@property BENMainView *mainView;

@end

@implementation BENMainController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBar.translucent = NO;
	UIColor *offWhite = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
	self.navigationController.navigationBar.barTintColor = offWhite;
	self.title = @"Ben Packard";

	self.view.backgroundColor = [UIColor darkGrayColor];
	
	self.mainView = [[BENMainView alloc] init];
	self.mainView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.view addSubview:self.mainView];
	NSDictionary *views = @{@"main":self.mainView};
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[main]|" options:0 metrics:nil views:views]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[main]|" options:0 metrics:nil views:views]];
	
	self.mainView.scrollView.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//	if (scrollView.contentOffset.y > 0) return;
	
//	NSLog(@"\n\ncontentoffset is %f", scrollView.contentOffset.y);
	self.mainView.headerCenterYConstraint.constant = MIN(scrollView.contentOffset.y / 2.0f, 0);
	CGFloat nativeHeight = self.mainView.headerImage.image.size.height;
	self.mainView.headerHeightConstraint.constant = MAX(nativeHeight +  -scrollView.contentOffset.y, nativeHeight);
//self.mainView.headerCenterYConstraint.multiplier = scrollView.contentOffset.y / 2.0f;
//	NSLog(@"constraint is %f", self.mainView.headerCenterYConstraint.constant);
//	NSLog(@"equals %f", scrollView.contentOffset.y / 2);
//	//scale the header view as the scrollview is pulled down (but don't let it shrink when pushed up)
//	NSInteger navbarOffset = 64;
//	NSInteger heightConstraintValue = 243;
//	NSInteger additionalWidthValue = 47;
//	self.headerHeightConstraint.constant = MAX(heightConstraintValue + -self.scrollView.contentOffset.y - navbarOffset, heightConstraintValue);
//	self.headerWidthConstriant.constant = additionalWidthValue + MAX(-self.scrollView.contentOffset.y - navbarOffset, 0);
}

- (void)dealloc
{
//	self.scrollView.delegate = nil;
}

@end
