//
//  NewsViewController.h
//  YDNNewsReader
//
//  Created by Vincent Hu on 3/1/13.
//  Copyright (c) 2013 Yale University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController

/*This is a new init method to load story text into box.*/
- (id)initWithStory:(NSString *)storyText;

@end
