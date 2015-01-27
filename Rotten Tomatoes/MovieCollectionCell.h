//
//  MovieCollectionCell.h
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/24/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticsScoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *criticsRatingView;

@end
