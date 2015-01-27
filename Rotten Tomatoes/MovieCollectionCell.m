//
//  MovieCollectionCell.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/24/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "MovieCollectionCell.h"

@implementation MovieCollectionCell

- (void)awakeFromNib {
    // Initialization code
    UIView *view = [[UIView alloc] initWithFrame:self.frame];
    view.backgroundColor = [UIColor colorWithRed:122/255.0 green:171/255.0 blue:255/255.0 alpha:1.0];
    self.selectedBackgroundView = view;
}

@end
