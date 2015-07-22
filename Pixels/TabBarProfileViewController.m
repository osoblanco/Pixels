//
//  TabBarProfileViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/2/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "TabBarProfileViewController.h"
#import "CustomCell.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "ProfilePic.h"
#import "MBProgressHUD.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ODRefreshControl.h"
#import <QuartzCore/QuartzCore.h>
#import "ProfileCustomCell.h"

@interface TabBarProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property NSMutableArray *photoArray;
@property NSMutableArray *arr;
@end

@implementation TabBarProfileViewController
@synthesize photoArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)logOut:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [PFUser logOut];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)profilePic:(id)sender {
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *receivedImage=[info valueForKey:UIImagePickerControllerOriginalImage];
    self.profilePic.image= receivedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];

    [self loadToParse];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setHidesBackButton:YES animated:YES];
}
- (void)viewDidLoad
{
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self query];
    [self queryProfilePic];
    //
    //    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventAllEvents];
    //    [self.tableView addSubview:refreshControl];
    
    ODRefreshControl *refresh=[[ODRefreshControl alloc]initInScrollView:self.tableView];
    [refresh addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
   
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControll
{
    double delayInSeconds=1.0;
    dispatch_time_t popTime=dispatch_time(DISPATCH_TIME_NOW, delayInSeconds*(NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControll endRefreshing];
        [self query];
        [self.tableView reloadData];
    });
}
//- (void)refresh:(UIRefreshControl *)refreshControl {
//
//
////    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:0];
////    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
//
////    [self.view setNeedsDisplay];
//
//    [self.tableView reloadData];
//    [refreshControl endRefreshing];
//}

-(void)query
{
    
    
    photoArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            // The find succeeded.
            [photoArray addObjectsFromArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return photoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 175;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CustomCell";
    
    ProfileCustomCell *cell = (ProfileCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Empty" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    
    Photo *photo = photoArray[indexPath.row];
    
    NSMutableArray *myArray=[[NSMutableArray alloc]init];
    [myArray addObject:photo.image.url];
    for(int i=0;i<myArray.count;i++)
    {
        [cell.userImages setImageWithURL:[myArray objectAtIndex:i]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
    PFUser *user = photo.user;
    [user fetch];
    cell.descriptLabel.text=photo.title;
    NSString *dateString=[[NSString alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM-dd-YYYY"];
    
    dateString=[format stringFromDate:photo.createdAt];
    cell.timeLabel.text=dateString;
    self.usernameLabel.text = user.username;
    

    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void)queryProfilePic
{
    PFQuery *query=[PFQuery queryWithClassName:@"ProfilePic"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    NSMutableArray *array= [[NSMutableArray alloc]init];
    array = [NSMutableArray arrayWithArray:[query findObjects]];
    if([array count]!=0)
    { PFObject *object=array[0];
    PFFile *imageFile=(PFFile *)[object objectForKey:@"image"];
    self.profilePic.image=[UIImage imageWithData:[imageFile getData]];
    }
    
}

-(void)loadToParse
{
    UIImage *image=self.profilePic.image;
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    NSData *jpegData = UIImageJPEGRepresentation(image, 1);
    PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpeg", timestamp] data:jpegData];
    
    ProfilePic *photoObject = [ProfilePic object];
 
    photoObject.image = file;
    photoObject.user=[PFUser currentUser];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [photoObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"GOOD" message:@"Profile Pic Saved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];        }];
    
}



@end
