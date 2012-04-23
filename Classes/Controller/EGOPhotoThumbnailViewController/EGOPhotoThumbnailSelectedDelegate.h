//
//  EGOThumbnailSelectedDelegate.h
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/22/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGOPhotoThumbnailViewController.h"

@protocol EGOPhotoThumbnailSelectedDelegate <NSObject>

- (void)thumbnailViewController:(UIViewController<EGOPhotoThumbnailViewController> *)thumbnailViewController selectedPhotoAtIndex:(NSUInteger)thumbnailIndex;

@end
