//
//  FeedListController.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//


#import "FeedListController.h"


//keep for now -- mimi: are any of these necessary for importing? Doesn't look like it
//#import "WebViewController.h"

#import "NewsStory.h"
//#import "FavoritesList.h"

//#import "CustomFeedCell.h" //unnecessary import


//static NSString *rootFeed = @"http://www.yaledailynews.com/feed";

@implementation FeedListController

@synthesize feedURL, feedTitle, lastUpdated;

- (void)resetWithURL:(NSString *)rssFeedURL feedTitle:(NSString *)rssFeedTitle isMainFeed:(BOOL)isMain
{
    feedURL = [[NSMutableString alloc] initWithString:rssFeedURL];
    feedTitle = [[NSMutableString alloc] initWithString:rssFeedTitle];
    newsStories = [[NSMutableArray alloc] init];
    
    currentTitle = [[NSMutableString alloc] init];
    currentLink = [[NSMutableString alloc] init];
    currentDescription = [[NSMutableString alloc] init];
    currentAuthor = [[NSMutableString alloc] init];
    currentDate = [[NSMutableString alloc] init];
    currentImageLink = [[NSMutableString alloc] init];
    currentStoryContent = [[NSMutableString alloc] init];
    
    [[self navigationItem] setTitle:feedTitle];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [xmlData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    //this string contains the entire RSS feed we get from the feedURL
    NSMutableString *xmlString = [[NSMutableString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", xmlString); // this displays the stuff from the www.yaledailynews.com/feed
    
    /*REPLACE THIS SHIT*/
    /*[xmlString replaceOccurrencesOfString:@"<p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];*/
    /*REPLACE THIS SHIT*/
    
    [xmlString replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#124;" withString:@"|" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#038;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8217;" withString:@"\'" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8220;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8221;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8212;" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8213;" withString:@"-" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
    [xmlString replaceOccurrencesOfString:@"&#8216;" withString:@"\'" options:NSLiteralSearch range:NSMakeRange(0, [xmlString length])];
 
    TBXML *tbxml = [[TBXML tbxmlWithXMLString:xmlString] retain]; //parses xml into tbxml
    [xmlString release]; //don't need xml anymore
 
    // If TBXML found a root node, process element and iterate all children
    if (tbxml.rootXMLElement) { //TBXML.m does this, inits when he initialized the tbxml
        [self traverseElement:tbxml.rootXMLElement]; //Calls traverseElement
        
        //QuickFix - may not be the best method
        //Catch the last story that needs to be added (since we add the second to last story when we see the last <item> tag
        storyToAdd = [[NewsStory alloc] init]; //init here instead of above, protects against trying to make a story without an init.
        [storyToAdd loadWithTitle:currentTitle
                             link:currentLink
                      description:currentDescription //not all articles have a desc.
                             date:currentDate
                           author:currentAuthor
                          content:currentStoryContent
                        imageLink:currentImageLink];
        //NSLog(@"%@", storyToAdd);  //debug helper
        if(storyToAdd != nil) { // Tries to add a 'nil' story after the last one. This protection keeps it from breaking
            [newsStories addObject:storyToAdd];
        }
        [storyToAdd release];
        storyToAdd = nil;
    }
    
    [tbxml release];
 
    [self setLastUpdated:[NSDate date]];
    [refreshHeaderView refreshLastUpdatedDate];
    
    [xmlData release];
    xmlData = nil;
    
    [connection release];
    connection = nil;
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)conn 
  didFailWithError:(NSError *)error
{
    [connection release];
    connection = nil;
    
    [xmlData release];
    xmlData = nil;
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Could not load"
                                                 message:[error localizedDescription]
                                                delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
    [av show];
    [av autorelease];
}

#pragma mark - XMLParsing

- (void)fetchEntries
{
    NSURL *xmlURL = [NSURL URLWithString:feedURL];
    
    [xmlData release];
    xmlData = [[NSMutableData alloc] init];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:xmlURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15]; 
    // default cache policy; timeout changed from 60 sec
    
    connection = [[NSURLConnection alloc] initWithRequest:req 
                                                 delegate:self 
                                         startImmediately:YES];
}
- (void) traverseElement:(TBXMLElement *)element 
{
    //item child title, link, description child image attribute src, story child p, p, p, etc
    int firstFlag = 1;
    
    do {
        NSString *elementName = [TBXML elementName:element];
        //NSLog(@"%@",elementName); // run this to find element names you need to process.
        //Element names are the tags in the RSS feed
        //KEY NOTE: ORDER of element processing is important. Need to process the current article's desc/content
        //before it storyToAdd is initialized, or things will be off.
        if ([elementName isEqualToString:@"lastBuildDate"]) {
           [newsStories removeAllObjects];
        }
        else if ([elementName isEqualToString:@"item"]) {
            if(firstFlag) firstFlag = 0;
            else {
                storyToAdd = [[NewsStory alloc] init]; //init here instead of above, protects against trying to make a story without an init.
                [storyToAdd loadWithTitle:currentTitle
                                     link:currentLink
                              description:currentDescription //not all articles have a desc.
                                     date:currentDate
                                   author:currentAuthor
                                  content:currentStoryContent
                                imageLink:currentImageLink];
                //NSLog(@"%@", storyToAdd);  //debug helper
                if(storyToAdd != nil) { // Tries to add a 'nil' story after the last one. This protection keeps it from breaking
                    [newsStories addObject:storyToAdd];
                }
                [storyToAdd release];
                storyToAdd = nil;
                
                /* This makes sure that the image for a story do not get used in the next story if the next doesn't have an image. */
                [currentImageLink release];
                currentImageLink = nil;
                currentImageLink = [[NSMutableString alloc] init];
                 
            }
            //NSLog(@"storyToAdd: %@",storyToAdd);
        }
        else if ([elementName isEqualToString:@"title"]) {
            [currentTitle setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentTitle);
        }
        else if ([elementName isEqualToString:@"link"]) {
            [currentLink setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentLink);
        }
        else if ([elementName isEqualToString:@"pubDate"]) {
            [currentDate setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentDate);
        }
        else if ([elementName isEqualToString:@"dc:creator"]) {
            [currentAuthor setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentAuthor);
        }
        else if ([elementName isEqualToString:@"description"]) {
            [currentDescription setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentDescription);
            //NSLog(@"Description");
        }
        else if ([elementName isEqualToString:@"ydn:image"]){
            [currentImageLink setString:[TBXML textForElement: element]];
        }
        else if ([elementName isEqualToString:@"content:encoded"]) {
            [currentStoryContent setString:[TBXML textForElement:element]];
            //NSLog(@"%@",currentStoryContent); //debug
            //NSLog(@"Content"); //debug
            
            //storyToAdd is a NewsStory (declared in FeedListController.h). It is init'ed each time an <item>
            //appears in the RSS. We now are
            //initializing it with the stuff it found in the tbxml element.
        
        }
        /*
         //THIS CODE IS USELESS UNLESS WE HAVE <img> tags in the RSS feed
         //When we do add it, beware of the order
         else if ([elementName isEqualToString:@"img"] && element->firstAttribute != nil) {
            TBXMLAttribute *attribute = element->firstAttribute;
            [currentImageLink setString:[TBXML attributeValue:attribute]];
            //NSLog(@"%@",[TBXML attributeValue:attribute]);
        }*/
        
        if (element->firstChild) {
            [self traverseElement:element->firstChild]; //recursive call! Traverses all children of element
        }
        
    } while ((element = element->nextSibling));
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	reloading = YES;
    
}

- (void)doneLoadingTableViewData 	//  model should call this when its done loading
{
	reloading = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    //[self parseXMLFileAtURL:feedURL];
    [self fetchEntries];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	[super scrollViewDidScroll:scrollView];
    [refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [super scrollViewDidScroll:scrollView];
    [refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    //[feedList reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date]; // should return date data source was last changed
}



#pragma mark - View lifecycle  //do i need calls to super?

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([newsStories count] == 0) 
    {
        [self fetchEntries];
    }
    if (lastUpdated && [lastUpdated timeIntervalSinceNow] <= -10800) 
    {
        [self fetchEntries];
    }
    [self.tableView reloadData];    
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
	if (refreshHeaderView == nil) 
    {
        UINavigationBar *bar = [self.navigationController navigationBar];
        
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		refreshView.delegate = self;
		[self.tableView addSubview:refreshView];
		refreshHeaderView = refreshView;
		[refreshView release];
	}
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	//do I need to release refreshHeaderview?
    refreshHeaderView = nil;
}

#pragma mark -
#pragma mark Memory Management



- (void) dealloc
{
    refreshHeaderView = nil;
   
    [feedURL release];
    [feedTitle release];
    [lastUpdated release];
    //others already released;
    [currentTitle release];
    [currentLink release];
    [currentDescription release];
    [currentAuthor release];
    [currentStoryContent release];
    
    [super dealloc];
}
@end
