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
#import "SVProgressHUD.h"
#import "MovieCollectionCell.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate,
UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeSegmentedControl;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) UIRefreshControl *collectionRefreshControl;

- (void)initMoviesData;
- (void)updateMoviesData:(id)target WithSelector:(SEL)sel;
- (void)showNetworkError;
- (void)hideNetworkError;
- (void)goToDetailsPage:(int)index;
- (NSString*)getAuthorsString:(NSArray*)actors;

@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Tableview setup
    self.tableView.hidden = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:MOVIE_CELL bundle:nil] forCellReuseIdentifier:MOVIE_CELL];
 
    // Table Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    // Collection View Setup
    self.collectionView.hidden = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MovieCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionCell"];
    
    // Collection Refresh Control
    self.collectionRefreshControl = [[UIRefreshControl alloc] init];
    [self.collectionRefreshControl addTarget:self action:@selector(onCollectionRefresh) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.collectionRefreshControl atIndex:0];
    
    // Initialize MoviesData
    [self initMoviesData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTypeChanged:(id)sender {
    if (self.viewTypeSegmentedControl.selectedSegmentIndex == 1) {
        [self.tableView setHidden:YES];
        [self.collectionView setHidden:NO];
    } else {
        [self.tableView setHidden:NO];
        [self.collectionView setHidden:YES];
    }
}

- (void)updateMoviesData:(id)target WithSelector:(SEL)sel {
    
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MOVIES_URL, API_KEY]];
    NSURL *url = [NSURL URLWithString:self.restfulUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^
     (NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data != nil) {
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             self.movies = responseDictionary[KEY_MOVIES];
             [self hideNetworkError];
         } else {
             [self showNetworkError];
             NSLog(@"response: is nil");
         }
         [self.tableView reloadData];
         [self.collectionView reloadData];
         if (target != nil && sel != nil) {
             [target performSelector:sel];
         }
     }];
}

- (void)onTableRefresh {
    
    [self updateMoviesData:self.tableRefreshControl WithSelector:@selector(endRefreshing)];
}

- (void)onCollectionRefresh {
    
    [self updateMoviesData:self.collectionRefreshControl WithSelector:@selector(endRefreshing)];
}

- (void)initMoviesData {
    
    [SVProgressHUD show];
    [self updateMoviesData:[SVProgressHUD class] WithSelector:@selector(dismiss)];
}

- (void)showNetworkError {
    
    self.networkErrorView.hidden = NO;
}

- (void)hideNetworkError {
    
    self.networkErrorView.hidden = YES;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.movies.count;
}

- (NSString*)getAuthorsString:(NSArray *)actors {
    NSMutableString *label = [[NSMutableString alloc] init];
    if (actors.count > 0) {
        if (actors.count > 2) {
            [label appendString:[NSString stringWithFormat:@"%@, %@", actors[0][KEY_NAME], actors[1][KEY_NAME]]];
        } else {
            [label appendString:actors[0][KEY_NAME]];
        }
    }
    return label;
}

- (void)goToDetailsPage:(int)index {
    MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
    vc.movie = self.movies[index];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:MOVIE_CELL];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[KEY_TITLE];
    cell.actorsLabel.text = [self getAuthorsString:movie[KEY_ABRIDGED_CAST]];
    cell.criticsScoreLabel.text = [NSString stringWithFormat:@"%@%%, %@", [movie valueForKeyPath:KEY_RATINGS_CRITICS_SCORE], [movie valueForKeyPath:KEY_RATINGS_CRITICS_RATING]];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@, %@ min", movie[KEY_MPAA_RATING], movie[KEY_RUNTIME]];
    cell.releaseDateLabel.text = [NSString stringWithFormat:@"Released %@",[movie valueForKeyPath:KEY_RELEASE_DATES_THEATER]];
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:KEY_POSTERS_THUMBNAIL]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToDetailsPage:(int)indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[KEY_TITLE];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@ min %@%%",
                                  movie[KEY_MPAA_RATING], movie[KEY_RUNTIME], [movie valueForKeyPath:KEY_RATINGS_CRITICS_SCORE]];
    NSString *imageUrl = [movie valueForKeyPath:KEY_POSTERS_THUMBNAIL];
    NSRange lastTmb = [imageUrl rangeOfString:@"_tmb" options:NSBackwardsSearch];
    [cell.posterView setImageWithURL:[NSURL URLWithString:[imageUrl stringByReplacingCharactersInRange:lastTmb withString:@"_ori"]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self goToDetailsPage:(int)indexPath.row];
}

@end
