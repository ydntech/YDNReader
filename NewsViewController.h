//
//  NewsViewController.h
//  YDNNewsReader
//
//  Created by Vincent Hu on 3/1/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsStory.h"

@interface NewsViewController : UIViewController
{
    NSMutableArray *subViews;
}

- (NSMutableArray *)subViews;
- (void)setSubViews;

/*This is a new init method to load story text into box.*/
- (id)initWithStory:(NewsStory *)entry;

@end
