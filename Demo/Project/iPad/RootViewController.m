//
//  RootViewController.m
//  MyPhotoViewerDemo_iPad
//
//  Created by enormego on 4/10/10April10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "EGOPhotoGlobal.h"

@implementation RootViewController

@synthesize detailViewController = detailViewController_;


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"MyPhotoViewer";
	self.tableView.delegate = self;
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
  	cell.textLabel.text = indexPath.row == 0 ? @"Photos" : @"Single Photo";
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	if (indexPath.row == 0) {
		
		EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"http://a3.twimg.com/profile_images/66601193/cactus.jpg"] name:@" laksd;lkas;dlkaslkd ;a"];
		EGODefaultPhoto *photo2 = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"] name:@"lskdjf lksjdhfk jsdfh ksjdhf sjdhf ksjdhf ksdjfh ksdjh skdjfh skdfjh "];
		EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, photo2, photo, photo2, photo, photo2, photo, photo2, nil]];
		
		EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoController];
		
		navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		navController.modalPresentationStyle = UIModalPresentationFullScreen;
		[self presentModalViewController:navController animated:YES];
				
		
		
	} else if (indexPath.row == 1) {
		
		EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"]];
		EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
		EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoController];
		navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		navController.modalPresentationStyle = UIModalPresentationFullScreen;
		[self presentModalViewController:navController animated:YES];
		
		
	}
}

@end

