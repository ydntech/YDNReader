//
//  NewsStory.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import "NewsStory.h"

//static NSRange wwwRange = {7, 3};


@implementation NewsStory

@synthesize title, link, storyDescription, imageLink; //publicationDate
@synthesize thumbnail;

- (id)init
{
    return [super init];
}

- (void)loadWithTitle:(NSString *)articleTitle 
               link:(NSString *)articleLink 
        description:(NSString *)articleDescription 
         //      date:(NSString *)pubDate 
          imageLink:(NSString *)imLink
{
 
    [self setTitle:articleTitle];
    //[self setLink:articleLink]; //using this instead of declaring an NUSMutableString (down below) causes entire thing to terminate.
    
    if(!articleDescription) {
        [self setStoryDescription:title];
    } else if ([articleDescription isEqualToString:@""]) {
        [self setStoryDescription:title];
    } else {
        [self setStoryDescription:articleDescription];
    }
    
    //[self setPublicationDate:pubDate];
    [self setImageLink:imLink];
        
    //make www. into m., if necessary --currently disabled
    NSMutableString *mobileLink = [[[NSMutableString alloc] initWithString:articleLink] autorelease];
    //NSLog(@"%@",articleLink); //load link in the table view. Nothing triggers here when clicking the story itself. HERE IS NOT THE PROBLEM.
    //[mobileLink replaceOccurrencesOfString:@"/www." withString:@"/m." options:NSLiteralSearch range:NSMakeRange(0, [mobileLink length])];
    [self setLink:mobileLink];
   
}

- (BOOL)isEqual:(id)anObject
{
    if([anObject isMemberOfClass:[self class]]) {
        if ([title isEqualToString:[anObject title]]) {
            return YES;
        }
    }
    return NO;
}


#pragma mark NSCoder
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:link forKey:@"link"];
    [encoder encodeObject:storyDescription forKey:@"storyDescription"];
    //[encoder encodeObject:publicationDate forKey:@"publicationDate"];
    [encoder encodeObject:imageLink forKey:@"imageLink"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        [self setLink:[decoder decodeObjectForKey:@"link"]];
        [self setStoryDescription:[decoder decodeObjectForKey:@"storyDescription"]];
        //[self setPublicationDate:[decoder decodeObjectForKey:@"publicationDate"]];
        [self setImageLink:[decoder decodeObjectForKey:@"imageLink"]];
        
        [self setThumbnail:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageLink]]]];
    }
    
    return self;
}

#pragma mark Memory Management

- (void)dealloc
{
    [title release];
    [link release];
    [storyDescription release];
    //[publicationDate release];
    [imageLink release];
    [super dealloc];
}

@end
