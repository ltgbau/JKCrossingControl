//
//  JKCrossingControl.m
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/25/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "JKCrossingControl.h"
#import "JKCrossingGestureRecognizer.h"
#import "UIView+JKCrossingGestureAdditions.h"

@interface JKCrossingControl ()

@property (nonatomic, retain) JKCrossingGestureRecognizer *crossingRecognizer;
@property (nonatomic, assign) CGSize crossingRegionInset;
- (void)configureRecognizer;

@end

@implementation JKCrossingControl

@synthesize crossingRecognizer;
@synthesize crossingRegionInset;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self configureRecognizer];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self configureRecognizer];
    }
    return self;
}

- (void)configureRecognizer {
    // Subclasses may override this method but must call [super configureRecognizer] before performing their own customizations.
    self.crossingRecognizer = [[JKCrossingGestureRecognizer alloc] initWithTarget:self action:@selector(crossedRegion:)];

    // NOTE: All readwrite properties of JKCrossingGestureRecognizer may be modified with the exception of crossingRegion. Subclasses
    // that wish to grow or shrink the recognition region should set |crossingRegionInset|. This must be done within |-configureRecognizer|.
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    // Remove gesture recognizer from currnet view.
    [[self topmostContainingView] removeGestureRecognizer:self.crossingRecognizer];
}
- (void)didMoveToWindow {    
    // Reparent gesture recognizer.
    UIView *topmostView = [self topmostContainingView];
    [topmostView addGestureRecognizer:self.crossingRecognizer];
    self.crossingRecognizer.crossingRegion = [topmostView convertRect:CGRectInset(self.frame, crossingRegionInset.width, crossingRegionInset.height) fromView:self.superview];
}

- (void)crossedRegion:(JKCrossingGestureRecognizer *)recognizer {
    NSAssert(0, @"JKCrossingControl: Subclasses must override |-crossedRegion:|");

    // Subclasses should override |-crossedRegion:| and act on the gesture state.
    // Several readonly JKCrossingGestureRecognizer properties are of interest to subclasses:
    //   state (began)
    //     The state of the gesture recognizer. See UIGestureRecognizer docs for details.
    //     Subclasses may ignore states other than UIGestureRecognizerStateEnded.
    //   location
    //     First available: began
    //     Description: The location of the candidate touch within this control's frame.
    //     Example use: A switch may use location update the position of its nub during the drag.
    //   velocity 
    //     First available: changed
    //     Description: Instantaneous gesture velocity in px/s, calculated using the last two touch events.
    //     Example use: A switch may use this speed, or several eadings, to animate the dragging or flicking of its nub.
    //   direction
    //     First available: ended
    //     Description: The gesture's observed heading (left/up/right/down).
    //     Example use: A switch supports left and right gestures, but should only switch OFF if swiped left.
}

- (void)dealloc {
    [crossingRecognizer release];
    [super dealloc];
}

@end
