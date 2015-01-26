//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/21/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+FadeNetworkImage.h"
#import "Constants.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (NSString*)getAuthorsString:(NSArray*)actors;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(320, 750);
    self.titleLabel.text = self.movie[KEY_TITLE];
    self.synopsisLabel.text = self.movie[KEY_SYNOPSIS];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@%%, %@",
                                  [self.movie valueForKeyPath:KEY_RATINGS_CRITICS_SCORE],
                                  [self.movie valueForKeyPath:KEY_RATINGS_CRITICS_RATING]];
    self.actorsLabel.text = [self getAuthorsString:self.movie[KEY_ABRIDGED_CAST]];
    self.ratingsLabel.text = [NSString stringWithFormat:@"%@, %@ min", self.movie[KEY_MPAA_RATING], self.movie[KEY_RUNTIME]];
    self.releaseDateLabel.text = [NSString stringWithFormat:@"Released %@", [self.movie valueForKeyPath:KEY_RELEASE_DATES_THEATER]];
    NSString *imageUrl = [self.movie valueForKeyPath:KEY_POSTERS_THUMBNAIL];
    NSRange lastTmb = [imageUrl rangeOfString:@"_tmb" options:NSBackwardsSearch];
    [self.detailView setImageWithURL:[NSURL URLWithString:[imageUrl stringByReplacingCharactersInRange:lastTmb withString:@"_ori"]]
                  withPlaceHolderURL:[NSURL URLWithString:imageUrl]
                    withFadeDuration:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)getAuthorsString:(NSArray *)actors {
    NSMutableString *label = [[NSMutableString alloc] init];
    for (int i=0; i<actors.count-1; i++) {
        [label appendString:[NSString stringWithFormat:@"%@, ", actors[i][KEY_NAME]]];
    }
    
    if (actors.count > 0) {
        [label appendString:actors[actors.count-1][KEY_NAME]];
    }
    
    return label;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
