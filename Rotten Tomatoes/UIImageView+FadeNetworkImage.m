//
//  UIImageView+FadeNetworkImage.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/25/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "UIImageView+FadeNetworkImage.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (FadeNetworkImage)

- (void)setImageWithURL:(NSURL*)url fadeDuration:(float)duration {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self setImageWithURLRequest:request placeholderImage:nil success:
     ^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
         // Fade In
         self.alpha = 0;
         [self setImage:image];
         [UIView animateWithDuration:duration animations:^{
             self.alpha = 1;
         } completion:^(BOOL finished) {
         }];
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
         NSLog(@"%@", [error description]);
     }];
}

@end
