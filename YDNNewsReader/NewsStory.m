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

@synthesize title, link, storyDescription, imageLink, storyContent, publicationDate, author;
@synthesize thumbnail;

- (id)init
{
    return [super init];
}

- (void)loadWithTitle:(NSString *)articleTitle 
               link:(NSString *)articleLink 
        description:(NSString *)articleDescription 
               date:(NSString *)pubDate
               author:(NSString *)articleAuthor
              content:(NSString *)articleContent
          imageLink:(NSString *)imLink
{
 
    [self setTitle:articleTitle];
    //[self setLink:articleLink]; //using this instead of declaring an NUSMutableString (down below) causes entire thing to terminate.
    
    if(!articleDescription) {
        //[self setStoryDescription:title];
    } else if ([articleDescription isEqualToString:@""]) {
        //[self setStoryDescription:title];
        //NSLog(@"%@",articleDescription);
    } else {
        [self setStoryDescription:articleDescription];
    }
    
    [self setPublicationDate:pubDate];
    [self setAuthor:articleAuthor]; //might need to check if nil.
    [self setImageLink:imLink];
    
    if(!articleContent) {
        //articleContent doesn't exist somehow
    } else if ([articleContent isEqualToString:@""]) {
        //empty articleContent
    } else {
        [self setStoryContent:[self parse:articleContent]];
    }
        
    //make www. into m., if necessary --currently disabled
    NSMutableString *mobileLink = [[[NSMutableString alloc] initWithString:articleLink] autorelease];
    //[mobileLink replaceOccurrencesOfString:@"/www." withString:@"/m." options:NSLiteralSearch range:NSMakeRange(0, [mobileLink length])]; //This will renable access to a mobile site.
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

#pragma mark Parsing Stories
- (NSString *)parse:(NSString *)input {
    NSMutableString *parsed = [[NSMutableString alloc] initWithString:input];
    
    //No formatting allowed
    [parsed replaceOccurrencesOfString:@"<strong>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
     [parsed replaceOccurrencesOfString:@"</strong>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"<i>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"</i>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"<u>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"</u>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    
    //get rid of links -- NOT SURE IF THIS WORKS BUT IT DOESN'T make build fail
    NSRange start_range = [parsed rangeOfString:@"<a href="];
    NSRange end_range = [parsed rangeOfString:@"</a>"];
    NSLog(@"start range: %i", NSMaxRange(start_range));
    NSLog(@"end range: %i", NSMaxRange(start_range));
    while(NSMaxRange(start_range) != 2147483647) {
        //This number used because start_range finds this number when no <a href tags found
        [parsed replaceCharactersInRange:NSMakeRange((NSMaxRange(start_range) - 8), NSMaxRange(end_range) - NSMaxRange(start_range) + 8) withString:@""];
        start_range = [parsed rangeOfString:@"<a href="];
        end_range = [parsed rangeOfString:@"</a>"];
    }
    
    //get rid of imgs
    while(NSMaxRange(start_range) != 2147483647) {
        start_range = [parsed rangeOfString:@"<img"];
        end_range = [parsed rangeOfString:@" />"];
        NSLog(@"start range: %i", NSMaxRange(start_range));
        NSLog(@"end range: %i", NSMaxRange(end_range));
        NSLog(@"parse range: %i", NSMaxRange(NSMakeRange((NSMaxRange(start_range) - 4), NSMaxRange(end_range) - NSMaxRange(start_range) + 4)));
        [parsed replaceCharactersInRange:NSMakeRange((NSMaxRange(start_range) - 4), NSMaxRange(end_range) - NSMaxRange(start_range) + 4) withString:@""];
        start_range = [parsed rangeOfString:@"<img"];
        end_range = [parsed rangeOfString:@"/>"];
    }
    
    //get rid of extra paragraph spaces
    [parsed replaceOccurrencesOfString:@"</p>\n<p></p>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])]; //Note that the XMLstring given automatically has a \n after every </p>, but we do not see it in the view.
    [parsed replaceOccurrencesOfString:@"<p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    
    //NSString *substring = [[parsed substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return parsed;
}


#pragma mark NSCoder
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:title forKey:@"title"];
    [encoder encodeObject:link forKey:@"link"];
    [encoder encodeObject:storyDescription forKey:@"storyDescription"];
    [encoder encodeObject:publicationDate forKey:@"publicationDate"];
    [encoder encodeObject:storyContent forKey:@"storyContent"];
    [encoder encodeObject:imageLink forKey:@"imageLink"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self) {
        [self setTitle:[decoder decodeObjectForKey:@"title"]];
        [self setLink:[decoder decodeObjectForKey:@"link"]];
        [self setStoryDescription:[decoder decodeObjectForKey:@"storyDescription"]];
        [self setPublicationDate:[decoder decodeObjectForKey:@"publicationDate"]];
        [self setStoryContent: [decoder decodeObjectForKey:@"articleContent"]];
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
    [publicationDate release];
    [storyContent release];
    [imageLink release];
    [super dealloc];
}

@end
