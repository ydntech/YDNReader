//
//  FavoritesList.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/14/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import "FavoritesList.h"
#import "NewsStory.h"

static FavoritesList *favoritesList = nil;

@implementation FavoritesList

//@synthesize numFavorites;

+ (FavoritesList *)defaultFavorites
{
    if (!favoritesList)
    {
        favoritesList = [[super allocWithZone:NULL] init];
    }
    return favoritesList;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self defaultFavorites];
}

- (id)init
{
    if (favoritesList) {
        return favoritesList;
    }
    
    self = [super init];

    
    return self;
}

- (void)fetchFavorites
{
    if(!favoriteStories) {
        NSString *path = [self archivePath];
        favoriteStories = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
    }
    
    if(!favoriteStories) {
        favoriteStories = [[NSMutableArray alloc] init];
    }
}
- (NSArray *)favoriteStories
{
    [self fetchFavorites];
    return favoriteStories;
}


- (NSString *)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentsDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"favorites.data" ];
}

- (BOOL)save
{
    NSLog(@"saved");
    return [NSKeyedArchiver archiveRootObject:favoriteStories toFile:[self archivePath]];
    
}

- (BOOL)addToFavorites:(NewsStory *)story
{
    [self fetchFavorites];
    
    if ([favoriteStories count] == 10) {
        NSLog(@"Already at maximum size");
        return NO;
    }
    [favoriteStories addObject:story];
    return YES;
}

//check this and implementation of isEqual in NewsStory
- (BOOL)removeFromFavorites:(NewsStory *)story
{
    //[self fetchFavorites];
    //changed to new version of Favorites
    if ([self isFavorite:[story title]]) {
        [favoriteStories removeObject:story];
        return YES;
    }
    return NO;
}

- (BOOL)removeFromFavoritesAtIndex:(int)index
{
    if (index >= 0 && index < [favoriteStories count]) { //is this necessary?
        [favoriteStories removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}
//changed to search by title
- (BOOL)isFavorite:(NSString *)storyTitle  //(NewsStory *)story
{
    for(NewsStory *favorite in favoriteStories)
    {
        if ([storyTitle isEqualToString:[favorite title]]) 
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark Memory Management

- (id)retain
{
    return self;
}

- (void)release
{
    
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

@end
