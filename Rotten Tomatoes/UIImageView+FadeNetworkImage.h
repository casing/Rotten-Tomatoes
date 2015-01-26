//
//  UIImageView+FadeNetworkImage.h
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/25/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FadeNetworkImage)

- (void)setImageWithURL:(NSURL*)url fadeDuration:(float)duration;

@end
