//
//  UIGestureRecognizer+JKCrossingGestureAdditions.m
//  JKCrossingControl
//
//  Created by Justin Kaufman on 9/12/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "UIGestureRecognizer+JKCrossingGestureAdditions.h"


@implementation UIGestureRecognizer (JKCrossingGestureAdditions)


- (NSString *)stringFromState {
    NSString *stateString = @"Unknown";
    switch (self.state) {
        case UIGestureRecognizerStatePossible:
            stateString = @"Possible";
            break;
        case UIGestureRecognizerStateBegan:
            stateString = @"Began";
            break;
        case UIGestureRecognizerStateChanged:
            stateString = @"Changed";
            break;
        case UIGestureRecognizerStateEnded:
            stateString = @"Ended";
            break;
        case UIGestureRecognizerStateFailed:
            stateString = @"Failed";
            break;
        case UIGestureRecognizerStateCancelled:
            stateString = @"Cancelled";
            break;
    }
    return stateString;
}

@end
