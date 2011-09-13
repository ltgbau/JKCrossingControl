//
//  switchedDemoViewController.h
//  SwitchedDemo
//
//  Created by jkaufman on 6/22/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKCrossingSwitch;

@interface switchedDemoViewController : UIViewController {
    UIView *_testView;
    BOOL _testBool;
}

@property (nonatomic, retain) IBOutlet JKCrossingSwitch *testSwitch;

@end
