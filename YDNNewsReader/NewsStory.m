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
    
    //makes pubDate less ugly
    NSMutableString *parsedPubDate = [[NSMutableString alloc] initWithString:pubDate];
    [parsedPubDate replaceOccurrencesOfString:@"+0000" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsedPubDate length])];
    
    [self setPublicationDate:parsedPubDate];
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
    
    /* SPECIAL FORMATTING PARSES */
        //Known tags: strong, b, i, u, li, em
        //All tags not specifically parsed for will be processed later by regular exp.
    [parsed replaceOccurrencesOfString:@"<b>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"</b>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"<br />" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    
    /*GET RID OF VIDEOS */
    NSRange start_range = [parsed rangeOfString:@"<iframe"];
    NSRange end_range = [parsed rangeOfString:@"</iframe>"];
    while(NSMaxRange(start_range) != 2147483647) {
        [parsed replaceCharactersInRange:NSMakeRange((NSMaxRange(start_range) - 7), NSMaxRange(end_range) - NSMaxRange(start_range) + 7) withString:@"[App unable to render video, please view article in browser (click link below)]"];
        start_range = [parsed rangeOfString:@"<iframe"];
        end_range = [parsed rangeOfString:@"</iframe>"];
    }
    
    
    /* PARSE PARAGRAPHS */
        //Note that the XMLstring given automatically has a \n after every </p>, but we do not see it in the view.
    //[parsed replaceOccurrencesOfString:@"<p>" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    [parsed replaceOccurrencesOfString:@"</p>" withString:@"\n" options:NSLiteralSearch range:NSMakeRange(0, [parsed length])];
    
    /* CATCH-ALL FOR ALL OTHER FORMATTING TAGS */
        //Will catch and remove anything with brackets < and >
        //Note the .*? is important otherwise .* will match the > character as well and erase huge amounts of text
    NSString *bracketParse = [[NSRegularExpression regularExpressionWithPattern:@"<.*?>"
                                                 options:0
                                                 error:NULL]
                             stringByReplacingMatchesInString:parsed
                             options:0
                             range:NSMakeRange(0, [parsed length])
                             withTemplate:@""];
    
    /* DEAL WITH MULTIPLE \n IN A ROW*/
    NSString * whiteParse = [[NSRegularExpression regularExpressionWithPattern:@"\\n+"
                                               options:0
                                                 error:NULL]
                             stringByReplacingMatchesInString:bracketParse
                             options:0
                             range:NSMakeRange(0, [bracketParse length])
                             withTemplate:@"\n\n"];
    
    [parsed release]; //release for memory management
    return whiteParse;
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
