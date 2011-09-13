//
//  switchedDemoViewController.m
//  SwitchedDemo
//
//  Created by jkaufman on 6/22/11.
//  Copyright 2011 Justin Kaufman. All rights reserved.
//

#import "switchedDemoViewController.h"
#import "JKCrossingGestureRecognizer.h"
#import "JKCrossingSwitch.h"
#import "UIView+JKCrossingGestureAdditions.h"

@implementation switchedDemoViewController

@synthesize testSwitch = _testSwitch;

- (void)dealloc
{
    [_testView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor blueColor]];
    
    // Add test view.
    _testView = [[UIView alloc] initWithFrame:CGRectMake(100,100,100,100)];
    [_testView setBackgroundColor:[UIColor redColor]];
    [[self view] addSubview:_testView];
    
    // Attach a crossing gesture recognizer manually.
    JKCrossingGestureRecognizer *crossingRecognizer = [[[JKCrossingGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)] autorelease];
    crossingRecognizer.canStartWithinCrossingRegion = YES;
    crossingRecognizer.crossingRegion = _testView.frame;
    crossingRecognizer.recognizedDirections = JKCrossingGestureRecognizerDirectionUp;
    [[_testView topmostContainingView] addGestureRecognizer:crossingRecognizer];

    // Watch switch for value change events. The switch accepts standard touch events as well as crossing gestures.
    [self.testSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
}

- (void)handleGesture:(JKCrossingGestureRecognizer *)recognizer {
    NSLog(@"%@", [recognizer description]);

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        _testBool = !_testBool;
        _testView.backgroundColor = _testBool ? [UIColor blackColor] : [UIColor redColor];
    }
}

- (void)switchToggled:(id)sender {
    NSLog(@"switched!");
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.testSwitch = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
