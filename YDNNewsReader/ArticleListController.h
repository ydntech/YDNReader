//
//  ArticleListController.h
//  YDNNewsReader
//
//  Created by Hu, Rozner, Chen on 3/2013
//  Copyright 2013 Yale University. All rights reserved.
//

/*  PURPOSE: This controller affects the list of articles (i.e. the first screen
    of Top Stories and the list of articles after you click each category.
 
    It declares a global NSMutableArray *newsStories which it then displays
    the stories from.
 
    FeedListController is used to actually put the stories from the RSS feed
    into newsStories. I think FeedListController is called because FLC contains
    the method "connectionDidFinishLoading," which will be called when the
    connection finishes loading, and thus results in the processing of the RSS feed.
 */

#import <Foundation/Foundation.h>

// #import "TISwipeableTableView.h" -don't need because it's in CustomFeedCell.h
#import "CustomFeedCell.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

//@class WebViewController;
@class NewsViewController;

@interface ArticleListController : TISwipeableTableViewController <CustomFeedCellDelegate, MFMailComposeViewControllerDelegate>//, UIActionSheetDelegate>
{
    NSMutableArray *newsStories; //this is a global variable.
        //FeedListController processes the stories and adds them to newStories
    
    NewsViewController *webView;
    //WebViewController *webView;
    
    int lastSwipedCell, lastSelectedCell;
}

@property (nonatomic, readwrite) int lastSwipedCell, lastSelectedCell;
//@property (nonatomic, readonly) WebViewController *webView; 
//to be subclassed;
- (NSMutableArray *)newsStories;
- (void)setNewsStories:(NSMutableArray *)recentStories;

//sharing methods
- (void)sendMail:(CustomFeedCell *)cell;
/*
- (void)postToFacebook:(CustomFeedCell *)cell;
- (void)tweet:(CustomFeedCell *)cell;
*/
@end
