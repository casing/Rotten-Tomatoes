//
//  Constants.m
//  Rotten Tomatoes
//
//  Created by Casing Chu on 1/22/15.
//  Copyright (c) 2015 casing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString * const API_KEY = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us";
NSString * const TITLE = @"Movies";
NSString * const MOVIE_CELL = @"MovieCell";

// JSON Keys
NSString * const KEY_MOVIES = @"movies";
NSString * const KEY_TITLE = @"title";
NSString * const KEY_SYNOPSIS = @"synopsis";
NSString * const KEY_POSTERS_THUMBNAIL = @"posters.thumbnail";