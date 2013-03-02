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
    if (self) {
        [self loadStory:nil];
    }
    return self;
}

- (id)initWithStory:(NSString *)storyText
{
    
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
    UITextView *aboutStable = [[UITextView alloc] init];
    [aboutStable setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [aboutStable setText:@"If You are experiencing problems with visiting our site or contacting us, please check Your network connection"];
    [aboutStable setTextColor:[UIColor grayColor]];
    [aboutStable setBackgroundColor:[UIColor clearColor]];
    [aboutStable setTextAlignment:UITextAlignmentCenter];
    [aboutStable setFrame:CGRectMake(0, 302, 320, 79)];
    aboutStable.editable = NO;
    [self.view addSubview:aboutStable];
}

@end
