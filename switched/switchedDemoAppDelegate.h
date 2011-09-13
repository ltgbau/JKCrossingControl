//
//  switchedDemoAppDelegate.h
//  SwitchedDemo
//
//  Created by jkaufman on 6/22/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class switchedDemoViewController;

@interface switchedDemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet switchedDemoViewController *viewController;

@end
