//
//  SMViewController.h
//  KIFHarnessExample
//
//  Created by Jerry Jones on 1/16/13.
//  Copyright (c) 2013 Spaceman Labs, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *colorLabel;

@property (nonatomic, strong) IBOutlet UIButton *blueButton;
@property (nonatomic, strong) IBOutlet UIButton *redButton;
@property (nonatomic, strong) IBOutlet UIButton *greenButton;
@property (nonatomic, strong) IBOutlet UIButton *orangeButton;

- (IBAction)color:(id)sender;

@end
