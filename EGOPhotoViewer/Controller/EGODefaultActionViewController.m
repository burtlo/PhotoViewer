//
//  EGODefaultActionViewController.m
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/22/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGODefaultActionViewController.h"
#import <MessageUI/MessageUI.h>

@interface EGODefaultActionViewController ()

@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,assign) BOOL _popover;

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.actionSheet showInView:self.view];
}

#pragma mark - Create ActionSheet

- (UIActionSheet *)createActionSheet {
	
    NSString *cancelButtonTitle = @"Cancel";

    // TODO: the _popover is not cool zeus
    
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
    NSLog(@"Save Photo");
    //UIImageWriteToSavedPhotosAlbum(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image, nil, nil, nil);
}

- (void)copyPhoto {
    NSLog(@"Copying Photo");
//    [[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image) forPasteboardType:@"public.png"];

}

- (void)emailPhoto {
    NSLog(@"Emailing Photo");
//    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
//    
//	[mailViewController setSubject:@"Shared Photo"];
//	[mailViewController addAttachmentData:[NSData dataWithData:UIImagePNGRepresentation(((EGOPhotoImageView*)[self.photoViews objectAtIndex:_pageIndex]).imageView.image)] mimeType:@"image/png" fileName:@"Photo.png"];
//	mailViewController.mailComposeDelegate = self;
//	
//	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
//		mailViewController.modalPresentationStyle = UIModalPresentationPageSheet;
//	}
//	
//	[self presentModalViewController:mailViewController animated:YES];
	
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
	
	[self dismissModalViewControllerAnimated:YES];
	
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
