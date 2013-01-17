//
//  KIFTestScenario+KIFHarness.m
//
//  Created by Jerry Jones on 1/14/13.
//  Copyright (c) 2013 Spaceman Labs. All rights reserved.
//

#import "KIFTestScenario+KIFHarness.h"
#import "KIFTestStep.h"
#import "KIFTestStep+KIFHarness.h"

@implementation KIFTestScenario (KIFHarness)

+ (id)scenarioToTapBlue
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can tap the Blue button."];
	[scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Blue"]];
	[scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Color Label"
																	 value:@"Blue"
																	traits:UIAccessibilityTraitStaticText]];

    return scenario;
}

+ (id)scenarioToTapRed
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can tap the Red button."];
	[scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Red"]];
	[scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Color Label"
																	 value:@"Red"
																	traits:UIAccessibilityTraitStaticText]];
	
    return scenario;
}

@end
