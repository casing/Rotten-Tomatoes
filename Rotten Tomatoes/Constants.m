//
//  Constants.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/22/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString * const API_KEY = @"dagqdghwaq3e3mxyrp7kmmj5";
NSString * const MOVIES_URL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?limit=20&country=us&apikey=";
NSString * const DVD_URL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?limit=20&country=us&apikey=";
NSString * const BOX_OFFICE_TITLE = @"Box Office";
NSString * const DVD_TITLE = @"DVD";
NSString * const MOVIE_CELL = @"MovieCell";

// JSON Keys
NSString * const KEY_MOVIES = @"movies";
NSString * const KEY_TITLE = @"title";
NSString * const KEY_SYNOPSIS = @"synopsis";
NSString * const KEY_POSTERS_THUMBNAIL = @"posters.thumbnail";
NSString * const KEY_MPAA_RATING = @"mpaa_rating";
NSString * const KEY_RUNTIME = @"runtime";
NSString * const KEY_RATINGS_CRITICS_SCORE = @"ratings.critics_score";
NSString * const KEY_RATINGS_CRITICS_RATING = @"ratings.critics_rating";
NSString * const KEY_ABRIDGED_CAST = @"abridged_cast";
NSString * const KEY_RELEASE_DATES_THEATER = @"release_dates.theater";
NSString * const KEY_NAME = @"name";