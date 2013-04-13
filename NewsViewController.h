//
//  NewsViewController.h
//  YDNNewsReader
//
//  Created by Vincent Hu on 3/1/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsStory.h"

//for Sharing
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface NewsViewController : UIViewController <MFMailComposeViewControllerDelegate>
{
    NSMutableArray *subViews;
    NSString *mailTitle;
    NSString *mailDescription;
    NSString *mailLink;
    NSString *mailImageLink;
}

- (NSMutableArray *)subViews;
- (void)setSubViews;

/*This is a new init method to load story text into box.*/
- (id)initWithStory:(NewsStory *)entry;

/*for sharing*/
- (void)share;
- (void)sendMail;

@property (nonatomic, copy) NSString *mailTitle;
@property (nonatomic, copy) NSString *mailDescription;
@property (nonatomic, copy) NSString *mailLink;
@property (nonatomic, copy) NSString *mailImageLink;

@end
