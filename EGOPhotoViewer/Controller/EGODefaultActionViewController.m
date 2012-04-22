//
//  EGODefaultActionViewController.m
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/22/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGODefaultActionViewController.h"

@interface EGODefaultActionViewController ()

@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,assign) BOOL _popover;

- (id<EGOPhoto>)photo;
- (UIActionSheet *)createActionSheet;
- (void)savePhoto;
- (void)copyPhoto;
- (void)emailPhoto;

@end

@implementation EGODefaultActionViewController

@synthesize photoSource = photoSource_;
@synthesize currentIndex = currentIndex_;

@synthesize actionSheet = actionSheet_;
@synthesize _popover;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.actionSheet == nil) {
        self.actionSheet = [self createActionSheet];
    }
    
    self.view.userInteractionEnabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.actionSheet.title = [[self.photoSource photoAtIndex:self.currentIndex] title];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.actionSheet showInView:self.view];
}

#pragma mark - Photo Helper

- (id<EGOPhoto>)photo {
    return [self.photoSource photoAtIndex:self.currentIndex];
}

#pragma mark - Create ActionSheet

- (UIActionSheet *)createActionSheet {
	
    NSString *cancelButtonTitle = @"Cancel";

    // TODO: the _popover is not being checked from the parent view controller
    // so this is a loss of functionality for the iPad for this version.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && !_popover) {
        cancelButtonTitle = nil;
    }
    
    UIActionSheet *actionSheet = nil;
    
    
	if ([MFMailComposeViewController canSendMail]) {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" 
                                                  delegate:self
                                         cancelButtonTitle:cancelButtonTitle 
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Save",@"Copy",@"Email", nil];

        
        
	} else {
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Actions" 
                                                  delegate:self
                                         cancelButtonTitle:cancelButtonTitle 
                                    destructiveButtonTitle:nil 
                                         otherButtonTitles:@"Save",@"Copy", nil];
        
    }

	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	
    return actionSheet;
	
}


#pragma mark - UIActionSheetDelegate Adherence

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		[self savePhoto];
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
		[self copyPhoto];	
	} else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
		[self emailPhoto];	
	}
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];

}

#pragma mark - Actions

- (void)savePhoto {
    
    UIImageWriteToSavedPhotosAlbum(self.photo.image,nil,nil,nil);

}

- (void)copyPhoto {
    
    [[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(self.photo.image) forPasteboardType:[self.photo.URL lastPathComponent]];

}

- (void)emailPhoto {
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    
	[mailViewController setSubject:self.photo.title];
	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(self.photo.image)] 
                                 mimeType:@"image/png" 
                                 fileName:[self.photo.URL lastPathComponent]];
    
	mailViewController.mailComposeDelegate = self;
	
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	}
	
	[self presentModalViewController:mailViewController animated:YES];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[controller dismissModalViewControllerAnimated:YES];
    
	NSString *mailError = nil;
	
	switch (result) {
		case MFMailComposeResultSent: ; break;
		case MFMailComposeResultFailed: mailError = @"Failed sending media, please try again...";
			break;
		default:
			break;
	}
	
	if (mailError != nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mailError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
}


@end
