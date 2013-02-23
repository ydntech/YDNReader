//
//  StoryViewController.h
//  YDNNewsReader
//
//  Created by Mimi Chen on 2/22/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class CustomFeedCell;
@class NewsStory;

@interface StoryViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>//, UIActionSheetDelegate>
{
    IBOutlet UIWebView *webView;
    
    NSMutableString *storyTitle;
    NSMutableString *storyDescription;
    NSMutableString *storyLink;
    NSMutableString *storyImageLink;
}

- (id)initWithTitle:(NSString *)titleOfStory link:(NSString *)linkOfStory hidesBar:(BOOL)hidesBottomBar;
- (id)initWithTitle:(NSString *)titleOfStory description:(NSString *)descriptionOfStory link:(NSString *)linkOfStory imageLink:(NSString *)imageLinkOfStory hidesBar:(BOOL)hidesBottomBar;
- (void)reloadWithTitle:(NSString *)titleOfStory description:(NSString *)descriptionOfStory link:(NSString *)linkOfStory imageLink:(NSString *)imageLinkOfStory;


//- (id)initWithStory:(NewsStory *)story;
//- (void)reloadWithStory:(NewsStory *)story;

- (void)home:(id)sender;

- (void)share;
- (void)sendMail;

@property (nonatomic, readonly) IBOutlet UIWebView *webView;
@property (nonatomic, copy) NSMutableString *storyTitle;
@property (nonatomic, copy) NSMutableString *storyDescription;
@property (nonatomic, copy) NSMutableString *storyLink;
@property (nonatomic, copy) NSMutableString *storyImageLink;

@end

