//
//  CategoryListController.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import "CategoryListController.h"
#import "FeedListController.h"
#import "FavoritesList.h"
#import "EGOCache.h"

//static NSString *rootFeed = @"http://www.yaledailynews.com/rss/headlines/";
NSString * const CategoryListOrderPrefKey = @"CategoryListOrderPrefKey";
NSString * const CategoryFeedURLsOrderPrefKey = @"CategoryFeedURLsOrderPrefKey"; 

@implementation CategoryListController

@synthesize feedURLs, categories, subFeedLists;

- (id)init
{
    self = [super init];
    if (self) 
    {
        //want to load these from NSUserDefaults
        NSArray *savedCategories = [[NSUserDefaults standardUserDefaults] arrayForKey:CategoryListOrderPrefKey];
        categories = [[NSMutableArray alloc] init];
        for (NSString *category in savedCategories) {
            [categories addObject:category];
        }
        
        NSArray *savedURLs = [[NSUserDefaults standardUserDefaults] arrayForKey:CategoryFeedURLsOrderPrefKey];
        feedURLs = [[NSMutableArray alloc] init];
        for (NSString *category in savedURLs) {
            [feedURLs addObject:category];
        }
        
        subFeedLists = [[NSMutableArray alloc] init];
        FeedListController *subFeed;
        for (int i = 0; i < [categories count]; i++)
        {
            //subFeed = [[FeedListController alloc] initWithURL:[feedURLs objectAtIndex:i] 
            //                                        feedTitle:[categories objectAtIndex:i]                    
            //                                       isMainFeed:NO];
            //added
            subFeed = [[FeedListController alloc] init];
            [subFeed resetWithURL:[feedURLs objectAtIndex:i] feedTitle:[categories objectAtIndex:i] isMainFeed:NO];
            
            [subFeedLists addObject:subFeed];
            [subFeed release];
        }
        
        //This won't do anything since the main tab is the navigation controller
        //UITabBarItem *tbi = [self tabBarItem];
        //[tbi setTitle:@"Categories"];
        
        [[self navigationItem] setTitle:@"Categories"];
        //[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryListUITableViewCell"];
    
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"CategoryListUITableViewCell"] autorelease];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [[cell textLabel] setText:[categories objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int listIndex = [indexPath row];
    
    [[self navigationController] pushViewController:[subFeedLists objectAtIndex:listIndex] animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)moveCategoryAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    
    NSString *category = [categories objectAtIndex:from];
    NSString *correspondingURL = [feedURLs objectAtIndex:from];
    FeedListController *correspondingFeedList = [subFeedLists objectAtIndex:from];
    
    [category retain];
    [correspondingURL retain];
    [correspondingFeedList retain];
    
    [categories removeObjectAtIndex:from];
    [feedURLs removeObjectAtIndex:from];
    [subFeedLists removeObjectAtIndex:from];
    
    [categories insertObject:category atIndex:to];
    [feedURLs insertObject:correspondingURL atIndex:to];
    [subFeedLists insertObject:correspondingFeedList atIndex:to];
    
    [category release];
    [correspondingURL release];
    [correspondingFeedList release];
}
 
# pragma mark-  UITableViewDelegate

- (void)tableView:(UITableView *)tableView 
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self moveCategoryAtIndex:[sourceIndexPath row]
                      toIndex:[destinationIndexPath row]];
    [[NSUserDefaults standardUserDefaults] setObject:categories 
                                              forKey:CategoryListOrderPrefKey];
    [[NSUserDefaults standardUserDefaults] setObject:feedURLs 
                                              forKey:CategoryFeedURLsOrderPrefKey];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    
    [self.tableView setEditing:editing animated:animate];
} */

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    [[EGOCache currentCache] clearCache];
}

- (void) dealloc
{
    [feedURLs release];
    [categories release];
    [subFeedLists release];
    
    [super dealloc];
}
@end
