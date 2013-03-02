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

- (id)initWithStory:(NSString *)storyText
{
    [self initWithNibName:nil bundle:nil];
    if(self) { //check if it has actually been init'ed
        [self loadStory:storyText];
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

- (void)loadStory: (NSString *)story
{
    //lets add something here to parse the story string before actually putting it out?
    //Also add and parse the title
    
    UITextView *aboutStable = [[UITextView alloc] init];
    [aboutStable setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [aboutStable setText:story];
    [aboutStable setTextColor:[UIColor grayColor]];
    [aboutStable setBackgroundColor:[UIColor clearColor]];
    [aboutStable setTextAlignment:UITextAlignmentCenter];
    [aboutStable setFrame:CGRectMake(0, 0, 320, 300)];
    aboutStable.editable = NO;
    [self.view addSubview:aboutStable];
}

//add a (void)loadAdvertisement: for future adspace?

@end
