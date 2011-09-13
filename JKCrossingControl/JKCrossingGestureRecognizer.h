//
//  CrossingGestureRecognizer.h
//  JKCrossingControl
//
//  Created by jkaufman on 6/22/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <Foundation/Foundation.h>

// Begins:  when one touch has moved enough within the crossing region to be considered a drag
// Changes: when this finger moves
// Fails:   when this finger remains stationary for too long or gestures in the wrong direction
// Ends:    when this finger is lifted

typedef enum {
    JKCrossingGestureRecognizerDirectionRight = 1 << 0,
    JKCrossingGestureRecognizerDirectionLeft  = 1 << 1,
    JKCrossingGestureRecognizerDirectionUp    = 1 << 2,
    JKCrossingGestureRecognizerDirectionDown  = 1 << 3
} JKCrossingGestureRecognizerDirection;

@interface JKCrossingGestureRecognizer : UIGestureRecognizer {
    UITouch *_touch;                    // The touch tracked by this gesture recognizer.
    CGPoint _anchorPoint;               // Location of first touch. This could be outside of the crossing region.
    BOOL _traversed;                    // Whether the tracked passed through the crossing region.
    NSTimeInterval _lastTouchTime;      // Used to calculate drag velocity.
    CGFloat _dragDistance;              // Accumulated drag distances. Must exceed a minimum value for the gesture to begin.
    
@private

    CGRect _crossingRegion;
    BOOL _canStartWithinCrossingRegion;
    JKCrossingGestureRecognizerDirection _recognizedDirections;
    CGFloat _minimumCrossingDistance;
    NSTimeInterval _maximumInactiveInterval;;

    CGPoint _location;
    CGFloat _velocity;
    JKCrossingGestureRecognizerDirection _direction;    
}

// Gesture recognizer customization.
@property (nonatomic, assign) CGRect crossingRegion;                                        // Target region for gesture in window coordinates.
@property (nonatomic, assign) BOOL canStartWithinCrossingRegion;                            // Whether it is acceptable for the initial touch to be within the crossing region.
@property (nonatomic, assign) JKCrossingGestureRecognizerDirection recognizedDirections;    // Acceptable directions for gesture.
@property (nonatomic, assign) CGFloat minimumCrossingDistance;                              // Distance that the touch must track within the given region before it is recognized.
@property (nonatomic, assign) NSTimeInterval maximumInactiveInterval;                        // Maximum period of inactivity before the gesture is rejected.

// Gesture recognizer state.
@property (nonatomic, readonly) CGPoint location;                                           // Location of drag within the crossing region, measured from origin (top-left).
@property (nonatomic, readonly) CGFloat velocity;                                           // Instantaneous velocity of the drag in offset/second (available on begin).
@property (nonatomic, readonly) JKCrossingGestureRecognizerDirection direction;             // Direction of gesture (available upon recognition).

@end
