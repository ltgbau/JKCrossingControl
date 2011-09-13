//
//  JKCrossingSwitch.m
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/23/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "JKCrossingSwitch.h"
#import "UIView+JKCrossingGestureAdditions.h"
#import "JKCrossingGestureRecognizer.h"

@interface JKCrossingSwitch ()

@property (nonatomic, retain, readwrite) JKCrossingGestureRecognizer *crossingRecognizer;

@end

@implementation JKCrossingSwitch

@synthesize crossingRecognizer;

- (void)willMoveToWindow:(UIWindow *)newWindow {
    // Remove current gesture recognizer.
    [[self topmostContainingView] removeGestureRecognizer:self.crossingRecognizer];
}

- (void)didMoveToWindow {
    if (!self.crossingRecognizer) {
        // Set custom gesture recognizer.
        self.crossingRecognizer = [[[JKCrossingGestureRecognizer alloc] initWithTarget:self action:@selector(crossedRegion:)] autorelease];
        self.crossingRecognizer.recognizedDirections = JKCrossingGestureRecognizerDirectionLeft | JKCrossingGestureRecognizerDirectionRight;        
        self.crossingRecognizer.crossingRegion = [[self topmostContainingView] convertRect:self.frame fromView:self.superview];
        self.crossingRecognizer.canStartWithinCrossingRegion = YES;
    }

    [[self topmostContainingView] addGestureRecognizer:self.crossingRecognizer];
}

- (void)crossedRegion:(JKCrossingGestureRecognizer *)recognizer {
    NSLog(@"%@", self);
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // Switching on requires a drag to the right, off a drag to the left.
        if ((self.on && recognizer.direction == JKCrossingGestureRecognizerDirectionLeft) ||
            (self.on == NO && recognizer.direction == JKCrossingGestureRecognizerDirectionRight)) {
                [self setOn:!self.on animated:YES];
        }
    }
}

- (void)dealloc {
    [crossingRecognizer release];
    [super dealloc];
}

@end
