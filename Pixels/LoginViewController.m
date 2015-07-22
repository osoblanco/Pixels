//
//  LoginViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/1/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordOutlet;

@end

@implementation LoginViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
       
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.view endEditing:YES];

    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)logIn:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.usernameOutlet.text password:self.passwordOutlet.text block:^(PFUser *user, NSError *error)
    {
      if(!error)
      {   NSLog(@"Successful login");
          [self performSegueWithIdentifier:@"TabBar" sender:self];}
        else
        {
            UIAlertView *myAlert=[[UIAlertView alloc]initWithTitle:@"oooops" message:@"Wrong login credentials" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
        }
    }];
        
}


- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
