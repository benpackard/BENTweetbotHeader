//
//  BENMainView.m
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import "BENMainView.h"

#import "BENProfileView.h"

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
		
		[self createBlurredImage];
		[self.scrollView addSubview:self.blurredImage];
		
		self.profileView = [[BENProfileView alloc] init];
		self.profileView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.scrollView addSubview:self.profileView];
		
		self.contentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Content"]];
		self.contentImage.backgroundColor = [UIColor yellowColor];
		self.contentImage.translatesAutoresizingMaskIntoConstraints = NO;
		[self.scrollView addSubview:self.contentImage];
		
		NSDictionary *views = @{@"scrollView":self.scrollView, @"header":self.profileView, @"content":self.contentImage, @"background":self.headerImage};
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[scrollView]|" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:0 metrics:nil views:views]];
		
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header][content]|" options:0 metrics:nil views:views]];
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[header]|" options:0 metrics:nil views:views]];
		[self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[content]|" options:0 metrics:nil views:views]];
		
		for (UIView *view in @[self.profileView, self.contentImage])
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
		
		//the header image's center is aligned with the profile view's
		[self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerImage
																	 attribute:NSLayoutAttributeCenterX
																	 relatedBy:NSLayoutRelationEqual
																		toItem:self.profileView
																	 attribute:NSLayoutAttributeCenterX
																	multiplier:1
																	  constant:0]];
		
		self.headerCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.headerImage
																	attribute:NSLayoutAttributeCenterY
																	relatedBy:NSLayoutRelationEqual
																	   toItem:self.profileView
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
		
		//maintain the aspect ratio of the image as its height changes, give or take half a point
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
		
		//the blurred image's position and size should always match the original
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurredImage
														 attribute:NSLayoutAttributeCenterX
														 relatedBy:NSLayoutRelationEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeCenterX
														multiplier:1
														  constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurredImage
														 attribute:NSLayoutAttributeCenterY
														 relatedBy:NSLayoutRelationEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeCenterY
														multiplier:1
														  constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurredImage
														 attribute:NSLayoutAttributeWidth
														 relatedBy:NSLayoutRelationEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeWidth
														multiplier:1
														  constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:self.blurredImage
														 attribute:NSLayoutAttributeHeight
														 relatedBy:NSLayoutRelationEqual
															toItem:self.headerImage
														 attribute:NSLayoutAttributeHeight
														multiplier:1
														  constant:0]];
	}
    return self;
}

- (void)createBlurredImage
{
    CIImage *inputImage = [CIImage imageWithCGImage:self.headerImage.image.CGImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //First, we'll use CIAffineClamp to prevent black edges on our blurred image
    //CIAffineClamp extends the edges off to infinity (check the docs, yo)
    CGAffineTransform transform = CGAffineTransformIdentity;
    CIFilter *clampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [clampFilter setValue:inputImage forKeyPath:kCIInputImageKey];
    [clampFilter setValue:[NSValue valueWithBytes:&transform objCType:@encode(CGAffineTransform)] forKeyPath:@"inputTransform"];
    CIImage *clampedImage = [clampFilter outputImage];
    
    //Next, create some darkness
    CIFilter* blackGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
    CIColor* black = [CIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    [blackGenerator setValue:black forKey:@"inputColor"];
    CIImage* blackImage = [blackGenerator valueForKey:@"outputImage"];
    
    //Apply that black
    CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [compositeFilter setValue:blackImage forKey:@"inputImage"];
    [compositeFilter setValue:clampedImage forKey:@"inputBackgroundImage"];
    CIImage *darkenedImage = [compositeFilter outputImage];
    
    //Third, blur the image
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:@(12) forKey:@"inputRadius"];
    [blurFilter setValue:darkenedImage forKey:kCIInputImageKey];
    CIImage *blurredImage = [blurFilter outputImage];
    
    CGImageRef cgimg = [context createCGImage:blurredImage fromRect:inputImage.extent];
	self.blurredImage = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:cgimg]];
	self.blurredImage.translatesAutoresizingMaskIntoConstraints = NO;
    CGImageRelease(cgimg);
}

@end
