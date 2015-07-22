//
//  SignUpViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/1/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "SignUpViewController.h"
#import <Parse/Parse.h>
@interface SignUpViewController ()

@property int count;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScroll;
@property (weak, nonatomic) IBOutlet UITextField *emailOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordOutlet;
@property (weak, nonatomic) IBOutlet UITextField *repeatedOutlet;
@property (weak, nonatomic) IBOutlet UITextField *userNameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *fullNameOutlet;
@property (weak, nonatomic) IBOutlet UITextField *dateofBirthOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderOutlet;

@property (weak, nonatomic) IBOutlet UILabel *asteriskEmail1;
@property (weak, nonatomic) IBOutlet UILabel *asteriskUsername;
@property (weak, nonatomic) IBOutlet UILabel *asteriskFullName;
@property (weak, nonatomic) IBOutlet UILabel *asteriskPassword;
@property (weak, nonatomic) IBOutlet UILabel *asteriskRePassword;
@property (weak, nonatomic) IBOutlet UILabel *asteriskDateofBirth;


@end

@implementation SignUpViewController


- (BOOL) validateDate: (NSString *) candidate {
    NSString *dateRegex = @"^(0[1-9]{1}|[12]{1}[0-9]{1}|3[01]{1}).{1}(0[1-9]{1}|1[0-2]{1}).{1}([12]{1}[0-9]{3})$";
    NSPredicate *dateTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", dateRegex];
    
    return [dateTest evaluateWithObject:candidate];
}

- (IBAction)signUp:(id)sender {
    
    if(![self validateDate:self.dateofBirthOutlet.text] ||[self.dateofBirthOutlet.text isEqualToString:Nil] )
    {
        self.asteriskDateofBirth.text=@"-";
        UIAlertView *myAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"wrong date input" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [myAlert show];
        
    }
    
    NSString *dateString=self.dateofBirthOutlet.text;
    NSDate *myDate=[[NSDate alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"mm-dd-yyyy"];
    myDate=[format dateFromString:dateString];
        
     if(_count==5)
{   PFUser *user = [PFUser user];
    user.username = self.userNameOutlet.text;
    user.password = self.passwordOutlet.text;
    user.email = self.emailOutlet.text;
    [user setObject:self.fullNameOutlet.text forKey:@"fullName"];
    [user setObject:myDate forKey:@"dateOfBirth"];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
// Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *myAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [myAlert show];
            // Show the errorString somewhere and let the user try again.
        }
    }];
}else{UIAlertView *myAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Fill in the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [myAlert show];}
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField.frame.origin.y+textField.frame.size.height>=self.view.frame.size.height-216)
    {
        float Height=self.view.frame.size.height;
        float offsetOfY =((textField.frame.origin.y+textField.frame.size.height)-(Height-216-3));
        CGPoint scrollPoint =CGPointMake(0, offsetOfY);
        [self.mainScroll setContentOffset:scrollPoint animated:YES];
        [self.mainScroll setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-216-5)];
        
    }
    
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.mainScroll.frame = CGRectMake(self.mainScroll.frame.origin.x, self.mainScroll.frame.origin.y, self.mainScroll.frame.size.width, self.view.frame.size.height);
    [self.mainScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    if(textField==self.emailOutlet)
    {
        if(![self validateEmail:self.emailOutlet.text] || [self.emailOutlet.text isEqualToString:nil])
        {
            self.asteriskEmail1.text=@"-";
            
        }else{_count++; self.asteriskEmail1.text=@"+";}
    }
    
    //___________________________________________________________________________
    if(textField==self.passwordOutlet || textField==self.repeatedOutlet)
    { if ((![self.passwordOutlet.text isEqualToString:self.repeatedOutlet.text]) || ([self.passwordOutlet.text isEqualToString:@""]))
    {
        
        self.asteriskPassword.text=@"-";
        self.asteriskRePassword.text=@"-";
        
    }
    else
    {
        _count++;
        self.asteriskPassword.text=@"+";
        self.asteriskRePassword.text=@"+";
    }
    }
    //________________________________________________________________________________
    if(textField==self.userNameOutlet)
    {
        NSString *string1 = self.userNameOutlet.text;
        NSString *trimmedString1 = [string1 stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
        if ([trimmedString1 isEqualToString:@""])
        {
            self.asteriskUsername.text=@"-";
            
        }else{ _count++; self.asteriskUsername.text=@"+";}
    }
    //________________________________________________________________________________
    if(textField==self.fullNameOutlet)
    {
        NSString *string2 = self.fullNameOutlet.text;
        NSString *trimmedString2 = [string2 stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceCharacterSet]];
        if ([trimmedString2 isEqualToString:@""])
        {
            self.asteriskFullName.text=@"-";
            
        }else{ _count++; self.asteriskFullName.text=@"+";}
            
        }
    if(textField==self.dateofBirthOutlet)
    {
        if(![self validateDate:self.dateofBirthOutlet.text] ||[self.dateofBirthOutlet.text isEqualToString:Nil] )
    {
        self.asteriskDateofBirth.text=@"-";
    }else{_count++; self.asteriskDateofBirth.text=@"+";}
    }
    
}


- (IBAction)TapGesture:(id)sender {
    
    [self resignFirstResponder];
    [self.view endEditing:YES];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}


- (void)viewDidLoad
{
   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
    
    self.mainScroll.delegate=self;
    _mainScroll.scrollEnabled=YES;
    self.dateofBirthOutlet.delegate=self;
    [self.mainScroll setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+100)];

    _count=0;

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
