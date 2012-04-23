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

@interface RootViewController_iPhone ()

- (NSDictionary *)examplesDictionary;
- (NSString *)titleForExampleAtIndex:(NSUInteger)index;
- (void)executeExampleAtIndex:(NSUInteger)index;

@end

@implementation RootViewController_iPhone

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"EGOPhotoViewer";
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self examplesDictionary] allKeys] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self titleForExampleAtIndex:indexPath.row];
    
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self executeExampleAtIndex:indexPath.row];
}


#pragma mark - Example Contents

- (NSDictionary *)examplesDictionary {
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"photoSource",@"Photo Source (Detailed Caption)",
            @"photoURL",@"Single Photo",
            nil];
}

- (NSString *)titleForExampleAtIndex:(NSUInteger)index {
    return [[[self examplesDictionary] allKeys] objectAtIndex:index];    
}

- (void)executeExampleAtIndex:(NSUInteger)index {

    NSString *key = [self titleForExampleAtIndex:index];
    
    NSString *selectorName = [[self examplesDictionary] objectForKey:key];
    
    [self performSelector:NSSelectorFromString(selectorName)];
}

#pragma mark - Example Helpers

- (id<EGOPhoto>)examplePhotoWithURLAndTitleAndPublishedAndSource {
    
    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"http://a3.twimg.com/profile_images/66601193/cactus.jpg"] name:kSampleText];
    
    photo.title = @"Grass From Around the World";
    photo.published = @"Some Time Ago...";
    photo.source = @"Ms. Photog";
    
    return photo;
}

- (id<EGOPhoto>)examplePhotoWithURL {

    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"] name:kSampleText];
    
    return photo;
}

- (id<EGOPhoto>)examplePhotoWithImage {

    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImage:[UIImage imageNamed:@"local_image_1.jpg"]];
    return photo;

}

#pragma mark - Examples

- (void)photoSource {
    
    
    EGODefaultPhoto *urlPhoto = [self examplePhotoWithURLAndTitleAndPublishedAndSource];
    EGODefaultPhoto *urlPhoto2 = [self examplePhotoWithURL];
    EGODefaultPhoto *localPhoto = [self examplePhotoWithImage];
    
    EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:
                                     [NSArray arrayWithObjects:urlPhoto, urlPhoto2, localPhoto, urlPhoto, urlPhoto2, localPhoto,urlPhoto, urlPhoto2, localPhoto,urlPhoto, urlPhoto2, localPhoto,nil]];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    
    photoController.captionView = [[EGODetailedCaptionView alloc] init];        
    
    [self.navigationController pushViewController:photoController animated:YES];
    
}

- (void)photoURL {
    
    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:@"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"]];
    EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:photo, nil]];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    [self.navigationController pushViewController:photoController animated:YES];
    
}

@end

