//
//  DetailViewController.h
//  EGOPhotoViewerDemo_iPad
//
//  Created by enormego on 4/10/10April10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIPopoverControllerDelegate>

@property (nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic) id detailItem;
@property (nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
