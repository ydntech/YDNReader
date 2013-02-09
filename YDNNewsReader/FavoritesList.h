//
//  FavoritesList.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/14/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NewsStory;

@interface FavoritesList : NSObject
{
    NSMutableArray *favoriteStories;
    //NSDictionary implement as this; give a count with the number of items; limit to 10
    //NSMutableDictionary *favoriteStories;
    //int numFavorites;
}

+ (FavoritesList *)defaultFavorites;
- (void)fetchFavorites;

- (NSArray *)favoriteStories;
//- (NSDictionary *)favoriteStories;
//@property (nonatomic, readonly) int numFavorites;

- (BOOL)addToFavorites:(NewsStory *)story;
- (BOOL)removeFromFavorites:(NewsStory *)story;
- (BOOL)removeFromFavoritesAtIndex:(int)index;
- (BOOL)isFavorite:(NSString *)storyTitle;//(NewsStory *)story; 

- (NSString *)archivePath;
- (BOOL)save;
@end
