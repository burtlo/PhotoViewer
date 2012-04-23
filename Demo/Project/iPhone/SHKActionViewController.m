//
//  SHKActionViewController.m
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/23/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "SHKActionViewController.h"
#import "MySHKConfigurator.h"

@interface SHKActionViewController ()

@property (nonatomic,strong) SHKActionSheet *actionSheet;

@end

@implementation SHKActionViewController

@synthesize photoSource;
@synthesize currentIndex;
@synthesize embeddedInPopover;

@synthesize actionSheet = actionSheet_;

- (id)init {
    self = [super init];
    if (self) {
        [MySHKConfigurator setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SHKItem *shareItem = [SHKItem image:[[self photo] image] title:[[self photo] title]];
    
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:shareItem];
    
    [SHK setRootViewController:self.parentViewController];
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
    
    actionSheet.delegate = self;
    self.actionSheet = actionSheet;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Photo Helper

- (id<EGOPhoto>)photo {
    return [self.photoSource photoAtIndex:self.currentIndex];
}

#pragma mark - UIActionSheetDelegate Adherence

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
}

@end
