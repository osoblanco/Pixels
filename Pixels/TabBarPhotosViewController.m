//
//  TabBarPhotosViewController.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/2/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "TabBarPhotosViewController.h"
#import "CustomCell.h"
#import "MBProgressHUD.h"
#import "Photo.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "ODRefreshControl.h"
#import <QuartzCore/QuartzCore.h>

@interface TabBarPhotosViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoArray;

@end

@implementation TabBarPhotosViewController
@synthesize photoArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    return 170;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *simpleTableIdentifier = @"CustomCell";
    
      CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
     
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
        [cell.cellImage setImageWithURL:[myArray objectAtIndex:i]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
   
    
    PFUser *user = photo.user;
    [user fetch];
    cell.descriptLabel.text=photo.title;
    NSString *dateString=[[NSString alloc]init];
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MM-dd-YYYY"];
    
    dateString=[format stringFromDate:photo.createdAt];
    cell.timeLabel.text=dateString;
    cell.userLabel.text = user.username;

    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
