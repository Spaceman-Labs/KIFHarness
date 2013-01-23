//
//  KIFHarness.m
//  KIFHarness
//
//  Created by Jerry Jones on 1/16/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import "KIFHarness.h"
#import "KIFTestScenario+KIFHarness.h"
#import "KIFTestStep+KIFHarness.h"

#ifdef KIFJunitTestLoggerEnabled
#import "KIFJunitTestLogger.h"
#endif

@implementation KIFHarness

- (id)init
{
	self = [super init];
	if (nil == self) {
		return nil;
	}
	
#ifdef KIFJunitTestLoggerEnabled
	KIFJunitTestLogger *logger = [[KIFJunitTestLogger alloc] init];
	[self registerLogger:logger];
#endif
	
	return self;
}

- (void)initializeScenarios;
{
	// Scenarios should be added to KIFTestScenario+KIFHarness and added here
	NSLog(@"Running KIF Tests With KIFHarness");
}

@end
