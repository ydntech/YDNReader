//
//  ArticleListController.m
//  YDNNewsReader
//
//  Created by Hu, Rozner, Chen on 3/2013
//  Copyright 2013 Yale University. All rights reserved.
//

#import "ArticleListController.h"

#import "NewsViewController.h"

#import "NewsStory.h"
#import "FavoritesList.h"

#import "CustomFeedCell.h"
#import "EGOCache.h"

@implementation ArticleListController

@synthesize lastSwipedCell, lastSelectedCell;
//@synthesize webView;
/*
-(id)init
{
    self = [super init];
    
    if (self)
    {
        webView = [[WebViewController alloc] init];
    }

    return self;
}
*/
- (NSMutableArray *)newsStories
{
    return newsStories;
}

- (void)setNewsStories:(NSMutableArray *)recentStories
{
    //this is never actually called
    [newsStories release];
    newsStories = recentStories;
    [newsStories retain];
}

#pragma mark - Memory Managment

- (void)dealloc
{
    //[newsStories release];
    //[webView release]; //this was not commented out. But we don't alloc a webview anywhere so I got rid of it.
    [super dealloc];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
    [[EGOCache currentCache] clearCache];
}

#pragma mark - CustomFeedCellDelegate

- (void)cellFavoritesButtonWasTapped:(CustomFeedCell *)cell 
{
    //a bit clunky...oh well
	NewsStory *story = [[[NewsStory alloc] init] autorelease]; //need release here
    [story loadWithTitle:cell.titleLabel.text link:cell.articleLink description:cell.descriptionLabel.text date:cell.date author:cell.author content:cell.content imageLink:cell.thumbnailURL];
    
    
    if (![[FavoritesList defaultFavorites] removeFromFavorites:story]) 
    {
        if (![[FavoritesList defaultFavorites] addToFavorites:story]) 
        {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Cannot Add"
                                                             message:@"Maximum 10 saved items"
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
            
            //reverts it back if shouldn't be selected
            [cell.favoritesButton setSelected:![cell.favoritesButton isSelected]];
        }
    }
    
	[self hideVisibleBackView:YES];
}

- (void)cellShareButtonWasTapped:(CustomFeedCell *)cell 
{
   /* UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"Share"
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel" 
                                               destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"Email", @"Facebook", nil] autorelease]; //@"Twitter", nil] autorelease];
    
    [actionSheet showFromRect:cell.frame inView:cell animated:YES];
    //[actionSheet showFromToolbar:self.navigationController.toolbar];
    //[actionSheet release?]
    */
    [self sendMail:cell];
    
    [self hideVisibleBackView:YES];
} 

- (void)cellBackButtonWasTapped:(CustomFeedCell *)cell 
{
	[self hideVisibleBackView:YES];
}
/*
#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    CustomFeedCell *cell = (CustomFeedCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:lastSwipedCell inSection:0]];
    
    switch (buttonIndex) {
        case 0:
        {
            [self sendMail:cell];
            break;
        }
        case 1:
        {
            [self postToFacebook:cell];
            break;
        }
        
        case 2:
        {
            [self tweet:cell];
            break;
        }
         
        default:
            break;
    }
}
*/
#pragma mark - Sharing Methods

- (void)sendMail:(CustomFeedCell *)cell
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self; 
    
    [picker setSubject:@"Check out this article from the Yale Daily News"];
    
    // Fill out the email body text
    NSString *appLink = @"http://itunes.apple.com/us/app/yale-daily-news/id480072824?mt=8";
    NSString *emailBody = [NSString stringWithFormat:
                           @"<html><body><h3>%@</h3>"
                           @"<p>%@</p>"
                           @"<p>... Read the rest of the article <a href = %@>here</a>.</p>"
                           @"<p><font size=2>Sent from the Yale Daily News iPhone App.  "
                            @"<a href = '%@'>Download</a> yours today.</font></p>"
                           @"</body></html>",
                           cell.titleLabel.text, 
                           cell.descriptionLabel.text, 
                           cell.articleLink, 
                           appLink];
   
    //change fonts size of link
    
    [picker setMessageBody:emailBody isHTML:YES];
    
    NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:cell.thumbnailURL]];
    [picker addAttachmentData:image mimeType:@"image/png" fileName:@"YDNImage"];
    
    [picker.navigationBar setBarStyle:UIBarStyleBlack];
    [picker.navigationBar setTintColor:[UIColor colorWithRed:0.0588235294
                                                       green:0.301960784
                                                        blue:0.57254902
                                                       alpha:0]];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
/*
- (void)postToFacebook:(CustomFeedCell *)cell
{
    FBFeedPost *post = [[FBFeedPost alloc] initWithLinkPath:cell.articleLink 
                                                    caption:cell.titleLabel.text];
	[post publishPostWithDelegate:self];
	
	IFNNotificationDisplay *display = [[IFNNotificationDisplay alloc] init];
	display.type = NotificationDisplayTypeLoading;
	display.tag = NOTIFICATION_DISPLAY_TAG;
	[display setNotificationText:@"Posting Link..."];
	[display displayInView:self.view atCenter:CGPointMake(self.view.center.x, self.view.center.y-100.0) withInterval:0.0];
	[display release];     
}

- (void)tweet:(CustomFeedCell *)cell
{

}
*/

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
		{
            //[alert setTitle:@"Email Canceled"];
            break;
        }
		case MFMailComposeResultSaved:
		{
            //[alert setTitle:@"Email Saved"];
            break;
        }
		case MFMailComposeResultSent:
		{
            //[alert setTitle:@"Email Sent"];
            break;
        }
        /*
        case MFMailComposeResultFailed:
        {
             //[alert setTitle:@"Email Failed"];
             break;
        }
        */
		default:
		{
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Email"
                                                             message:@"Sending failed"
                                                            delegate:nil 
                                                   cancelButtonTitle:@"OK" 
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
        }
	}
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.newsStories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CustomFeedCell";
    
    CustomFeedCell *cell = (CustomFeedCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[[CustomFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    int index = [indexPath row];
    NewsStory *currentStory = [self.newsStories objectAtIndex:index]; 
    
    //where the customFeedCell for each NewsStory is set
    [cell resetCellWithTitle:[currentStory title]
                 description:[currentStory storyDescription]
                        date:[currentStory publicationDate]
                      author:[currentStory author]
                     content:[currentStory storyContent]
                    imageURL:[currentStory imageLink]
                 articleLink:[currentStory link]];
    
    [cell setDelegate:self];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSwipeCellAtIndexPath:(NSIndexPath *)indexPath 
{
	[super tableView:tableView didSwipeCellAtIndexPath:indexPath];
    [self setLastSwipedCell:[indexPath row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [self setLastSelectedCell:[indexPath row]];
    
    NewsStory *entry = [self.newsStories objectAtIndex:[indexPath row]];
    
    if(!webView)
    {
        
        webView = [[NewsViewController alloc] initWithStory:entry];
        //webView = [[WebViewController alloc] initWithTitle:entry.title description:entry.storyDescription link:entry.link imageLink:entry.imageLink hidesBar:YES];
       //NSLog(@"Just entered here");
    }
    else
    {
        webView = [[NewsViewController alloc] initWithStory:entry];
       //[webView reloadWithTitle:entry.title description:entry.storyDescription link:entry.link imageLink:entry.imageLink];
        //NSLog(@"Just entered here1"); // Displays before "Webview appearing" in WebViewContoller
    }
    
    [[self navigationController] pushViewController:webView animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideVisibleBackView:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [self.tableView setRowHeight:90.0];
}



/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
@end
