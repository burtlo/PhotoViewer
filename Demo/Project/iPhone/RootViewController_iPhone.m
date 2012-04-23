//
//  RootViewController_iPhone.m
//  EGOPhotoViewer_Demo
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController_iPhone.h"
#import "EGOPhotoGlobal.h"
#import "EGODetailedCaptionView.h"

#define kSampleText @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

#define kSamplelText2 @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"

@implementation RootViewController_iPhone

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	self.title = @"EGOPhotoViewer Demo";
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	if (indexPath.row == 0) {
		cell.textLabel.text = @"Photos";
	} else if (indexPath.row == 1) {
		cell.textLabel.text = @"Single Photo";
	} else if (indexPath.row == 2) {
        cell.textLabel.text = @"Modal Single Photo";
    }
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
  	if (indexPath.row == 0) {
		
		EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"http://a3.twimg.com/profile_images/66601193/cactus.jpg"] name:kSampleText];
        
        photo.title = @"Grass From Around the World";
        photo.published = @"Some Time Ago...";
        photo.source = @"Ms. Photog";
        
		EGODefaultPhoto *photo2 = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"] name:kSamplelText2];
		EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, photo2, photo, photo2, photo, photo2, photo, photo2, photo, photo2, photo, photo2, photo, photo2,nil]];
		
		EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
        
        
        photoController.captionView = [[EGODetailedCaptionView alloc] init];        
        
		[self.navigationController pushViewController:photoController animated:YES];
		
		
	} else if (indexPath.row == 1) {
		
		EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"]];
		EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
		
		EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
		[self.navigationController pushViewController:photoController animated:YES];
		
		
	} else if (indexPath.row == 2) {
        
        EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"]];
        
        [self presentModalViewController:photoController animated:YES];
        
    }
}

@end

