//
//  UIView+CrossingAdditions.m
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/25/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "UIView+JKCrossingGestureAdditions.h"


@implementation UIView (JKCrossingAdditions)

- (UIView *)topmostContainingView {
    // Walk up view hierarchy until encountering the top-most view that isn't a UIWindow instance.
    UIView *v = self;
    while (v.superview) {
        if ([v.superview isKindOfClass:[UIWindow class]]) {
            break;
        } else {
            v = v.superview;
        }
    }
    return v;
}

@end
