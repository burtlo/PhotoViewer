//
//  EGOPhotoCaptionView.m
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

#import "EGOPhotoCaptionView.h"
#import <QuartzCore/QuartzCore.h>

@interface EGOPhotoCaptionView ()

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,assign) BOOL hidden;

@end


@implementation EGOPhotoCaptionView

@synthesize textLabel = textLabel_;
@synthesize hidden = hidden_;

#pragma mark - Initalization

- (id)initWithFrame:(CGRect)frame {
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

- (void)layoutSubviews{
	
	[self setNeedsDisplay];
	self.textLabel.frame = CGRectMake(20.0f, 0.0f, self.frame.size.width - 40.0f, 40.0f);
	
}

- (void)drawRect:(CGRect)rect {
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	[[UIColor colorWithWhite:1.0f alpha:0.8f] setStroke];
	CGContextMoveToPoint(ctx, 0.0f, 0.0f);
	CGContextAddLineToPoint(ctx, self.frame.size.width, 0.0f);
	CGContextStrokePath(ctx);
	
}

#pragma mark - Caption

- (void)setCaptionText:(NSString*)text hidden:(BOOL)val{
	
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		
		self.textLabel.text = nil;	
		[self setHidden:YES];
		
	} else {
		
		[self setHidden:val];
		self.textLabel.text = text;
		
	}
	
	
}

- (void)setCaptionHidden:(BOOL)hidden {
    
	if (self.hidden == hidden) { return; }
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		self.alpha= hidden ? 0.0f : 1.0f;
		[UIView commitAnimations];
		
		self.hidden = hidden;
		
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
	
	self.hidden = hidden;
	
}

@end
