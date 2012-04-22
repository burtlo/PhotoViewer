//
//  EGOPhotoThumbnailView.h
//  Mobile
//
//  Created by Frank Webber on 9/12/11.
//  Copyright 2011 Wetpaint, Inc. All rights reserved.
//

#import "EGOPhotoSource.h"
#import "EGOImageLoader.h"

@protocol EGOThumbnailSelectedDelegate;


@interface EGOPhotoThumbnailViewController : UIViewController <EGOImageLoaderObserver, UIScrollViewDelegate>

- (id)initWithPhotoSource:(id<EGOPhotoSource>)photoSource;
- (id)initWithPhotoSource:(id<EGOPhotoSource>)photoSource atIndex:(NSUInteger)startIndex;

@property (nonatomic,retain) id<EGOPhotoSource> photoSource;
@property (nonatomic,assign) NSUInteger startIndex;

@property (nonatomic, assign) id<EGOThumbnailSelectedDelegate> thumbnailSelectedDelegate;

@end


@protocol EGOThumbnailSelectedDelegate <NSObject>

- (void)thumbnailView:(EGOPhotoThumbnailViewController *)thumbnailViewController selectedPhotoAtIndex:(NSInteger)thumbnailIndex;

@end
