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
#import "UIImageView+FadeNetworkImage.h"
#import "MovieDetailViewController.h"
#import "Constants.h"
#import "SVProgressHUD.h"
#import "MovieCollectionCell.h"
#import "IconHelpers.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate,
UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) UIRefreshControl *collectionRefreshControl;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;

- (void)initMoviesData;
- (void)updateMoviesData:(id)target WithSelector:(SEL)sel;
- (void)showNetworkError;
- (void)hideNetworkError;
- (void)goToDetailsPage:(int)index;
- (void)filterMoviesData;
- (NSDictionary*)getMovie:(int)index;
- (NSUInteger)getMovieDataCount;
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:122/255.0 green:171/255.0 blue:255/255.0 alpha:1.0]];
    
    self.filteredMovies = [[NSMutableArray alloc] init];
    
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
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^
     (NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data != nil) {
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             self.movies = responseDictionary[KEY_MOVIES];
             [self filterMoviesData];
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
    self.networkErrorLabel.hidden = NO;
}

- (void)hideNetworkError {
    
    self.networkErrorView.hidden = YES;
    self.networkErrorLabel.hidden = YES;
}

- (NSUInteger)getMovieDataCount {
    if ([self.searchBar.text length] == 0) {
        return self.movies.count;
    } else {
        return self.filteredMovies.count;
    }
}

- (NSDictionary*)getMovie:(int)index {
    if ([self.searchBar.text length] == 0) {
        return self.movies[index];
    } else {
        return self.filteredMovies[index];
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self getMovieDataCount];
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
    vc.movie = [self getMovie:(int)index];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:MOVIE_CELL];
    NSDictionary *movie = [self getMovie:(int)indexPath.row];
    cell.titleLabel.text = movie[KEY_TITLE];
    cell.actorsLabel.text = [self getAuthorsString:movie[KEY_ABRIDGED_CAST]];
    cell.criticsScoreLabel.text = [NSString stringWithFormat:@"%@%%",
                                   [movie valueForKeyPath:KEY_RATINGS_CRITICS_SCORE]];
    [cell.criticsRatingView setImage:[IconHelpers getRatingImage:[movie valueForKeyPath:KEY_RATINGS_CRITICS_RATING]]];
    cell.typeLabel.text = [NSString stringWithFormat:@"%@, %@ min", movie[KEY_MPAA_RATING], movie[KEY_RUNTIME]];
    cell.releaseDateLabel.text = [NSString stringWithFormat:@"Released %@",[movie valueForKeyPath:KEY_RELEASE_DATES_THEATER]];
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:KEY_POSTERS_THUMBNAIL]]
                  withPlaceHolderURL:nil
                    withFadeDuration:2.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToDetailsPage:(int)indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self getMovieDataCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
   
    NSDictionary *movie = [self getMovie:(int)indexPath.row];
    cell.titleLabel.text = movie[KEY_TITLE];
    cell.descriptionLabel.text = [NSString stringWithFormat:@"%@ %@ min",
                                  movie[KEY_MPAA_RATING], movie[KEY_RUNTIME]];
    cell.criticsScoreLabel.text = [NSString stringWithFormat:@"%@%%", [movie valueForKeyPath:KEY_RATINGS_CRITICS_SCORE]];
    [cell.criticsRatingView setImage:[IconHelpers getRatingImage:[movie valueForKeyPath:KEY_RATINGS_CRITICS_RATING]]];
    NSString *imageUrl = [movie valueForKeyPath:KEY_POSTERS_THUMBNAIL];
    NSRange lastTmb = [imageUrl rangeOfString:@"_tmb" options:NSBackwardsSearch];
    [cell.posterView setImageWithURL:[NSURL URLWithString:[imageUrl stringByReplacingCharactersInRange:lastTmb withString:@"_ori"]]
                  withPlaceHolderURL:[NSURL URLWithString:imageUrl]
                    withFadeDuration:2.0];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self goToDetailsPage:(int)indexPath.row];
}

- (void)filterMoviesData {
    [self.filteredMovies removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", self.searchBar.text];
    self.filteredMovies = [NSMutableArray arrayWithArray:[self.movies filteredArrayUsingPredicate:predicate]];
}

//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"SearchButtonClicked");
//    [self filterMoviesData];
//}
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    NSLog(@"TextDidEndEditing");
//    [self filterMoviesData];
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterMoviesData];
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

@end
