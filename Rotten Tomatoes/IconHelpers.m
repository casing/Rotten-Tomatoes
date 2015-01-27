//
//  IconHelpers.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/26/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "IconHelpers.h"

@implementation IconHelpers

+ (UIImage*) getRatingImage:(NSString *)rating {
    if ([rating isEqualToString:@"Certified Fresh"]) {
        return [UIImage imageNamed:@"CF_16x16.png"];
    } else if ([rating isEqualToString:@"Fresh"]) {
        return [UIImage imageNamed:@"fresh-16.png"];
    } else if ([rating isEqualToString:@"Rotten"]) {
        return [UIImage imageNamed:@"splat-16.png"];
    } else if ([rating isEqualToString:@"Upright"]) {
        return [UIImage imageNamed:@"popcorn-16.png"];
    } else if ([rating isEqualToString:@"Spilled"]) {
        return [UIImage imageNamed:@"badpopcorn-16.png"];
    }
    return nil;
}

@end
