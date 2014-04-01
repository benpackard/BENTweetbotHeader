//
//  BENHeaderView.m
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import "BENProfileView.h"

@implementation BENProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		UIColor *offWhite = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
		
		UIImageView *profileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProfilePic"]];
		profileImage.translatesAutoresizingMaskIntoConstraints = NO;
		[self addSubview:profileImage];
		
		UILabel *nameLabel = [[UILabel alloc] init];
		nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
		nameLabel.backgroundColor = [UIColor clearColor];
		nameLabel.textColor = offWhite;
		nameLabel.text = @"Ben Packard";
		nameLabel.font = [UIFont boldSystemFontOfSize:17];
		[self addSubview:nameLabel];
		
		UILabel *handleLabel = [[UILabel alloc] init];
		handleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		handleLabel.backgroundColor = [UIColor clearColor];
		handleLabel.textColor = offWhite;
		handleLabel.text = @"@BenPackard";
		handleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
		[self addSubview:handleLabel];
		
		UILabel *infoLabel = [[UILabel alloc] init];
		infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
		infoLabel.backgroundColor = [UIColor clearColor];
		infoLabel.textColor = offWhite;
		infoLabel.text = @"Pizza website magnate.";
		infoLabel.font = [UIFont systemFontOfSize:15];
		[self addSubview:infoLabel];
		
		NSDictionary *views = @{@"pic":profileImage, @"name":nameLabel, @"handle":handleLabel, @"info":infoLabel};
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[pic]" options:0 metrics:nil views:views]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[name][handle]-[info]-|" options:0 metrics:nil views:views]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel
														 attribute:NSLayoutAttributeBottom
														 relatedBy:NSLayoutRelationEqual
															toItem:profileImage
														 attribute:NSLayoutAttributeCenterY
														multiplier:1
														  constant:0]];
		[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[pic]-[name]" options:0 metrics:nil views:views]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:handleLabel
														 attribute:NSLayoutAttributeLeft
														 relatedBy:NSLayoutRelationEqual
															toItem:nameLabel
														 attribute:NSLayoutAttributeLeft
														multiplier:1
														  constant:0]];
		[self addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel
														 attribute:NSLayoutAttributeLeft
														 relatedBy:NSLayoutRelationEqual
															toItem:nameLabel
														 attribute:NSLayoutAttributeLeft
														multiplier:1
														  constant:0]];
    }
    return self;
}

@end
