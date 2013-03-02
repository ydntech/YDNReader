//
//  CustomFeedCell.h
//  YDNNewsReader
//
//  Created by Daniel Tahara on 12/1/11.
//  Copyright 2013 Yale University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOImageView.h"
#import "TISwipeableTableView.h"
#import "FavoritesList.h"

@class CustomFeedCell;

@protocol CustomFeedCellDelegate <NSObject>
- (void)cellFavoritesButtonWasTapped:(CustomFeedCell *)cell;
- (void)cellShareButtonWasTapped:(CustomFeedCell *)cell;
- (void)cellBackButtonWasTapped:(CustomFeedCell *)cell;
@end

@interface CustomFeedCell : TISwipeableTableViewCell {
	
	id <CustomFeedCellDelegate> delegate;
    
    UILabel *titleLabel, *descriptionLabel;
    NSString *thumbnailURL;
    EGOImageView *thumbnailImage;
    NSString *articleLink;
    
    UIButton *favoritesButton;
    UIButton *shareButton;
    UIButton *backButton;
}

@property (nonatomic, copy) NSString *thumbnailURL, *articleLink;
@property (nonatomic, readonly) UILabel *titleLabel, *descriptionLabel;
@property (nonatomic, readonly) UIButton *favoritesButton, *shareButton, *backButton;

- (void)resetCellWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSString *)url articleLink:(NSString *)link;

- (void)favoritesButtonWasTapped:(UIButton *)button;
- (void)shareButtonWasTapped:(UIButton *)button;
- (void)backButtonWasTapped:(UIButton *)button;

@property (nonatomic, assign) id <CustomFeedCellDelegate> delegate;

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context;

@end