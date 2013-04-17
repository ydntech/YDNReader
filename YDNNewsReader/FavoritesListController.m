//
//  FavoritesListController.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/14/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import "FavoritesListController.h"

#import "WebViewController.h"

#import "NewsStory.h"
#import "FavoritesList.h"

#import "CustomFeedCell.h"
//keep for now
#import "EGOImageView.h"

@implementation FavoritesListController

- (NSMutableArray *)newsStories
{
    return [NSArray arrayWithArray:[[FavoritesList defaultFavorites] favoriteStories]];
}

- (void)setNewsStories:(NSMutableArray *)recentStories
{
    // do nothing
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [[self navigationItem] setTitle:@"To Read"];
    //webView = [[WebViewController alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.tableView reloadData];
}

- (void)viewDidUnload 
{
    //[super viewDidUnload];
    /*
    [webView release];
    webView = nil;*/
} 


#pragma mark - CustomFeedCellDelegate

- (void)cellFavoritesButtonWasTapped:(CustomFeedCell *)cell
{
    [super cellFavoritesButtonWasTapped:cell];
    [self.tableView reloadData];
}


@end
