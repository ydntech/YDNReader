//
//  YDNNewsReaderAppDelegate.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//
#import "NewsViewController.h"
#import "WebViewController.h"
#import "FeedListController.h"
#import "CategoryListController.h"
#import "FavoritesListController.h"
#import "FavoritesList.h"
#import "EGOCache.h"
#import "YDNNewsReaderAppDelegate.h"

@implementation YDNNewsReaderAppDelegate

@synthesize window = _window;

+ (void)initialize
{
    NSMutableArray *categories = [[[NSMutableArray alloc] initWithObjects:      // categories in the menu
                                   @"News", @"Sports", @"Opinion", 
                                   @"City", @"Science/Technology",
                                   @"Features", @"Weekend", @"Magazine", nil]
                                  autorelease];
    NSMutableArray *feedURLs = [[[NSMutableArray alloc] initWithObjects:        // array of feed urls
                                 @"http://www.yaledailynews.com/feed",
                                 @"http://www.yaledailynews.com/blog/category/sports/feed",
                                 @"http://www.yaledailynews.com/blog/category/opinion/feed",
                                 @"http://www.yaledailynews.com/blog/category/city/feed",
                                 @"http://www.yaledailynews.com/blog/category/sci-tech/feed",
                                 @"http://www.yaledailynews.com/blog/category/features/feed",
                                 @"http://www.yaledailynews.com/blog/category/weekend/feed", //no feeds exists
                                 @"http://www.yaledailynews.com/blog/category/magazine/feed", //no feeds exists
                                 nil]
                                autorelease];
    NSArray *objects = [[[NSArray alloc] initWithObjects:
                         categories, 
                         feedURLs, nil] autorelease];
    NSArray *objectForKeys = [[[NSArray alloc] initWithObjects:
                              @"CategoryListOrderPrefKey", 
                              @"CategoryFeedURLsOrderPrefKey", nil] autorelease];
    NSDictionary *defaults = [NSDictionary dictionaryWithObjects:objects forKeys:objectForKeys];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *masterTab = [[UITabBarController alloc] init];
    
    FeedListController *mainFeedController = [[FeedListController alloc] init];
    [mainFeedController resetWithURL:@"http://www.yaledailynews.com/feed" feedTitle:@"Top Stories" isMainFeed:YES];
    CategoryListController *categoryListController = [[CategoryListController alloc] init];
    FavoritesListController *favoritesController = [[FavoritesListController alloc] init];
    
    //lets consider turning this into table view as well, doesn't seem too hard. Currently links to the crosscampus webpage.
    
    NewsViewController *crossCampusController = [[NewsViewController alloc] initWithStory:nil];
    
    /*WebViewController *crossCampusController = [[WebViewController alloc]
                                                initWithTitle:@"Cross Campus" 
                                                link:@"http://yaledailynews.com/crosscampus/" 
                                                hidesBar:NO];*/
    
    UIColor *yaleBlue = [UIColor colorWithRed:0.0588235294
                                        green:0.301960784
                                         blue:0.57254902
                                        alpha:0];
    
    /*TOP STORIES TAB (FeedListController)*/
    
    UINavigationController *mainFeedTab = [[[UINavigationController alloc] initWithRootViewController:mainFeedController] autorelease];
    NSString *mainFeedImagePath = [[NSBundle mainBundle] pathForResource:@"166-newspaper" 
                                                                   ofType:@"png"];
    UITabBarItem *mainTabItem = [[[UITabBarItem alloc] initWithTitle:@"Top Stories" 
                                                               image:[UIImage imageWithContentsOfFile:mainFeedImagePath] 
                                                                 tag:0] autorelease];
    [mainFeedTab setTabBarItem:mainTabItem];
    [[mainFeedTab navigationBar] setTintColor:yaleBlue];
    
    /*CATEGORIES TAB (CategoryListController)*/
    
    UINavigationController *categoryTab = [[[UINavigationController alloc] initWithRootViewController:categoryListController] autorelease];
    NSString *categoryImagePath = [[NSBundle mainBundle] pathForResource:@"44-shoebox" 
                                                                   ofType:@"png"];
    UITabBarItem *catTabItem = [[[UITabBarItem alloc] initWithTitle:@"Categories" 
                                                              image:[UIImage imageWithContentsOfFile:categoryImagePath] tag:2] autorelease];
    [categoryTab setTabBarItem:catTabItem];
    [[categoryTab navigationBar] setTintColor:yaleBlue];
    
    /*FAVORITES TAB (FavoritesListController)*/
    
    UINavigationController *favoritesTab = [[[UINavigationController alloc] initWithRootViewController:favoritesController] autorelease];
    NSString *favoritesImagePath = [[NSBundle mainBundle] pathForResource:@"28-star" 
                                                                    ofType:@"png"];
    UITabBarItem *favTabItem = [[[UITabBarItem alloc] initWithTitle:@"Favorites" 
                                   image:[UIImage imageWithContentsOfFile:favoritesImagePath] tag:3] autorelease];
    [favoritesTab setTabBarItem:favTabItem];
    [[favoritesTab navigationBar] setTintColor:yaleBlue];


    /*CROSS CAMPUS TAB (WebViewController)*/
    UINavigationController *crossCampusTab = [[[UINavigationController alloc] initWithRootViewController:crossCampusController] autorelease];
    NSString *ccImagePath = [[NSBundle mainBundle] pathForResource:@"124-bullhorn" 
                                                                    ofType:@"png"];
    UITabBarItem *ccTabItem = [[[UITabBarItem alloc] initWithTitle:@"Cross Campus" image:[UIImage imageWithContentsOfFile:ccImagePath] tag:1] autorelease];
    [crossCampusTab setTabBarItem:ccTabItem];
    [[crossCampusTab navigationBar] setTintColor:yaleBlue];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                style:UIBarButtonItemStylePlain
                                                                  target:crossCampusController
                                                                action:@selector(home:)];
    [[crossCampusController navigationItem] setLeftBarButtonItem:backButton];
    [backButton release];
    
    [categoryListController release];
    [mainFeedController release];
    [favoritesController release];
    [crossCampusController release];
    
    /*CONNECT TABS TO MASTERTAB (UITabBarController)*/
    
    NSArray *tabs = [[[NSArray alloc] initWithObjects:mainFeedTab, crossCampusTab, categoryTab,  favoritesTab,  nil] autorelease];
    [masterTab setViewControllers:tabs];
    
    
    [self.window setRootViewController:masterTab];
    [masterTab release];
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[FavoritesList defaultFavorites] save];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastAccessDateKey"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[EGOCache currentCache] clearCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    UITabBarController *masterTab = (UITabBarController *)_window.rootViewController;
    
    if ([[NSDate date] timeIntervalSinceDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"lastAccessDateKey"]]  >= 10800) { 
        [masterTab setSelectedIndex:0];
    }
    
    if ([masterTab selectedIndex] > 3)
    {
        [masterTab setSelectedIndex:0];
    }
    
    //forces a refresh
    [(UIViewController *)[[masterTab viewControllers] objectAtIndex:[masterTab selectedIndex]] viewWillAppear:YES];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FavoritesList defaultFavorites] save];
    //[[EGOCache currentCache] clearCache];
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
