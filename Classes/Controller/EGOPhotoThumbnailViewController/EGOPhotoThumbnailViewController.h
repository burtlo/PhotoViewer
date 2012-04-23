//
//  EGOPhotoThumbnailViewController.h
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/22/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGOPhotoSource.h"

@protocol EGOPhotoThumbnailSelectedDelegate;

@protocol EGOPhotoThumbnailViewController <NSObject>

@property (nonatomic,strong) id<EGOPhotoSource> photoSource;
@property (nonatomic,assign) NSUInteger currentIndex;
@property (nonatomic,assign) BOOL embeddedInPopover;

@property (nonatomic,assign) id<EGOPhotoThumbnailSelectedDelegate> thumbnailSelectedDelegate;

@end
