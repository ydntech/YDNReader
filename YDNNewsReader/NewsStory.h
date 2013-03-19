//
//  NewsStory.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsStory : NSObject <NSCoding> //need to write implementations for initwithcoder, encode with coder
{
    NSString *title;
    NSString *link;
    NSString *storyDescription;
    NSString *publicationDate;
    NSString *author;
    NSString *storyContent;
    NSString *imageLink;
}


- (void)loadWithTitle:(NSString *)articleTitle 
               link:(NSString *)articleLink 
        description:(NSString *)articleDescription 
               date:(NSString *)pubDate
               author: (NSString *)articleAuthor
              content:(NSString *)articleContent
          imageLink:(NSString *)imLink;

@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *storyDescription;
@property (nonatomic, copy) NSString *publicationDate;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *storyContent;
@property (nonatomic, copy) NSString *imageLink;

@property (nonatomic, retain) UIImage *thumbnail;

@end
