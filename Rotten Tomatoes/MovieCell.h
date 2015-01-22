//
//  MovieCell.h
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/21/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
