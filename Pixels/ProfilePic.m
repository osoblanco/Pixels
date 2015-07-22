//
//  ProfilePic.m
//  Pixels
//
//  Created by Erik Arakelyan on 8/6/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "ProfilePic.h"

@implementation ProfilePic 
@dynamic user, image;

+ (instancetype)object {
    ProfilePic *photo = [[ProfilePic alloc] init];
    return photo;
}
+ (NSString *)parseClassName {
    return @"ProfilePic";
}

@end
