//
//  EGOPhotoController.h
//  EGOPhotoViewer
//
//  Created by Devin Doty on 1/8/10.
//  Copyright 2010 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGOPhotoSource.h"
#import "EGOPhotoGlobal.h"

@interface EGOPhotoViewController : UIViewController <UIScrollViewDelegate>

#pragma mark - Initialization

#pragma mark  Single Image

- (id)initWithPhoto:(id<EGOPhoto>)aPhoto;
- (id)initWithImage:(UIImage*)image;
- (id)initWithImageURL:(NSURL*)imageURL;

#pragma mark Multiple Images

- (id)initWithPhotoSource:(id <EGOPhotoSource>)aPhotoSource;
- (id)initWithImages:(NSArray *)images;
- (id)initWithImageURLs:(NSArray *)imageURLs;
- (id)initWithPhotoSource:(id <EGOPhotoSource>)aSource andPhotoIndex:(NSInteger)index;

- (id)initWithPopoverController:(id)aPopoverController photoSource:(id <EGOPhotoSource>)aPhotoSource;

#pragma mark - Photo Source

@property(nonatomic,readonly) id <EGOPhotoSource> photoSource;

#pragma mark -  View Configuration

@property(nonatomic, assign) BOOL embeddedInPopover;

#pragma mark - Navigation

- (NSInteger)currentPhotoIndex;
- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated;

@end