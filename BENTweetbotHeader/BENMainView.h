//
//  BENMainView.h
//  BENTweetbotHeader
//
//  Created by Ben Packard on 3/30/14.
//  Copyright (c) 2014 Ben Packard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BENMainView : UIView

@property UIScrollView *scrollView;
@property UIImageView *headerImage;
@property NSLayoutConstraint *headerCenterYConstraint, *headerHeightConstraint;

@end
