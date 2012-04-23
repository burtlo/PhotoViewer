//
//  EGOPhotoViewer_DemoAppDelegate.m
//  EGOPhotoViewer_Demo
//
//  Created by Devin Doty on 7/3/10July3.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "EGOPhotoViewer_DemoAppDelegate.h"

#import "RootViewController.h"
#import "DetailViewController.h"
#import "RootViewController_iPhone.h"

@interface EGOPhotoViewer_DemoAppDelegate ()

@property (nonatomic) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic) IBOutlet UIViewController *rootViewController;
@property (nonatomic) IBOutlet DetailViewController *detailViewController;

@property (nonatomic) IBOutlet RootViewController_iPhone *rootViewController_iPhone;

@end

@implementation EGOPhotoViewer_DemoAppDelegate

@synthesize window = window_;
@synthesize splitViewController = splitViewController_;
@synthesize rootViewController = rootViewController_;
@synthesize detailViewController = detailViewController_;
@synthesize rootViewController_iPhone = rootViewController_iPhone_;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    		
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController_iPhone];
        
        [self.window setRootViewController:navController];
		
	} else {
        
        [self.window setRootViewController:self.splitViewController];
		
	}

    [self.window makeKeyAndVisible];

    return YES;
}

@end

