//
//  JKCrossingSwitch.h
//  JKCrossingControl
//
//  Created by Justin Kaufman on 6/23/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JKCrossingGestureRecognizer;

@interface JKCrossingSwitch : UISwitch {

@private
    JKCrossingGestureRecognizer *_crossingRecognizer;
    
}

@property (nonatomic, retain, readonly) JKCrossingGestureRecognizer *crossingRecognizer;

@end
