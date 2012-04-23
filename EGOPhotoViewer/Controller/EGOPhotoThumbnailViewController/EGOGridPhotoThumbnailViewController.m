//
//  EGOGridPhotoThumbnailView.m
//  Mobile
//
//  Created by Frank Webber on 9/12/11.
//  Copyright 2011 Wetpaint, Inc. All rights reserved.
//

#import "EGOGridPhotoThumbnailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EGOGridPhotoThumbnailViewController ()

@property (nonatomic,retain) UILabel *galleryTitle;
@property (nonatomic,retain) UILabel *galleryDescription;

@property (nonatomic,retain) UIScrollView *photoScrollView;

- (void)layoutTitleAndDescription;
- (void)layoutPhotos;

@end

@implementation EGOGridPhotoThumbnailViewController

@synthesize thumbnailSelectedDelegate = thumbnailSelectedDelegate_;

@synthesize photoSource = photoSource_;
@synthesize currentIndex = currentIndex_;
@synthesize embeddedInPopover = embeddedInPopover_;

@synthesize selectedBorderColor = selectedBorderColor_;
@synthesize borderColor = borderColor_;

@synthesize galleryTitle = galleryTitle_;
@synthesize galleryDescription = galleryDescription_;
@synthesize photoScrollView = photoScrollView_;


#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Properties

- (void)setEmbeddedInPopover:(BOOL)embeddedInPopover {

    embeddedInPopover_ = embeddedInPopover;
    
    if (embeddedInPopover) {
        self.modalPresentationStyle = UIModalTransitionStyleCoverVertical;
    } else {
        self.modalPresentationStyle = UIModalTransitionStylePartialCurl;
    }
    
}

# pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.view.backgroundColor = [UIColor blackColor];
	
	UIScrollView *scrollView = [[UIScrollView alloc] init];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	scrollView.delegate = self;

	scrollView.bounds = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
	scrollView.alwaysBounceVertical = YES;
    
	self.photoScrollView = scrollView;

	UILabel *title = [[UILabel alloc] init];
	title.backgroundColor = [UIColor clearColor];
	title.lineBreakMode = UILineBreakModeWordWrap;
	title.numberOfLines = 0;
	title.font = [UIFont boldSystemFontOfSize:16.0];
	title.textColor = [UIColor whiteColor];
	title.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    title.isAccessibilityElement = YES;
    title.accessibilityLabel = @"gallery-title";
    
	self.galleryTitle = title;
	
	UILabel *description = [[UILabel alloc] init];
	description.backgroundColor = [UIColor clearColor];
	description.lineBreakMode = UILineBreakModeWordWrap;
	description.numberOfLines = 0;
	description.font = [UIFont fontWithName:@"Georgia" size:12.0];
	description.textColor = [UIColor whiteColor];
	description.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    description.isAccessibilityElement = YES;
    description.accessibilityLabel = @"gallery-description";
    
    self.galleryDescription = description;
	
	[self.view addSubview:self.photoScrollView];

	[self.photoScrollView addSubview:self.galleryTitle];
	[self.photoScrollView addSubview:self.galleryDescription];
	
    if (self.borderColor == nil) {
        self.borderColor = [UIColor whiteColor];
    }
    
    if (self.selectedBorderColor == nil) {
        self.selectedBorderColor = [UIColor purpleColor];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float scrollViewWidth = self.view.frame.size.width;
    float scrollViewHeight = self.view.frame.size.height;
    
    if (self.embeddedInPopover) {
        scrollViewWidth = self.parentViewController.view.frame.size.width;
        scrollViewHeight = self.parentViewController.view.frame.size.height;
    }
    
    self.photoScrollView.frame = CGRectMake(0.0, 0.0, scrollViewWidth, scrollViewHeight);
    
    [self layoutPhotos];
    [self layoutTitleAndDescription];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)layoutTitleAndDescription {
    
    int width = self.photoScrollView.frame.size.width;

    if ([self.photoSource respondsToSelector:@selector(sourceTitle)]) {
        
        // Find the size of the title and update the frame
        [self.galleryTitle setText:self.photoSource.sourceTitle];
        
        CGSize titleSize = [[self.galleryTitle text] sizeWithFont:self.galleryTitle.font
                                                constrainedToSize:CGSizeMake(width - 20.0, 120.0) 
                                                    lineBreakMode:self.galleryTitle.lineBreakMode];
        
        self.galleryTitle.frame = CGRectMake(10.0, 70.0, titleSize.width, titleSize.height);
        

    }
    
    if ([self.photoSource respondsToSelector:@selector(sourceDescription)]) {
        
        // Find the size of the description and update the frame
        [self.galleryDescription setText:self.photoSource.sourceDescription];
        
        CGSize descriptionSize = [[self.galleryDescription text] sizeWithFont:self.galleryDescription.font
                                                            constrainedToSize:CGSizeMake(width - 20.0, 1000.0) 
                                                                lineBreakMode:self.galleryDescription.lineBreakMode];
        
        
        CGFloat titleOffset = self.galleryTitle.frame.origin.y + self.galleryTitle.frame.size.height;
        
        if ( UIInterfaceOrientationIsPortrait([self interfaceOrientation]) ) {
            titleOffset = titleOffset + 10.0;
        }
        
        self.galleryDescription.frame = CGRectMake(10.0, titleOffset, descriptionSize.width, descriptionSize.height);

        
    }
}

- (void)layoutPhotos {
	
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    float yPadding = 30.0;
    
    if (self.embeddedInPopover) { 
        
        width = self.parentViewController.view.frame.size.width;
        height = self.parentViewController.view.frame.size.height;

    } else if ( UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ) {
        
        // When we are in landscape mode we need to use the height value as the width
        // to determine the available space that we can place images. This is also
        // used to determine where to move the space for the selected images.
        
        width = self.parentViewController.view.frame.size.height;
        height = self.parentViewController.view.frame.size.width;
        yPadding = 0.0;
    }
    
    float photoWidth = 100.0;
    
    int photosPerRow = width / photoWidth;
    float padding = (width - (photosPerRow * photoWidth)) / (photosPerRow + 1);
    
    
	// Determine the initial offset from the top which is based on the size 
	// of the title and the description.
	
	float initialYOffset = MAX(50.0,self.galleryDescription.frame.origin.y + self.galleryDescription.frame.size.height);
    
    
	
	if ( self.photoSource ) {
		
        // Stores the y position of the selected image, which is used later to position
        // the current view to that position.
        float selectedYPosition = 0;
        
		for (int index = 0; index < self.photoSource.numberOfPhotos; index++) {
            
			id<EGOPhoto> photo = [self.photoSource.photos objectAtIndex:index];
			
			// Load the contents of the photo through the EGO Photo Loader and notify this class
			// when that is complete.
			
			UIImage *photoThumbnail = [[EGOImageLoader sharedImageLoader] imageForURL:[photo thumbnailURL] shouldLoadWithObserver:self];
			
			// Determine the row and column of the photo
			
			int column = index % photosPerRow;
			
			int row = index / photosPerRow;
			
			// Translate the row and the column to origin x and origin y
			
			float xPosition = (padding * (column + 1)) + (photoWidth * column);
			
			float yPosition = (padding * row) + (photoWidth * row) + yPadding + initialYOffset;
			
            
			UIButton *thumbnailImage = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, yPosition, photoWidth, photoWidth)];
            
            UIColor *borderColor = nil;
            
			if ( self.currentIndex == index ) {
                borderColor = self.selectedBorderColor;
                
                // Store the yPosition so that we can scroll the view down to this button
                selectedYPosition = yPosition + photoWidth / 2;

            } else {
                borderColor = self.borderColor;
            }
                                                    
            // Add a highlight around the selected image
            thumbnailImage.layer.borderColor = borderColor.CGColor;
            thumbnailImage.layer.borderWidth = 2.0;
            
            
			[thumbnailImage setIsAccessibilityElement:YES];
			[thumbnailImage setAccessibilityLabel:[NSString stringWithFormat:@"thumbnail-%@",[NSNumber numberWithInt:index]]];
			
			// UI Elements with no tag set will default to 0, so we need to start 
			// counting from 1 and upward so it is not confused with other untagged
			// elements.
			[thumbnailImage setTag:(index + 1)];
			
			[thumbnailImage addTarget:self action:@selector(selectedGalleryAtIndex:) forControlEvents:UIControlEventTouchUpInside];
			
			if ( photoThumbnail ) {
				[thumbnailImage setImage:photoThumbnail forState:UIControlStateNormal];
			}
			
			[self.photoScrollView addSubview:thumbnailImage];
			
			// Update content area of the scroll view for our new photo we have just added
			
			[self.photoScrollView setContentSize:CGSizeMake(width, yPosition + photoWidth + yPadding)];
			
		}
        
        
        float startAtPosition = selectedYPosition - (photoWidth/2);
        
        if (startAtPosition < self.photoScrollView.frame.size.height) {
            startAtPosition = 0;
        }
        
        if (startAtPosition + self.photoScrollView.frame.size.height > self.photoScrollView.contentSize.height) {
            
            startAtPosition = self.photoScrollView.contentSize.height - self.photoScrollView.frame.size.height;
            
        }
        
        [self.photoScrollView setContentOffset:CGPointMake(0.0,startAtPosition) animated:NO];

	}
}

# pragma mark - Load Image

- (void)selectedGalleryAtIndex:(id)galleryImage {
	
	if ( self.thumbnailSelectedDelegate && [self.thumbnailSelectedDelegate respondsToSelector:@selector(thumbnailViewController:selectedPhotoAtIndex:)] ) {
		
		// Thumbnails are tagged starting from 1 and continuing upward. This needs to be
		// translated to an index as if they were in an array.
		[self.thumbnailSelectedDelegate thumbnailViewController:self selectedPhotoAtIndex:([galleryImage tag] - 1)];
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
	}
	
}


# pragma mark - Image Load Events

- (void)imageLoaderDidLoad:(NSNotification *)notification {
	if ([notification userInfo] == nil) return;
	
	// From the url find the position within the thumbnail grid and update that button
	
	for (int index = 0; index < self.photoSource.numberOfPhotos; index++) {
		
		id<EGOPhoto> photo = [self.photoSource.photos objectAtIndex:index];
		
		if ( [[notification userInfo] objectForKey:@"imageURL"] == [photo thumbnailURL] ) {
			// when we have a match we need use the index to find the button to update it with the image
			
			UIButton *photoButton = (UIButton *)[self.photoScrollView viewWithTag:(index + 1)];
			
			[photoButton setImage:[[notification userInfo] objectForKey:@"image"] forState:UIControlStateNormal];
			[photoButton setNeedsDisplay];
		}
	}
	
}

- (void)imageLoaderDidFailToLoad:(NSNotification *)notification {
	if ([notification userInfo] == nil) return;
}

@end
