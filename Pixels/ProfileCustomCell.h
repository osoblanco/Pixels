//
//  ProfileCustomCell.h
//  Pixels
//
//  Created by Erik Arakelyan on 8/6/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImages;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
