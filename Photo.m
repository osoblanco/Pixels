//
//  Photo.m
//  Photo Viewer
//
//  Created by Karen Ghandilyan on 7/30/14.
//  Copyright (c) 2014 Erik Arakelyan. All rights reserved.
//

#import "Photo.h"

@implementation Photo
@dynamic user, title, image;

+ (instancetype)object {
    Photo *photo = [[Photo alloc] init];
    return photo;
}
+ (NSString *)parseClassName {
    return @"Photo";
}

@end
