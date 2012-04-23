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

#define kExampleFirstPhotoURL @"http://a3.twimg.com/profile_images/66601193/cactus.jpg"
#define kExampleSecondPhotoURL @"https://s3.amazonaws.com/twitter_production/profile_images/425948730/DF-Star-Logo.png"

#define kExampleFirstLocalImage @"local_image_1.jpg"
#define kExampleSecondLocalImage @"local_image_2.jpg"

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
    
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
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
            @"photoSourceDetailedCaption",@"Photo Source (Detailed Caption)",
            @"photoSourceSimpleCaption",@"Photo Source (Simple Caption)",
            @"photosWithImages",@"Multiple Photos (From Images)",
            @"photosWithURLs",@"Multiple Photos (From URLs)",
            @"singlePhotoDetailed",@"Single Photo (Detailed Caption)",
            @"singlePhoto",@"Single Photo",
            @"photoWithImage",@"Single Photo (From Image)",
            @"photoWithURL",@"Single Photo (From URL)",
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

#pragma mark - Example Photo Creation

- (id<EGOPhoto>)examplePhotoWithURLAndTitleAndPublishedAndSource {
    
    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:kExampleFirstPhotoURL] caption:kSampleText];
    
    photo.title = @"Grass From Around the World";
    photo.published = @"Some Time Ago...";
    photo.source = @"Ms. Photog";
    
    return photo;
}

- (id<EGOPhoto>)examplePhotoWithURL {

    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:[NSURL URLWithString:kExampleSecondPhotoURL] caption:kSampleText];
    
    return photo;
}

- (id<EGOPhoto>)examplePhotoWithImage {

    EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImage:[UIImage imageNamed:@"local_image_1.jpg"]];
    return photo;

}

#pragma mark - Example Photo Source Creation

- (id<EGOPhotoSource>)examplePhotoSourceWithVariedPhotos {
    
    EGODefaultPhoto *urlPhoto = [self examplePhotoWithURLAndTitleAndPublishedAndSource];
    EGODefaultPhoto *urlPhoto2 = [self examplePhotoWithURL];
    EGODefaultPhoto *localPhoto = [self examplePhotoWithImage];
    
    EGODefaultPhotoSource *source = [[EGODefaultPhotoSource alloc] initWithPhotos:
                                     [NSArray arrayWithObjects:urlPhoto, urlPhoto2, localPhoto, urlPhoto, urlPhoto2, localPhoto,urlPhoto, urlPhoto2, localPhoto,urlPhoto, urlPhoto2, localPhoto,nil]];
    
    return source;
}


#pragma mark - Examples

- (void)photoSourceSimpleCaption {
    
    id<EGOPhotoSource> source = [self examplePhotoSourceWithVariedPhotos];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    
    [self.navigationController pushViewController:photoController animated:YES];
    
}

- (void)photoSourceDetailedCaption {
    
    id<EGOPhotoSource> source = [self examplePhotoSourceWithVariedPhotos];
    
    source.sourceTitle = @"Detailed Gallery";
    source.sourceDescription = kSampleText;
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhotoSource:source];
    
    photoController.captionView = [[EGODetailedCaptionView alloc] init];        
    
    [self.navigationController pushViewController:photoController animated:YES];
    
}

- (void)photosWithImages {
    
    NSArray *images = [NSArray arrayWithObjects:
                       [UIImage imageNamed:kExampleFirstLocalImage],
                       [UIImage imageNamed:kExampleSecondLocalImage],
                       [UIImage imageNamed:kExampleFirstLocalImage],
                       [UIImage imageNamed:kExampleSecondLocalImage], nil];
    
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithImages:images];
    
    [self.navigationController pushViewController:photoController animated:YES];
    
}

- (void)photosWithURLs {
    
    NSArray *urls = [NSArray arrayWithObjects:[NSURL URLWithString:kExampleFirstPhotoURL],
                     [NSURL URLWithString:kExampleSecondPhotoURL],
                     [NSURL URLWithString:kExampleFirstPhotoURL],
                     [NSURL URLWithString:kExampleSecondPhotoURL],
                     nil];
    
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithImageURLs:urls];
    
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)singlePhotoDetailed {
    
    EGODefaultPhoto *photo = [self examplePhotoWithURLAndTitleAndPublishedAndSource];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhoto:photo];
    photoController.captionView = [[EGODetailedCaptionView alloc] init];
    
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)singlePhoto {
    
    EGODefaultPhoto *photo = [self examplePhotoWithURL];
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoController animated:YES];
    
}

- (void)photoWithImage {
    
    UIImage *image = [UIImage imageNamed:kExampleFirstLocalImage];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:photoController animated:YES];
}

- (void)photoWithURL {
    
    NSURL *url = [NSURL URLWithString:kExampleFirstPhotoURL];
    
    EGOPhotoViewController *photoController = [[EGOPhotoViewController alloc] initWithImageURL:url];
    [self.navigationController pushViewController:photoController animated:YES];
}

@end

