//
//  CustomCell.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/3/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "CustomCell.h"
@interface CustomCell()


@end

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end