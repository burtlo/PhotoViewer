//
//  EGOSimplePhotoCaptionView.m
//  EGOPhotoViewer
//
//  Created by Devin Doty on 1/13/2010.
//  Copyright (c) 2008-2009 enormego
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

#import "EGOSimplePhotoCaptionView.h"
#import <QuartzCore/QuartzCore.h>

@interface EGOSimplePhotoCaptionView ()

@property (nonatomic,strong) UILabel *textLabel;

@end


@implementation EGOSimplePhotoCaptionView

@synthesize photo = photo_;

@synthesize textLabel = textLabel_;

#pragma mark - Initalization

- (id)initWithFrame:(CGRect)frame {
    
    frame.size.height = 40.0f;
    
    if ((self = [super initWithFrame:frame])) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, 40.0f)];
        
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.shadowColor = [UIColor blackColor];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		[self addSubview:textLabel];
        
        self.textLabel = textLabel;
							  
    }
    return self;
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor colorWithWhite:1.0f alpha:0.8f] setStroke];
	CGContextMoveToPoint(ctx, 0.0f, 0.0f);
	CGContextAddLineToPoint(ctx, self.frame.size.width, 0.0f);
	CGContextStrokePath(ctx);
	
}

- (void)recalculateSize {
    
    CGRect currentFrame = self.frame;
    currentFrame.size.height = 40.0;
    self.frame = currentFrame;
    
}


#pragma mark - EGOCaptioView Adherence

- (void)setPhoto:(id<EGOPhoto>)photo {

    if (photo_ == photo) { return; }
    
    photo_ = photo;
    
    self.textLabel.frame = CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, 40.0f);
    
    NSString *photoCaption = [photo caption];
    
    BOOL emptyCaption = (photoCaption == nil || [photoCaption stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0);
    
    if (emptyCaption) { 
        self.hidden = emptyCaption;
    }

    [self recalculateSize];
    
    self.textLabel.text = photoCaption;

}

#pragma mark - Hide

- (BOOL)blankOrEmptyPhotoCaption {
    NSString *photoCaption = [self.photo caption];
    return (photoCaption == nil || [photoCaption stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0);
}

- (void)setHidden:(BOOL)hidden {
    
    if ([self blankOrEmptyPhotoCaption]) { hidden = YES; }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		self.alpha = hidden ? 0.0f : 1.0f;
		[UIView commitAnimations];
		
		return;
		
	}
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
	
	if (hidden) {
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		self.frame = CGRectMake(0.0f, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
		
	} else {
		
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		CGFloat toolbarSize = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 32.0f : 44.0f;
		self.frame = CGRectMake(0.0f, self.superview.frame.size.height - (toolbarSize + self.frame.size.height), self.frame.size.width, self.frame.size.height);
        
	}
	
	[UIView commitAnimations];
    [super setHidden:hidden];
}

@end
