//
//  ProfilePic.h
//  Pixels
//
//  Created by Erik Arakelyan on 8/6/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import <Parse/Parse.h>

@interface ProfilePic : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFFile *image;

+ (NSString *)parseClassName;
+ (instancetype)object;
@end
