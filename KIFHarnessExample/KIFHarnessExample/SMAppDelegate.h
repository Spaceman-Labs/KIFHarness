//
//  SMAppDelegate.h
//  KIFHarnessExample
//
//  Created by Jerry Jones on 1/16/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMViewController;

@interface SMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SMViewController *viewController;

@end
