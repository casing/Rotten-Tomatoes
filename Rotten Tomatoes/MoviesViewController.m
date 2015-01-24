//
//  MoviesViewController.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/20/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "Constants.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = TITLE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MOVIES_URL, API_KEY]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^
     (NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data != nil) {
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             self.movies = responseDictionary[KEY_MOVIES];
         } else {
             NSLog(@"response: is nil");
         }
         [self.tableView reloadData];
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 128;
    [self.tableView registerNib:[UINib nibWithNibName:MOVIE_CELL bundle:nil] forCellReuseIdentifier:MOVIE_CELL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.movies.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:MOVIE_CELL];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[KEY_TITLE];
    cell.synopsisLabel.text = movie[KEY_SYNOPSIS];
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:KEY_POSTERS_THUMBNAIL]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
