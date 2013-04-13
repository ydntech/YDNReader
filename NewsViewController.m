//
//  NewsViewController.m
//  YDNNewsReader
//
//  Created by Vincent Hu on 3/1/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import "NewsViewController.h"

#import "TBXML.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize mailTitle, mailDescription, mailLink, mailImageLink;

- (NSMutableArray *)subViews
{
    return subViews;
}

- (void)setSubViews
{
    subViews = [[NSMutableArray alloc] init];
    //[subViews retain];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithStory:(NewsStory *)entry
{
    if(self) { //check if it has actually been init'ed
        [self loadStory:entry];
        
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)] autorelease]];
        
        //[self setHidesBottomBarWhenPushed:YES]; //can hide bottom bar if we want to
        
        [self setMailTitle:entry.title];
        [self setMailDescription:entry.storyDescription];
        [self setMailLink:entry.link];
        [self setMailImageLink:entry.imageLink];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor blackColor]];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStory:(NewsStory *)entry
{
    int currHeight = 0; //keeps track of the current height so we can put each box under the one before
    
    UIScrollView *storyWindow = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 0, 320, 370)];         //make a scrollable view as the canvas (only works for vertical view)
    CGRect textFrame;       //make a rect to resize the textview to the height of its contents
    
    /*Image Box*/
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:entry.imageLink]]];
    UIImageView *storyImage = [[UIImageView alloc] initWithImage:image];
    float imgFactor = storyImage.frame.size.height / storyImage.frame.size.width;
    textFrame.size.width = [[UIScreen mainScreen] bounds].size.width;
    textFrame.size.height = textFrame.size.width * imgFactor;
    /* To make sure there is an image before you try to load it! */
    if(!isnan(textFrame.size.width) && !isnan(textFrame.size.height)){
        storyImage.frame = textFrame;
        currHeight += storyImage.frame.size.height;
    }
    
    /*Title Box*/
    UITextView *storyTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)];
    [storyTitle setText:entry.title];                                                   //set title string
    [storyTitle setFont:[UIFont fontWithName:@"Helvetica" size:20]];                    //font stuff
    [storyTitle sizeToFit];                                                             //make the label fit to the size of its text
    textFrame = storyTitle.frame;                                                
    textFrame.size.height = storyTitle.contentSize.height;
    storyTitle.frame = textFrame;
    storyTitle.editable = NO;
    currHeight += storyTitle.frame.size.height;                                         //update current height
    
    /*Story PubDate Box*/
    UITextView *storyDate = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)];
    [storyDate setText:entry.publicationDate];                                         //set date string
    [storyDate setFont:[UIFont fontWithName:@"Helvetica" size:14]];                    //font stuff
    [storyDate sizeToFit];                                                             //make the label fit to the size of its text
    textFrame = storyDate.frame;                                                //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyDate.contentSize.height;
    storyDate.frame = textFrame;
    storyDate.editable = NO;
    currHeight += storyDate.frame.size.height;                                         //update current height
    
    /*Story Author Box*/
    UITextView *storyAuthor = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)];
    [storyAuthor setText:entry.author];                                         //set author string
    [storyAuthor setFont:[UIFont fontWithName:@"Helvetica" size:14]];                    //font stuff
    [storyAuthor sizeToFit];                                                             //make the label fit to the size of its text
    textFrame = storyAuthor.frame;                                                //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyAuthor.contentSize.height;
    storyAuthor.frame = textFrame;
    storyAuthor.editable = NO;
    currHeight += storyAuthor.frame.size.height;                                         //update current height

    /*Story content box*/ //replace this with a method that spits out objects as necessary from the content
    
    UITextView *storyContent = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)]; //now make a box for the story content under the label
    [storyContent setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [storyContent setText:entry.storyContent];
    [storyContent setTextColor:[UIColor darkGrayColor]];
    [storyContent sizeToFit];
    textFrame = storyContent.frame;                                                     //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyContent.contentSize.height;
    storyContent.frame = textFrame;
    storyContent.editable = NO;                                                                         
    currHeight += storyContent.frame.size.height;
    
    /*rendering content into boxes*/ //currently does not work
    
    /*
    TBXML *tbxml = [[TBXML tbxmlWithXMLString:entry.storyContent] retain]; //parses content into tbxml
    currHeight = [self renderContent:tbxml.rootXMLElement currHeight:currHeight rect:textFrame];*/
    
    
    storyWindow.contentSize = CGSizeMake(storyWindow.contentSize.width, currHeight); //make the scrollable view the height of both objects
    [storyWindow addSubview:storyImage];    //add image
    [storyWindow addSubview:storyTitle];    //add title box
    [storyWindow addSubview:storyDate];    //add date box
    [storyWindow addSubview:storyAuthor];    //add author box
    [storyWindow addSubview:storyContent];
    
    /*
    NSLog(@"%@",self.subViews);
    NSInteger i = [self.subViews count];
    NSLog(@"%i",i);
    while(i != 0)
        [storyWindow addSubview:[self.subViews objectAtIndex:i--]];*/
    
    
    [self.view addSubview:storyWindow];     //add the entire thing to the master view
}


//GET RID OF THESE TWO METHODS SOON
/*  Method that runs through a string containing HTML and parses it using the TBXML
    Then calls appropriate methods to display the content found. */
- (int)renderContent:(TBXMLElement *)element
           currHeight:(int)height
                 rect:(CGRect)textFrame
{
    int currHeight = height;
    
    do {
        NSString *elementName = [TBXML elementName:element];
        NSLog(@"%@",elementName); // run this to find element names you need to process.
        if ([elementName isEqualToString:@"p"]) {
            currHeight = [self displayParagraph:[TBXML textForElement:element] currHeight:currHeight rect:textFrame];
        }
        else if ([elementName isEqualToString:@"img"]) {
            //generate an image displaying thing
        }
        
        /* Probably unnecessary since we will not be dealing with nested tags
         if (element->firstChild) {
            [self traverseElement:element->firstChild]; //recursive call! Traverses all children of element
        }*/
        
    } while ((element = element->nextSibling));
    
    return currHeight;
    
}

- (int)displayParagraph:(NSString *)text
              currHeight:(int) height
                     rect:(CGRect)textFrame
{
    UITextView *storyContent = [[UITextView alloc] initWithFrame:CGRectMake(0, height, 320, 360)]; //now make a box for the story content under the label
    [storyContent setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [storyContent setText:text];
    [storyContent setTextColor:[UIColor darkGrayColor]];
    [storyContent sizeToFit];
    textFrame = storyContent.frame;                                                     //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyContent.contentSize.height;
    storyContent.frame = textFrame;
    storyContent.editable = NO;
    
    [self.subViews addObject:storyContent];
    //NSLog(@"%@",self.subViews);
    
    return height + storyContent.frame.size.height;
}

#pragma mark Sharing methods

- (void)share
{
     //check canSendMail somewhere
	[self sendMail];
}

- (void)sendMail
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Check out this article from the Yale Daily News"];
    
    // Fill out the email body text
    NSString *appLink = @"http://itunes.apple.com/us/app/yale-daily-news/id480072824?mt=8";
    NSString *emailBody = [NSString stringWithFormat:
                           @"<html><body><h3>%@</h3>"
                           @"<p>%@</p>"
                           @"<p>... Read the rest of the article <a href = %@>here</a>.</p><p></p>"
                           @"<p>Sent from the Yale Daily News iPhone App.  "
                           @"<a href = '%@'>Download</a> yours today.</p>"
                           @"</body></html>",
                           mailTitle,
                           mailDescription,
                           mailLink,
                           appLink];
    
    //change fonts size of link
    
    [picker setMessageBody:emailBody isHTML:YES];
    
    NSData *image = [NSData dataWithContentsOfURL:[NSURL URLWithString:mailImageLink]];
    [picker addAttachmentData:image mimeType:@"image/png" fileName:@"YDNImage"];
    
    [picker.navigationBar setBarStyle:UIBarStyleBlack];
    [picker.navigationBar setTintColor:[UIColor colorWithRed:0.0588235294
                                                       green:0.301960784
                                                        blue:0.57254902
                                                       alpha:0]];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
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

//add a (void)loadAdvertisement: for future adspace?

@end
