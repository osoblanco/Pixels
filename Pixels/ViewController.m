//
//  ViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/1/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"firstB.jpg"]]];

    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signIn:(id)sender {
    
    [self performSegueWithIdentifier:@"LogIn" sender:self];
}
- (IBAction)signUp:(id)sender {
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

@end
