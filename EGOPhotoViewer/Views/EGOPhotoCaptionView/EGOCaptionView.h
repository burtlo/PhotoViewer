//
//  EGOCaptionView.h
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/20/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGOPhotoSource.h"

@protocol EGOCaptionView <NSObject>

@property (nonatomic,strong) id<EGOPhoto> photo;
@property (nonatomic,assign) BOOL captionHidden;

@end
