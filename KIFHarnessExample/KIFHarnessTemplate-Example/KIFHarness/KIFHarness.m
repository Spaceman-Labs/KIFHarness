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

@implementation KIFHarness

- (void)initializeScenarios;
{
	[self addScenario:[KIFTestScenario scenarioToTapBlue]];
	[self addScenario:[KIFTestScenario scenarioToTapRed]];
}

@end
