//
//  StoryViewController.m
//  YDNNewsReader
//
//  Created by Mimi Chen on 2/22/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import "StoryViewController.h"

#import "NewsStory.h"

@implementation StoryViewController

@synthesize webView;
@synthesize storyTitle, storyDescription, storyLink, storyImageLink;

- (id)init
{
    return [self initWithTitle:@"Error" link:@"http://www.yaledailynews.com/feed" hidesBar:YES];
}

- (id)initWithTitle:(NSMutableString *)titleOfStory link:(NSMutableString *)linkOfStory hidesBar:(BOOL)hidesBottomBar
{
    return [self initWithTitle:titleOfStory description:@"" link:linkOfStory imageLink:@"" hidesBar:hidesBottomBar];
}

- (id)initWithTitle:(NSString *)titleOfStory description:(NSString *)descriptionOfStory link:(NSString *)linkOfStory imageLink:(NSString *)imageLinkOfStory hidesBar:(BOOL)hidesBottomBar
{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    
    if (self) {
        [self setStoryTitle:[NSMutableString stringWithString:titleOfStory]];
        [self setStoryDescription:[NSMutableString stringWithString:descriptionOfStory]];
        [self setStoryLink:[NSMutableString stringWithString:linkOfStory]];
        [self setStoryImageLink:[NSMutableString stringWithString:imageLinkOfStory]];
        
        [webView setScalesPageToFit:YES];
        
        [[self navigationItem] setTitle:storyTitle];
        [self setHidesBottomBarWhenPushed:hidesBottomBar];
        
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)] autorelease]];
    }
    
    return self;
}

/*
 - (id)initWithStory:(NewsStory *)story
 {
 self = [super initWithNibName:@"WebViewController" bundle:nil];
 if (self) {
 [self setStoryTitle:[NSMutableString stringWithString:story.title]];
 [self setStoryDescription:[NSMutableString stringWithString:story.storyDescription]];
 [self setStoryLink:[NSMutableString stringWithString:story.link]];
 [self setStoryImageLink:[NSMutableString stringWithString:story.imageLink]];
 
 [self.webView setScalesPageToFit:YES];
 
 [self.navigationItem setTitle:self.storyTitle];
 [self setHidesBottomBarWhenPushed:YES];
 
 [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)] autorelease]];
 }
 
 
 return self;
 }
 */
- (void)share
{
	[self sendMail];
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

- (void)sendMail//:(CustomFeedCell *)cell
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:[NSString stringWithString:@"Check out this article from the Yale Daily News"]];
    
    // Fill out the email body text
    NSString *appLink = @"http://itunes.apple.com/us/app/yale-daily-news/id480072824?mt=8";
    NSString *emailBody = [NSString stringWithFormat:
                           @"<html><body><h3>%@</h3>"
                           @"<p>%@</p>"
                           @"<p>... Read the rest of the article <a href = %@>here</a>.</p><p></p>"
                           @"<p>Sent from the Yale Daily News iPhone App.  "
                           @"<a href = '%@'>Download</a> yours today.</p>"
                           @"</body></html>",
                           self.storyTitle,
                           self.storyDescription,
                           self.storyLink,
                           appLink];
    
    //change fonts size of link
    
    [picker setMessageBody:emailBody isHTML:YES];
    
    NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.storyImageLink]];
    [picker addAttachmentData:image mimeType:@"image/png" fileName:@"YDNImage"];
    
    [picker.navigationBar setBarStyle:UIBarStyleBlack];
    [picker.navigationBar setTintColor:[UIColor colorWithRed:0.0588235294
                                                       green:0.301960784
                                                        blue:0.57254902
                                                       alpha:0]];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}


# pragma mark - other stuff
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }
    return YES;
}

- (void)home:(id)sender
{
    NSURL *url = [NSURL URLWithString:self.storyLink];//[NSURL URLWithString:storyLink];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}

//pass it a reference
/*
 - (void)reloadWithStory:(NewsStory *)story
 {
 [self setStoryTitle:[NSMutableString stringWithString:story.title]];
 [self setStoryDescription:[NSMutableString stringWithString:story.storyDescription]];
 [self setStoryLink:[NSMutableString stringWithString:story.link]];
 [self setStoryImageLink:[NSMutableString stringWithString:story.imageLink]];
 
 [self.navigationItem setTitle:self.storyTitle];
 
 }
 */
- (void)reloadWithTitle:(NSString *)titleOfStory description:(NSString *)descriptionOfStory link:(NSString *)linkOfStory imageLink:(NSString *)imageLinkOfStory
{
    [self setStoryTitle:[NSMutableString stringWithString:titleOfStory]];
    if (descriptionOfStory != nil)
        [self setStoryDescription:[NSMutableString stringWithString:descriptionOfStory]];
    [self setStoryLink:[NSMutableString stringWithString:linkOfStory]];
    [self setStoryImageLink:[NSMutableString stringWithString:imageLinkOfStory]];
    
    [[self navigationItem] setTitle:storyTitle];
}

- (void)viewWillAppear:(BOOL)animated //THE THING THAT LOADS THE STORY. (Switches from table view to story itself when you load.
{
    //Original link failing because NSURL converts certain characters into code (# into %23). http://stackoverflow.com/questions/1528060/uiwebview-error-while-loading-url
    //Needed to encode the URL using this code I took from the internet. I assume it protects the #
    //http://stackoverflow.com/questions/5822138/webview-failed-error-in-iphone
    
    NSString *encodedString = [storyLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES]; //Mimi added this. Scales the whole page to fit in the view of the phone FUCKYEAH
    [webView loadRequest:req];
    //NSLog(@"Webview appearing");
    //NSLog(@"%@", storyLink);
    
    /*ALSO THIS APP IS STUPID RIGHT NOW, IT IS BASICALLY AN EASIER WAY TO GET TO THE WEBPAGE DISPLAYING THE STORY LOL. Probably those fancy
     apps online for WSJ or something have fancy mobile websites that make their content look nicer on a phone. AND WE DON'T LOL.
     */
}

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

#pragma mark UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] == -999)
    {
        NSLog(@"error -999");
        return;
    }
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Cannot Load"
                                                     message:[error localizedDescription]
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    //NSLog(@"no internet so broke");
    //NSLog(@"%@", error);
    //Domian NSURLErrorDomain Code =-1009
    //[error localizedDescription]
    
}

- (void)dealloc
{
    [webView release];
    [storyLink release];
    [storyTitle release];
    [super dealloc];
}
/*
 - (void)viewDidDisappear:(BOOL)animated
 {
 [storyLink release];
 [storyLink release];
 }
 */
@end