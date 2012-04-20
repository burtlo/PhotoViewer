//
//  DetailViewController.m
//  EGOPhotoViewerDemo_iPad
//
//  Created by enormego on 4/10/10April10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "RootViewController.h"
#import "EGOPhotoViewController.h"

@interface DetailViewController ()

@property (nonatomic) UIPopoverController *popoverController;

- (void)configureView;

@end



@implementation DetailViewController

@synthesize toolbar = toolbar_;
@synthesize popoverController = popoverController_;
@synthesize detailItem = detailItem_;
@synthesize detailDescriptionLabel = detailDescriptionLabel_;

#pragma mark - View Lifecycle

- (void)viewDidLoad{
	[super viewDidLoad];
	
	UIBarButtonItem *imagesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photosButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showPhotoView:)];
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixed.width = 40.0f;
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	[self.toolbar setItems:[NSArray arrayWithObjects:flex, imagesButton, fixed, nil]];
	
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.popoverController = nil;
}

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(id)newDetailItem {
    if (detailItem_ != newDetailItem) {
        detailItem_ = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
	
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView {
    // Update the user interface for the detail item.
    self.detailDescriptionLabel.text = [self.detailItem description];   
}


#pragma mark - Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
	
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	
	
    self.popoverController = nil;
}


#pragma mark - Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
	if (self.popoverController) {
		[self.popoverController dismissPopoverAnimated:YES];
	}
	
}

#pragma mark - EGOPhotoViewer Popover

- (void)showPhotoView:(UIBarButtonItem*)sender{
	
	EGODefaultPhoto *webPhoto = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"http://a3.twimg.com/profile_images/66601193/cactus.jpg"] name:@" laksd;lkas;dlkaslkd ;a"];
	EGODefaultPhoto *filePathPhoto = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"local_image_2" ofType:@"jpg"]]];
	EGODefaultPhoto *inMemoryPhoto = [[EGODefaultPhoto alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"local_image_1" ofType:@"jpg"]]];

	EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:webPhoto, filePathPhoto, inMemoryPhoto, nil]];

	EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
	photoController.contentSizeForViewInPopover = CGSizeMake(480.0f, 480.0f);
	
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navController];
	popover.delegate = self;
	[popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
	self.popoverController = popover;
	
	 
	 
}

#pragma mark Popover Delegate Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController{
	self.popoverController=nil;
}


@end
