//
//  JKCrossingControl.h
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/25/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKCrossingGestureRecognizer;

@interface JKCrossingControl : UIControl {

@private
    JKCrossingGestureRecognizer *_crossingRecognizer;
    CGSize _crossingRegionInset;

}

@end