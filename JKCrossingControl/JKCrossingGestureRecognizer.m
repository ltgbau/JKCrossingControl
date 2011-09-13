//
//  CrossingGestureRecognizer.m
//  JKCrossingControl
//
//  Created by jkaufman on 6/22/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "JKCrossingGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "UIGestureRecognizer+JKCrossingGestureAdditions.h"

@interface JKCrossingGestureRecognizer ()

@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGFloat velocity;
@property (nonatomic, assign) JKCrossingGestureRecognizerDirection direction;

@end

@implementation JKCrossingGestureRecognizer

@synthesize crossingRegion = _crossingRegion;
@synthesize canStartWithinCrossingRegion = _canStartWithinCrossingRegion;
@synthesize recognizedDirections = _recognizedDirections;
@synthesize minimumCrossingDistance = _minimumCrossingDistance;
@synthesize maximumInactiveInterval = _maximumInactiveInterval;

@synthesize location = _location;
@synthesize velocity = _velocity;
@synthesize direction = _direction;

const CGFloat kDefaultMinimumCrossingGestureDistance = 25;
const NSTimeInterval kDefaultMaximumInactiveInterval = 0.5;

#pragma mark - Lifecycle

- (id)initWithTarget:(id)target action:(SEL)action {
    if ((self = [super initWithTarget:target action:action])) {
        self.minimumCrossingDistance = kDefaultMinimumCrossingGestureDistance;
        self.maximumInactiveInterval = kDefaultMaximumInactiveInterval;
        self.crossingRegion = CGRectZero;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:
            @"%@ "
            "<%p>: "
            "State: %@, "
            "Offset: %.0f/%.0f, "
            "Velocity: %f ",
            NSStringFromClass([self class]),
            self,
            [self stringFromState],
            self.location.x, self.location.y,
            self.velocity]; 
}

#pragma mark - Geometry

CGFloat angleOfLineSegment(CGPoint first, CGPoint second) {
    // Measures the angle of the line segment from the positive y-axis (range 0:2pi)
    CGFloat rAngle = atan2f(second.x - first.x, second.y - first.y) + M_PI;
    return rAngle;
}

CGFloat distanceBetweenPoints(CGPoint first, CGPoint second) {
    // Measure the hypotenuse of our right triangle.
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(pow(deltaX, 2) + pow(deltaY, 2));
};

// Location of point within the rectangle, constrainting out-of-bounds values.
CGPoint locationOfPointInRect(CGPoint point, CGRect rect) {
    // Measure offset of point from the rect origin.
    CGFloat deltaX = point.x - rect.origin.x;
    CGFloat deltaY = point.y - rect.origin.y;

    // Clamp to rect.
    if(deltaX < 0)
        deltaX = 0;
    else if(deltaX > rect.size.width)
        deltaX = rect.size.width;

    if(deltaY < 0)
        deltaY = 0;
    else if(deltaY > rect.size.height)
        deltaY = rect.size.height;
    
    return CGPointMake(deltaX, deltaY);
};

JKCrossingGestureRecognizerDirection directionOfAngle(CGFloat rAngle) {
    // Identify the direction within pi/4 radians of its axis with a clockwise edge bias.
    JKCrossingGestureRecognizerDirection direction = JKCrossingGestureRecognizerDirectionUp;
    CGFloat units = rAngle / M_PI_4;
    if (units > 1 && units <= 3) {
        direction = JKCrossingGestureRecognizerDirectionLeft;
    } else if (units > 3 && units <= 5) {
        direction = JKCrossingGestureRecognizerDirectionDown;
    } else if (units > 5 && units <= 7) {
        direction = JKCrossingGestureRecognizerDirectionRight;
    }
    return direction;
}

JKCrossingGestureRecognizerDirection directionOfDrag(CGPoint first, CGPoint second) {
    return directionOfAngle(angleOfLineSegment(first, second));
}

#pragma mark - UIGestureRecognizerSubclass Overrides
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    // Only begin tracking single-touches.
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        self.state = UIGestureRecognizerStateFailed;
    } else {
        self.state = UIGestureRecognizerStatePossible;
        
        // Record initial touch, since additional touches don't cancel the gesture.
        _touch = [touches anyObject];

        // And time.
        _lastTouchTime = event.timestamp;
        
        // Save anchor point.
        _anchorPoint = [_touch locationInView:self.view];
        
        // Check if within crossing region
        if(self.canStartWithinCrossingRegion && CGRectContainsPoint(self.crossingRegion, _anchorPoint)) {
            _traversed = YES;
            self.location = locationOfPointInRect(_anchorPoint, self.crossingRegion);
            self.state = UIGestureRecognizerStateBegan;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    // Continue tracking the initial touch, ignoring any others.
    if (![touches containsObject:_touch]) {
        return;
    }
    
    // Gesture is must meet the following conditions;
    //  - Drag began within or intersects region
    //  - Distance of drag, measured from first point inside crossing region, exceeds minimum distance.
    //  - Angle of drag satisfies the directional constraint.
    //  - Time between drag events does not exceed maximim.
    // This intentionally excludes very fast drags whose touch points are never within the crossing region.

    // Fail on linger.
    NSTimeInterval delta = event.timestamp - _lastTouchTime;
    _lastTouchTime = event.timestamp;
    if (delta > self.maximumInactiveInterval) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }

    CGPoint dragLocation = [_touch locationInView:self.view];

    // Check for touch if touch wasn't within region, otherwise continue.
    if (!_traversed && CGRectContainsPoint(self.crossingRegion, dragLocation)) {
        _traversed = YES;
        self.location = locationOfPointInRect(dragLocation, self.crossingRegion);
        self.state = UIGestureRecognizerStateBegan;
        return;
    }

    // Check if crossing satisfied.
    if (_traversed) {
        // Update total distance of drag following crossing.
        CGFloat latestDragDistance = distanceBetweenPoints(dragLocation, [_touch previousLocationInView:self.view]);
        _dragDistance += latestDragDistance;
        
        // Update values provided to gesture delegate.
        self.velocity = latestDragDistance / delta;
        self.location = locationOfPointInRect(dragLocation, self.crossingRegion);
        
        // Check if minimum drag distance statisfied.
        if (_dragDistance >= self.minimumCrossingDistance) {
            // Check if angle satisfied, measuring as a straight line from the initial touch down location.
            // The drag segment within the crossing region bounds isn't long enoug to be accurate.
            JKCrossingGestureRecognizerDirection dragDirection = directionOfDrag(_anchorPoint, dragLocation);
            if (self.recognizedDirections & dragDirection) {
                self.direction = dragDirection;
                self.state = UIGestureRecognizerStateEnded;
            } else {
                self.state = UIGestureRecognizerStateFailed;
            }
        } else {
            self.state = UIGestureRecognizerStateChanged;
        }
    } else {
        self.state = UIGestureRecognizerStatePossible;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if(![touches containsObject:_touch]) {
        return;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![touches containsObject:_touch]) {
        return;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

// Reset state in preparation for next gesture recognition cycle.
- (void)reset {
    [super reset];

    self.velocity = 0;
    self.direction = 0;
    _lastTouchTime = 0;
    _traversed = NO;
    _dragDistance = 0;
    _anchorPoint = CGPointZero;
    _touch = nil;
}

// Crossing gestures should never take precedence.
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}


@end
