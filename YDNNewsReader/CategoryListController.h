//
//  CategoryListController.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 10/12/11.
//  Copyright 2011 Yale Daily News Publishing Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeedListController;

@interface CategoryListController : UITableViewController
{
    NSMutableArray *categories;
    NSMutableArray *feedURLs;
    
    NSMutableArray *subFeedLists;
}

@property (nonatomic, copy) NSMutableArray *categories; //readonly?; do I want these public?
@property (nonatomic, copy) NSMutableArray *feedURLs;
@property (nonatomic, readonly) NSMutableArray *subFeedLists;


@end


/* useful methods?
 – pushViewController:animated:
 – popViewControllerAnimated:
 – popToRootViewControllerAnimated:
 – popToViewController:animated: */
