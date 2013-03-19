//
//  NewsViewController.m
//  YDNNewsReader
//
//  Created by Vincent Hu on 3/1/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

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
    
    /*Title Box*/
    UITextView *storyTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)];
    [storyTitle setText:entry.title];                                                   //set title string
    [storyTitle setFont:[UIFont fontWithName:@"Helvetica" size:15]];                    //font stuff
    [storyTitle sizeToFit];                                                             //make the label fit to the size of its text
    CGRect textFrame = storyTitle.frame;                                                //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyTitle.contentSize.height;
    storyTitle.frame = textFrame;
    storyTitle.editable = NO;
    currHeight += storyTitle.frame.size.height;                                         //update current height
    
    
    /*Story content box*/
    UITextView *storyContent = [[UITextView alloc] initWithFrame:CGRectMake(0, currHeight, 320, 360)]; //now make a box for the story content under the label
    [storyContent setFont:[UIFont fontWithName:@"Helvetica" size:13]];
    [storyContent setText:entry.storyContent];
    [storyContent setTextColor:[UIColor darkGrayColor]];
    [storyContent sizeToFit];
    textFrame = storyContent.frame;                                                     //make a rect to resize the textview to the height of its contents
    textFrame.size.height = storyContent.contentSize.height;
    storyContent.frame = textFrame;
    storyContent.editable = NO;                                                                         //don't let people edit our textview
    currHeight += storyContent.frame.size.height;
    
    
    storyWindow.contentSize = CGSizeMake(storyWindow.contentSize.width, currHeight); //make the scrollable view the height of both objects
    [storyWindow addSubview:storyTitle];    //add title box
    [storyWindow addSubview:storyContent];      //add story box
    [self.view addSubview:storyWindow];     //add the entire thing to the master view
}

//add a (void)loadAdvertisement: for future adspace?

@end
