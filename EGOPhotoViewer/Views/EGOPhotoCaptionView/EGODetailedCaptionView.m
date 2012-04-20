//
//  EGODetailedCaptionView.m
//  EGOPhotoViewer_Demo
//
//  Created by Franklin Webber on 4/20/12.
//  Copyright (c) 2012 Franklin Webber. All rights reserved.
//

#import "EGODetailedCaptionView.h"

@interface EGODetailedCaptionView ()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *sourceLabel;
@property (nonatomic,strong) UILabel *publishedLabel;
@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL hidden;

- (void)setTitleText:(NSString*)text;
- (void)setSourceText:(NSString*)text;
- (void)setPublishedText:(NSString*)text;

- (void)setCaptionText:(NSString*)text hidden:(BOOL)val;
- (void)setCaptionHidden:(BOOL)hidden;

- (void)setScrollToTop;

- (void)recalculateSize;

- (CGFloat)getNeededViewHeight;
- (void) updateScrollViewSize;

@end


@implementation EGODetailedCaptionView

@synthesize photo = photo_;
@dynamic captionHidden;

@synthesize titleLabel = titleLabel_;
@synthesize sourceLabel = sourceLabel_;
@synthesize publishedLabel = publishedLabel_;
@synthesize textLabel = textLabel_;
@synthesize scrollView = scrollView_;
@synthesize hidden = hidden_;

- (id)initWithFrame:(CGRect)frame {
	
    if ( (self = [super initWithFrame:frame]) ) {
		
		self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10.0f, 22.0f, self.frame.size.width - 20.0f, 130.0f)];
        
        self.scrollView = scrollView;
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        
		// Setup the title label
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, scrollView.frame.size.width, 60.0f)];
		titleLabel.hidden = YES;
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		titleLabel.numberOfLines = 0;
		titleLabel.lineBreakMode = UILineBreakModeWordWrap;
		titleLabel.textColor = [UIColor whiteColor];
		titleLabel.shadowColor = [UIColor blackColor];
		titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		titleLabel.isAccessibilityElement = YES;
		titleLabel.accessibilityLabel = @"photo-title";
		
        self.titleLabel = titleLabel;
        
		[scrollView addSubview:titleLabel];
        
		
		// Setup the description/caption label
		
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 60.0f, scrollView.frame.size.width, 80.0f)];
		textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
		textLabel.backgroundColor = [UIColor clearColor];
		textLabel.numberOfLines = 0;
		textLabel.minimumFontSize = 10.0f;
		textLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
		textLabel.font = [UIFont fontWithName:@"Georgia" size:12.0f];
		textLabel.lineBreakMode = UILineBreakModeWordWrap;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.shadowColor = [UIColor blackColor];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.isAccessibilityElement = YES;
		textLabel.accessibilityLabel = @"photo-description";
        
        self.textLabel = textLabel;
        
		[scrollView addSubview:textLabel];
        
		
		[self addSubview:scrollView];
		
		
		// Setup the source label
		
		UILabel *sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 6.0f, self.frame.size.width - 20.0f, 15.0f)];
		sourceLabel.hidden = YES;
		sourceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
		sourceLabel.backgroundColor = [UIColor clearColor];
		sourceLabel.numberOfLines = 1;
		sourceLabel.font = [UIFont fontWithName:@"Georgia" size:10.0f];
		sourceLabel.lineBreakMode = UILineBreakModeTailTruncation;
		sourceLabel.textColor = [UIColor whiteColor];
		sourceLabel.shadowColor = [UIColor blackColor];
		sourceLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		sourceLabel.isAccessibilityElement = YES;
		sourceLabel.accessibilityLabel = @"photo-source";
		
        self.sourceLabel = sourceLabel;
        
		[self addSubview:sourceLabel];
		
		// Setup the published date/time label
		// It should appear at the top over on the right hand side
		
		UILabel *publishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 105.0f, 6.0f, 100.0f, 15.0f)];
		publishedLabel.hidden = YES;
		publishedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
		publishedLabel.backgroundColor = [UIColor clearColor];
		publishedLabel.numberOfLines = 1;
		publishedLabel.font = [UIFont fontWithName:@"Georgia" size:10.0f];
		publishedLabel.lineBreakMode = UILineBreakModeWordWrap;
		publishedLabel.textColor = [UIColor whiteColor];
		publishedLabel.shadowColor = [UIColor blackColor];
		publishedLabel.isAccessibilityElement = YES;
		publishedLabel.accessibilityLabel = @"photo-published";
		
		publishedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        
        self.publishedLabel = publishedLabel;
        
		[self addSubview:publishedLabel];
        
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
    currentFrame.size.height = CGRectGetHeight(self.sourceLabel.frame) + CGRectGetHeight(self.scrollView.frame);
    self.frame = currentFrame;
    
}


#pragma mark - EGOCaptionView Adherence


- (void)setPhoto:(id<EGOPhoto>)photo {
    
    if (photo_ == photo) { return; }
    
    photo_ = photo;
    
    [self setTitleText:photo.title];
    [self setCaptionText:photo.caption hidden:NO];
    [self setPublishedText:photo.published];
    [self setSourceText:photo.source];
    
    [self recalculateSize];
    
}

- (void)setCaptionHidden:(BOOL)hidden {
    
	if (self.hidden==hidden) { return; }
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		self.alpha= hidden ? 0.0f : 1.0f;
		[UIView commitAnimations];
		
		self.hidden=hidden;
		
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
	
	self.hidden=hidden;
	
}

- (BOOL)captionHidden {
    return self.hidden;
}

#pragma mark - Setters

- (void)setCaptionText:(NSString*)text hidden:(BOOL)val {
	
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		
		self.textLabel.text = nil;	
		[self setHidden:YES];
		
	} else {
		
		
		self.textLabel.text = text;
		
		// Find out the size of the text so that we can set the content size of
		// the scroll view which will allow the user to scroll to see all of
		// the description
		
		CGSize stringSize = [text sizeWithFont:self.textLabel.font
							 constrainedToSize:CGSizeMake(self.scrollView.frame.size.width,1000.0)
								 lineBreakMode:self.textLabel.lineBreakMode];
		
		self.textLabel.frame = CGRectMake(0.0f, self.titleLabel.frame.size.height + 10.0, stringSize.width, stringSize.height);
		
		[self updateScrollViewSize];
		
		[self setHidden:val];
		
	}
	
}

- (void)setTitleText:(NSString *)text {
    
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		self.titleLabel.text = nil;
	} else {
		self.titleLabel.text = text;
		
		CGSize stringSize = [text sizeWithFont:self.titleLabel.font
							 constrainedToSize:CGSizeMake(self.scrollView.frame.size.width,1000.0)
                                 lineBreakMode:self.titleLabel.lineBreakMode];
		
		self.titleLabel.frame = CGRectMake(0.0f, 0.0f, stringSize.width, stringSize.height);
		
		// Update the y position of the text label so that it is close to the title label
		
		self.textLabel.frame = CGRectMake(0.0f ,(self.titleLabel.frame.size.height + 10.0), self.scrollView.frame.size.width, self.textLabel.frame.size.height);
		
		[self updateScrollViewSize];
		
		[self.titleLabel setHidden:NO];
	}
}

- (void)setSourceText:(NSString *)text {
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		self.sourceLabel.text = nil;
	} else {
		self.sourceLabel.text = [@"Photo Credit: " stringByAppendingString:text];
		[self.sourceLabel setHidden:NO];
	}
}

- (void)setPublishedText:(NSString *)text {
	if (text == nil || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
		self.publishedLabel.text = nil;
	} else {
		self.publishedLabel.text = text;
		[self.publishedLabel setHidden:NO];
	}
}

- (void)setScrollToTop {
	[self.scrollView scrollRectToVisible:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:NO];
}

- (void)updateScrollViewSize {
	// Set the height of the scroll view based on the height of the components within the scroll view
    
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.titleLabel.frame.size.height + self.textLabel.frame.size.height + 30.0);
}

- (CGFloat)getNeededViewHeight {
	return self.scrollView.frame.origin.y + self.scrollView.contentSize.height;
}


@end
