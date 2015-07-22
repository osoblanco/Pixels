//
//  TabBarUploadViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/2/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "TabBarUploadViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Photo.h"
@interface TabBarUploadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *chosenImage;
@property (weak, nonatomic) IBOutlet UITextField *descriptField;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation TabBarUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scroller.delegate=self;
    self.descriptField.delegate=self;
    
    [self.scroller setContentSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height+100)];
    [self.navigationController setNavigationBarHidden:YES];

   // self.uploadButton.backgroundcolor=[UIColor greenColor];
//    [self.chosenImage setImage:[UIImage imageNamed:@"imageChoose"]];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)imageTouch:(id)sender {
    [self showActionSheet];
}

-(void)showActionSheet
{

    NSString *actionSheetTitle = @"Choose"; //Action Sheet Title
    NSString *destructiveTitle = @"Camera"; //Action Sheet Button Titles
    NSString *cancelTitle = @"Cancel Button";

    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:destructiveTitle
                                  otherButtonTitles:@"Gallery", nil];

    [actionSheet showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([buttonTitle isEqualToString:@"Gallery"])
    {
UIImagePickerController *imageControl=[[UIImagePickerController alloc]init];
        imageControl.delegate=self;
        imageControl.modalPresentationStyle=UIModalPresentationCurrentContext; //What is this??
        [self presentViewController:imageControl animated:YES completion:nil];

    }
    if([buttonTitle isEqualToString:@"Camera"])
    {
        UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"Camera is unavailable" message:@"buy a developer account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [cameraAlert show];

    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField.frame.origin.y+textField.frame.size.height>=self.view.frame.size.height-216)
    {
        float Height=self.view.frame.size.height;
        float offsetOfY =((textField.frame.origin.y+textField.frame.size.height)-(Height-216-3));
        CGPoint scrollPoint =CGPointMake(0, offsetOfY);
        [self.scroller setContentOffset:scrollPoint animated:YES];
        [self.scroller setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-216-5)];
    }
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.scroller.frame = CGRectMake(self.scroller.frame.origin.x, self.scroller.frame.origin.y, self.scroller.frame.size.width, self.view.frame.size.height);
    [self.scroller setContentOffset:CGPointMake(0, 0) animated:YES];
    

    }

//- (IBAction)selectImage:(id)sender {
//    
//    UIImagePickerController *imageControl=[[UIImagePickerController alloc]init];
//    imageControl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    imageControl.delegate = self;
//    //    imageControl.modalPresentationStyle=UIModalPresentationCurrentContext; //What is this??
//    [self presentViewController:imageControl animated:YES completion:nil];
//    
//}

- (IBAction)uploadAction:(id)sender {
    if (self.chosenImage.image) {
        UIImage *image = self.chosenImage.image;
        NSString *description = self.descriptField.text;
        PFUser *currentUser = [PFUser currentUser];
        
        NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
        
        NSData *jpegData = UIImageJPEGRepresentation(image, 1);
        PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpeg", timestamp] data:jpegData];
        
        Photo *photoObject = [Photo object];
        photoObject.title = description;
        photoObject.image = file;
        photoObject.user = currentUser;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [photoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.chosenImage.image=[UIImage imageNamed:@"imageChoose"];
            self.descriptField.text=nil;
            UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"GOOD" message:@"Photo Uploaded successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [cameraAlert show];        }];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *receivedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    self.chosenImage.image = receivedImage;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)touches:(id)sender {
    [self resignFirstResponder];
    [self.view endEditing:YES];
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
