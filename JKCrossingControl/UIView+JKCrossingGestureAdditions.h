//
//  UIView+JKCrossingGestureAdditions.h
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/25/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JKCrossingGestureAdditions)

// Returns the top-most non-window view containing this view.
- (UIView *)topmostContainingView;

@end
