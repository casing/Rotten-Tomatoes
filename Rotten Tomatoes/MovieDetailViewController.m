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
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = self.movie[KEY_TITLE];
    self.synopsisLabel.text = self.movie[KEY_SYNOPSIS];
    NSString *imageUrl = [self.movie valueForKeyPath:KEY_POSTERS_THUMBNAIL];
    NSRange lastTmb = [imageUrl rangeOfString:@"_tmb" options:NSBackwardsSearch];
    [self.detailView setImageWithURL:[NSURL URLWithString:[imageUrl stringByReplacingCharactersInRange:lastTmb withString:@"_ori"]] fadeDuration:2.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
