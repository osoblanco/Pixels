//
//  Photo.h
//  Photo Viewer
//
//  Created by Karen Ghandilyan on 7/30/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import <Parse/Parse.h>

@interface Photo : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSString *title;

+ (NSString *)parseClassName;
+ (instancetype)object;
@end
