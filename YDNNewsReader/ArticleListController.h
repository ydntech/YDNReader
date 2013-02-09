//
//  ArticleListController.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 12/5/11.
//  Copyright 2011 Yale University. All rights reserved.
//

#import <Foundation/Foundation.h>

// #import "TISwipeableTableView.h" -don't need because it's in CustomFeedCell.h
#import "CustomFeedCell.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class WebViewController;

@interface ArticleListController : TISwipeableTableViewController <CustomFeedCellDelegate, MFMailComposeViewControllerDelegate>//, UIActionSheetDelegate>
{
    NSMutableArray *newsStories;
    
    WebViewController *webView;
    
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
