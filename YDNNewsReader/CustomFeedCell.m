//
//  CustomFeedCell.m
//  YDNNewsReader
//
//  Created by Daniel Tahara on 12/1/11.
//  Copyright 2013 Yale University. All rights reserved.
//

#import "CustomFeedCell.h"

@implementation CustomFeedCell
@synthesize delegate;
@synthesize thumbnailURL, articleLink, date, author, content;
@synthesize titleLabel, descriptionLabel;
@synthesize favoritesButton, backButton, shareButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
 
    if (self) {
 
        UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        UIFont *descriptionFont = [UIFont fontWithName:@"Helvetica" size:12];
 
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //[self.titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
        [self.titleLabel setFont:titleFont];
        [self.titleLabel setNumberOfLines:0];
        [[self contentView] addSubview:titleLabel];
        //[titleLabel release];
        // It is being retained by its superview
 
        descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.descriptionLabel setFont:descriptionFont];
        [self.descriptionLabel setNumberOfLines:0];
        [[self contentView] addSubview:descriptionLabel];
        //[descriptionLabel release];
 
        NSString *placeholderImage = [[NSBundle mainBundle] pathForResource:@"Icon" 
                                                                    ofType:@"png"];
        thumbnailImage = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageWithContentsOfFile:placeholderImage]];
        [[self contentView] addSubview:thumbnailImage];
        //[thumbnailImage release];
         
        favoritesButton = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *unfilledStarPath = [[NSBundle mainBundle] pathForResource:@"28-star-empty"
                                                                     ofType:@"png"];
        NSString *starPath = [[NSBundle mainBundle] pathForResource:@"28-star"
                                                            ofType:@"png"];
        [favoritesButton setImage:[UIImage imageWithContentsOfFile:unfilledStarPath] forState:UIControlStateNormal];
        [favoritesButton setImage:[UIImage imageWithContentsOfFile:starPath] forState:UIControlStateSelected];
        [favoritesButton addTarget:self action:@selector(favoritesButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
        //don't release this one?
        
        
        shareButton = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *sharePath = [[NSBundle mainBundle] pathForResource:@"18-envelope"
                                                             ofType:@"png"];
        //[favoritesButton setImage:[UIImage imageWithContentsOfFile:starPath] forState:UIControlStatHighlighted];
        [shareButton setImage:[UIImage imageWithContentsOfFile:sharePath] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

        
        backButton = [[UIButton alloc] initWithFrame:CGRectZero];
        NSString *backPath = [[NSBundle mainBundle] pathForResource:@"Cancel_128x128"
                                                              ofType:@"png"];
        //[favoritesButton setImage:[UIImage imageWithContentsOfFile:starPath] forState:UIControlStatHighlighted];
        [backButton setImage:[UIImage imageWithContentsOfFile:backPath] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
         
    }
    return self;
}

/*
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
 */
- (void)resetCellWithTitle:(NSString *)title
               description:(NSString *)description
                      date:(NSString *)publicationDate
                    author:(NSString *)storyAuthor
                   content:(NSString *)storyContent
                  imageURL:(NSString *)url
               articleLink:(NSString *)link
{
    [titleLabel setText:title];
    [descriptionLabel setText:description];
    [self setDate:publicationDate];
    [self setAuthor:storyAuthor];
    [self setContent:storyContent];
    [self setThumbnailURL:url];
    [self setArticleLink:link];
    
    if ([self.thumbnailURL isEqualToString:@""])
    {
        [thumbnailImage setImageURL:nil];
    } 
    else 
    {
        [thumbnailImage setImageURL:[NSURL URLWithString:self.thumbnailURL]];
    }
    
    [self setNeedsDisplay];
}

- (void)favoritesButtonWasTapped:(UIButton *)button 
{
	if ([delegate respondsToSelector:@selector(cellFavoritesButtonWasTapped:)])
    {
        NSLog(@"custom cell: isSelected %@", ([self.favoritesButton isSelected]) ? @"YES" : @"NO");
        [self.favoritesButton setSelected:![self.favoritesButton isSelected]];
        NSLog(@"custom cell: set isSelected to %@", ([self.favoritesButton isSelected]) ? @"YES" : @"NO");
        [delegate cellFavoritesButtonWasTapped:self];
	}
}

- (void)backButtonWasTapped:(UIButton *)button {
	
	if ([delegate respondsToSelector:@selector(cellBackButtonWasTapped:)]){
		[delegate cellBackButtonWasTapped:self];
	}
}

- (void)shareButtonWasTapped:(UIButton *)button 
{
	if ([delegate respondsToSelector:@selector(cellShareButtonWasTapped:)])
    {
        [delegate cellShareButtonWasTapped:self];
	}
}

- (void)backViewWillAppear 
{
    NSLog(@"customCell: backview isSelected1 %@", ([favoritesButton isSelected]) ? @"YES" : @"NO");
    if ([[FavoritesList defaultFavorites] isFavorite:[titleLabel text]]) 
    {
        [favoritesButton setSelected:YES]; //this code should catch if story already appears in favorites.
    }
    NSLog(@"customCell: backview isSelected2 %@", ([favoritesButton isSelected]) ? @"YES" : @"NO");
    
	[self.backView addSubview:favoritesButton];
    [self.backView addSubview:shareButton];
    [self.backView addSubview:backButton];
}

- (void)backViewDidDisappear 
{
	// Remove any subviews from the backView.
	
	for (UIView * subview in self.backView.subviews)
    {
		[subview removeFromSuperview];
	}
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect 
{	
    //[super drawContentView:rect];
    //need bit masks to adjust sizes
	UIColor * textColour = (self.selected || self.highlighted) ? [UIColor whiteColor] : [UIColor blackColor];	
	[textColour set];
    
    double cellHeight = rect.size.height;
    double cellWidth = rect.size.width;
    
    double inset = 10.0;
    double verticalInset;
    double verticalPad = 2; //cellHeight / 45;
    double horizontalPad = 5; //cellHeight / 18
    CGSize imageSize = CGSizeMake(cellHeight - 2 * inset, cellHeight - 2 * inset);
    
    double textWidth;
    double maxTitleHeight = cellWidth / 3.0;
    double maxDescriptionHeight = cellHeight / 2.0;
    CGSize titleSize, descriptionSize;
    
    CGRect titleFrame, descriptionFrame, imageFrame;
    
    if ([[self thumbnailURL] isEqualToString:@""]) {
        
        textWidth = cellWidth - 2 * inset;
        
        //need to hide image
        imageFrame = CGRectZero;
        //rather than make it CGrect zero, maybe remove from subview, retain, and then add back/release?
    
    } else {
        
        textWidth = cellWidth - inset - horizontalPad - imageSize.width - inset;
        
        imageFrame = CGRectMake(inset + textWidth + horizontalPad, inset, imageSize.width, imageSize.height);
    } 
    
    titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font
                      constrainedToSize:CGSizeMake(textWidth, maxTitleHeight) 
                          lineBreakMode:UILineBreakModeTailTruncation];
    descriptionSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font
                                  constrainedToSize:CGSizeMake(textWidth, maxDescriptionHeight)
                                      lineBreakMode:UILineBreakModeTailTruncation];
    verticalInset = (cellHeight - titleSize.height - verticalPad - descriptionSize.height) / 2;
    
    titleFrame = CGRectMake(inset, verticalInset, titleSize.width, titleSize.height);
    descriptionFrame = CGRectMake(inset, verticalInset + verticalPad + titleSize.height, descriptionSize.width, descriptionSize.height);
    
    [titleLabel setFrame:titleFrame];
    [descriptionLabel setFrame:descriptionFrame];
    [thumbnailImage setFrame:imageFrame];
    
}

- (void)drawBackView:(CGRect)rect {
	
	NSString *meshpatternPath = [[NSBundle mainBundle] pathForResource:@"meshpattern" 
                                                                ofType:@"png"];
    [[UIImage imageWithContentsOfFile:meshpatternPath] drawAsPatternInRect:rect];
	[self drawShadowsWithHeight:10 opacity:0.3 InRect:rect forContext:UIGraphicsGetCurrentContext()];
    
    double cellHeight = rect.size.height;
    double cellWidth = rect.size.width;
    double favoritesImageHeight = favoritesButton.imageView.image.size.height;
    double favoritesImageWidth = favoritesButton.imageView.image.size.width;
	[favoritesButton setFrame:CGRectMake( 2 * (cellWidth / 4) - (favoritesImageWidth / 2), (cellHeight - favoritesImageHeight) / 2, favoritesImageWidth, favoritesImageHeight)];
    double shareImageHeight = shareButton.imageView.image.size.height;
    double shareImageWidth = shareButton.imageView.image.size.width;
	[shareButton setFrame:CGRectMake( 3 * (cellWidth / 4) - (shareImageWidth / 2), (cellHeight - shareImageHeight) / 2, shareImageWidth, shareImageHeight)];
    double backImageHeight = 26;//backButton.imageView.image.size.height;
    double backImageWidth = 26;//backButton.imageView.image.size.width;
	[backButton setFrame:CGRectMake( (cellWidth / 4) - (backImageWidth / 2), (cellHeight - backImageHeight) / 2, backImageWidth, backImageHeight)];
   
}

- (void)drawShadowsWithHeight:(CGFloat)shadowHeight opacity:(CGFloat)opacity InRect:(CGRect)rect forContext:(CGContextRef)context {
	
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	
	CGFloat topComponents[8] = {0, 0, 0, opacity, 0, 0, 0, 0};
	CGGradientRef topGradient = CGGradientCreateWithColorComponents(space, topComponents, nil, 2);
	CGPoint finishTop = CGPointMake(rect.origin.x, rect.origin.y + shadowHeight);
	CGContextDrawLinearGradient(context, topGradient, rect.origin, finishTop, kCGGradientDrawsAfterEndLocation);
	
	CGFloat bottomComponents[8] = {0, 0, 0, 0, 0, 0, 0, opacity};
	CGGradientRef bottomGradient = CGGradientCreateWithColorComponents(space, bottomComponents, nil, 2);
	CGPoint startBottom = CGPointMake(rect.origin.x, rect.size.height - shadowHeight);
	CGPoint finishBottom = CGPointMake(rect.origin.x, rect.size.height);
	CGContextDrawLinearGradient(context, bottomGradient, startBottom, finishBottom, kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(topGradient);
	CGGradientRelease(bottomGradient);
}


/*
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
} 

- (void)dealloc {
    [titleLabel release];
    [descriptionLabel release];
    [date release];
    [author release];
    [content release];
    [thumbnailURL release];
    [thumbnailImage release];
    [articleLink release];
    [favoritesButton release];
    [shareButton release];
    [backButton release];
    
    [super dealloc];
}
@end
