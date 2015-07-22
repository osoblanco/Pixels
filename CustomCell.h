//
//  CustomCell.h
//  Pixels
//
//  Created by Erik Arakelyan on 8/3/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@end
