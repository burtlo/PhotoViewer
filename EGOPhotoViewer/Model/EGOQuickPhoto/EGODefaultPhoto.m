//
//  EGODefaultPhoto.m
//  EGOPhotoViewer
//
//  Created by Devin Doty on 7/3/10.
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

#import "EGODefaultPhoto.h"

@interface EGODefaultPhoto ()

@property (nonatomic,strong,readwrite) NSURL *URL;
@property (nonatomic,copy,readwrite) NSString *caption;

@end

@implementation EGODefaultPhoto

@synthesize URL = URL_;
@synthesize caption = caption_;
@synthesize image = image_;
@synthesize size = size_;
@synthesize failed = failed_;

@synthesize title = title_;
@synthesize source = source_;
@synthesize published = published_;

@dynamic thumbnailURL;


#pragma mark - Initialization

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName image:(UIImage*)aImage {
    
	if ((self = [super init])) {
        self.URL = aURL;
        self.caption = aName;
        self.image = aImage;
	}
	
	return self;
}

- (id)initWithImageURL:(NSURL*)aURL name:(NSString*)aName {
	return [self initWithImageURL:aURL name:aName image:nil];
}

- (id)initWithImageURL:(NSURL*)aURL {
	return [self initWithImageURL:aURL name:nil image:nil];
}

- (id)initWithImage:(UIImage*)aImage {
	return [self initWithImageURL:nil name:nil image:aImage];
}

- (NSURL *)thumbnailURL {
    return self.URL;
}

- (NSString *)title {
    if (title_) {
        return title_;
    } else {
        return [[self.URL absoluteString] lastPathComponent];
    }
}

@end
