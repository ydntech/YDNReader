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
    [self initWithNibName:nil bundle:nil];
    if(self) { //check if it has actually been init'ed
        [self loadStory:entry];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    UIScrollView *storyWindow = [[UIScrollView alloc]  initWithFrame:CGRectMake(0, 0, 320, 365)];         //make a scrollable view as the canvas
    CGRect textFrame;       //make a rect to resize the textview to the height of its contents
    
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
    [storyWindow addSubview:storyTitle];    //add title box
    [storyWindow addSubview:storyDate];    //add date box
    [storyWindow addSubview:storyAuthor];    //add author box
    [storyWindow addSubview:storyContent];
    
    /*NSLog(@"%@",self.subViews);
    
    NSInteger i = [self.subViews count];
    NSLog(@"%i",i);
    while(i != 0)
        [storyWindow addSubview:[self.subViews objectAtIndex:i--]];*/
    
    
    [self.view addSubview:storyWindow];     //add the entire thing to the master view
}

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

//add a (void)loadAdvertisement: for future adspace?

@end
