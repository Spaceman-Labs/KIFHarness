//
//  SMViewController.m
//  KIFHarnessExample
//
//  Created by Jerry Jones on 1/16/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import "SMViewController.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)color:(id)sender
{
	if (sender == self.blueButton) {
		self.colorLabel.text = @"Blue";
	} else if (sender == self.redButton) {
		self.colorLabel.text = @"Red";
	} else if (sender == self.greenButton) {
		self.colorLabel.text = @"Green";
	} else if (sender == self.orangeButton) {
		self.colorLabel.text = @"Orange";
	}
}

@end
