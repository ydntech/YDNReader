//
//  FeedListController.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import "ArticleListController.h"

#import "EGORefreshTableHeaderView.h"

#import "TBXML.h"

@class NewsStory;
@class WebViewController;

@interface FeedListController : ArticleListController <EGORefreshTableHeaderDelegate, NSXMLParserDelegate>
{
    NSMutableString *feedURL;
    NSMutableString *feedTitle;
    
    NSURLConnection *connection;
    NSMutableData *xmlData;
    
    NSMutableString *currentTitle, *currentLink, *currentDescription, *currentImageLink, *currentStoryContent;
    NewsStory *storyToAdd;

    EGORefreshTableHeaderView *refreshHeaderView;
	BOOL reloading;
    
    NSDate *lastUpdated;
}

- (void)resetWithURL:(NSString *)rssFeedURL feedTitle:(NSString *)rssFeedTitle isMainFeed:(BOOL)isMain;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

- (void)fetchEntries;
- (void)traverseElement:(TBXMLElement *)element;

@property (nonatomic, copy) NSMutableString *feedURL, *feedTitle;
@property (nonatomic, copy) NSDate *lastUpdated;

@end

