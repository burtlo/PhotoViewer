//
//  EGOGridPhotoThumbnailView.h
//  Mobile
//
//  Created by Frank Webber on 9/12/11.
//  Copyright 2011 Wetpaint, Inc. All rights reserved.
//

#import "EGOPhotoSource.h"
#import "EGOImageLoader.h"
#import "EGOPhotoThumbnailViewController.h"
#import "EGOPhotoThumbnailSelectedDelegate.h"

@protocol EGOPhotoThumbnailSelectedDelegate;

@interface EGOGridPhotoThumbnailViewController : UIViewController <EGOImageLoaderObserver, UIScrollViewDelegate, EGOPhotoThumbnailViewController>

@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic,strong) UIColor *selectedBorderColor;

@end
