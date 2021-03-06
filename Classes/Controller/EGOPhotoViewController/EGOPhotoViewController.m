//
//  EGOPhotoController.m
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

#import "EGOPhotoViewController.h"
#import "UINavigationItem+ColoredTitle.h"
#import "EGODetailedCaptionView.h"
#import "EGOGridPhotoThumbnailViewController.h"
#import "EGODefaultActionViewController.h"

@interface EGOPhotoViewController ()

@property (nonatomic) UIBarButtonItem *leftButton;
@property (nonatomic) UIBarButtonItem *rightButton;

@property (nonatomic) UIView *popoverOverlay;
@property (nonatomic) UIView *transferView;

@property (nonatomic,readwrite) id <EGOPhotoSource> photoSource;
@property (nonatomic) NSMutableArray *photoViews;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL _fromPopover;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,assign) BOOL rotating;
@property (nonatomic,assign) BOOL barsHidden;

#pragma mark - Navigation and Toolbar Styles

@property (nonatomic,assign) BOOL storedOldStyles;
@property (nonatomic,assign) BOOL oldNavBarTranslucent;
@property (nonatomic,assign) BOOL oldToolBarTranslucent;
@property (nonatomic,assign) BOOL oldToolBarHidden;

@property (nonatomic,assign) UIStatusBarStyle oldStatusBarSyle;
@property (nonatomic,assign) UIBarStyle oldNavBarStyle;
@property (nonatomic,assign) UIBarStyle oldToolBarStyle;
@property (nonatomic) UIColor *oldNavBarTintColor;
@property (nonatomic) UIColor *oldToolBarTintColor;

#pragma mark

@property (nonatomic,assign) BOOL autoresizedPopover;
@property (nonatomic,assign) BOOL fullScreen;

- (void)loadScrollViewWithPage:(NSInteger)page;
- (void)layoutScrollViewSubviews;
- (void)setupScrollViewContentSize;
- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex;
- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated;
- (NSInteger)centerPhotoIndex;
- (void)setupToolbar;
- (void)setViewState;
- (void)setupViewForPopover;

@end


@implementation EGOPhotoViewController

@synthesize captionView = captionView_;
@synthesize thumbnailViewController = thumbnailViewController_;
@synthesize actionViewController = actionViewController_;

@synthesize leftButton = leftButton_;
@synthesize rightButton = rightButton_;

@synthesize popoverOverlay = popoverOverlay_;
@synthesize transferView = transferView_;

@synthesize scrollView = scrollView_;
@synthesize photoSource = photoSource_; 
@synthesize photoViews = photoViews_;
@synthesize _fromPopover;
@synthesize embeddedInPopover = embeddedInPopover_;

@synthesize pageIndex = pageIndex_;

@synthesize rotating = rotating_;
@synthesize barsHidden = barsHidden_;

@synthesize storedOldStyles = storedOldStyles_;
@synthesize oldNavBarTranslucent = oldNavBarTranslucent_;
@synthesize oldToolBarTranslucent = oldToolBarTranslucent_;
@synthesize oldToolBarHidden = oldToolBarHidden_;

@synthesize oldStatusBarSyle = oldStatusBarSyle_;
@synthesize oldNavBarStyle = oldNavBarStyle_;
@synthesize oldToolBarStyle = oldToolBarStyle_;
@synthesize oldNavBarTintColor = oldNavBarTintColor_;
@synthesize oldToolBarTintColor = oldToolBarTintColor_;

@synthesize autoresizedPopover = autoresizedPopover_;
@synthesize fullScreen = fullScreen_;

#pragma mark - Initialization

#pragma mark  Single Image

- (id)initWithPhoto:(id<EGOPhoto>)aPhoto {
	return [self initWithPhotoSource:[[EGODefaultPhotoSource alloc] initWithPhotos:[NSArray arrayWithObjects:aPhoto,nil]]];
}

- (id)initWithImage:(UIImage*)anImage {
	return [self initWithPhoto:[[EGODefaultPhoto alloc] initWithImage:anImage]];
}

- (id)initWithImageURL:(NSURL*)anImageURL {
	return [self initWithPhoto:[[EGODefaultPhoto alloc] initWithImageURL:anImageURL]];
}

#pragma mark Multiple Images

- (id)initWithImages:(NSArray *)images {
    
    NSMutableArray *defaultPhotos = [NSMutableArray arrayWithCapacity:[images count]];
    
    for (UIImage *image in images) {
        EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImage:image];
        [defaultPhotos addObject:photo];
    }
    
    EGODefaultPhotoSource *defaultPhotoSource = [[EGODefaultPhotoSource alloc] initWithPhotos:defaultPhotos];
    return [self initWithPhotoSource:defaultPhotoSource];
    
}

- (id)initWithImageURLs:(NSArray *)imageURLs {
    
    NSMutableArray *defaultPhotos = [NSMutableArray arrayWithCapacity:[imageURLs count]];
    
    for (NSURL *imageURL in imageURLs) {
        EGODefaultPhoto *photo = [[EGODefaultPhoto alloc] initWithImageURL:imageURL];
        [defaultPhotos addObject:photo];
    }
    
    EGODefaultPhotoSource *defaultPhotoSource = [[EGODefaultPhotoSource alloc] initWithPhotos:defaultPhotos];
    return [self initWithPhotoSource:defaultPhotoSource];
    
}

- (id)initWithPhotoSource:(id <EGOPhotoSource> )aSource andPhotoIndex:(NSInteger)index {
	self.pageIndex = index;
	return [self initWithPhotoSource:aSource];
}

- (id)initWithPhotoSource:(id <EGOPhotoSource> )aSource{
	if ((self = [super init])) {
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleBarsNotification:) name:@"EGOPhotoViewToggleBars" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewDidFinishLoading:) name:@"EGOPhotoDidFinishLoading" object:nil];
		
		self.hidesBottomBarWhenPushed = YES;
		self.wantsFullScreenLayout = YES;
        
        self.photoSource = aSource;
        
		if (self.pageIndex > 0) {
			//Do-Nothing
		}
		else {
			self.pageIndex = 0;
		}
		
	}
	
	return self;
}

- (id)initWithPopoverController:(id)aPopoverController photoSource:(id <EGOPhotoSource>)aPhotoSource {
	if ((self = [self initWithPhotoSource:aPhotoSource])) {
        [self setModalPresentationStyle:UIModalTransitionStyleCoverVertical];
		self.embeddedInPopover = YES;
	}
	
	return self;
}

#pragma mark Deallocation

- (void)dealloc {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor blackColor];
	self.wantsFullScreenLayout = YES;
	
	if (!self.scrollView) {
		
		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
		scrollView.delegate=self;
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		scrollView.multipleTouchEnabled=YES;
		scrollView.scrollEnabled=YES;
		scrollView.directionalLockEnabled=YES;
		scrollView.canCancelContentTouches=YES;
		scrollView.delaysContentTouches=YES;
		scrollView.clipsToBounds=YES;
		scrollView.alwaysBounceHorizontal=YES;
		scrollView.bounces=YES;
		scrollView.pagingEnabled=YES;
		scrollView.showsVerticalScrollIndicator=NO;
		scrollView.showsHorizontalScrollIndicator=NO;
		scrollView.backgroundColor = self.view.backgroundColor;
		[self.view addSubview:scrollView];
        
        self.scrollView = scrollView;

	}
	
	if (!self.captionView) {
        self.captionView = [[EGOSimplePhotoCaptionView alloc] init];
	}
    
    self.captionView.frame = CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, 1.0f);

	[self.view addSubview:self.captionView];
    
    
	//  load photoviews lazily
	NSMutableArray *views = [[NSMutableArray alloc] init];
	for (unsigned i = 0; i < [self.photoSource numberOfPhotos]; i++) {
		[views addObject:[NSNull null]];
	}
	self.photoViews = views;


	if ([self.photoSource numberOfPhotos] == 1 && UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
		
		[self.navigationController setNavigationBarHidden:YES animated:NO];
		[self.navigationController setToolbarHidden:YES animated:NO];
		
		[self enqueuePhotoViewAtIndex:self.pageIndex];
		[self loadScrollViewWithPage:self.pageIndex];
		[self setViewState];
	}
    
    if (self.thumbnailViewController == nil) {
        self.thumbnailViewController = [[EGOGridPhotoThumbnailViewController alloc] init];
    }
    
    if (self.actionViewController == nil) {
        self.actionViewController = [[EGODefaultActionViewController alloc] init];
    }

}

- (void)viewDidUnload {
	[super viewDidUnload];
    
	self.photoViews = nil;
	self.scrollView = nil;
	self.captionView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		
		UIView *view = self.view;
		if (self.navigationController) {
			view = self.navigationController.view;
		}
		
		while (view != nil) {
			
			if ([view isKindOfClass:NSClassFromString(@"UIPopoverView")]) {
				
				self.embeddedInPopover = YES;
				break;
			
			} 
			view = view.superview;
		}
		
		if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad && !self.embeddedInPopover) {
			[self.navigationController setNavigationBarHidden:NO animated:NO];
		}
		
	} else {
		
		self.embeddedInPopover = NO;
		
	}
	
	if(!self.storedOldStyles) {
        self.oldStatusBarSyle = [UIApplication sharedApplication].statusBarStyle;
		
		self.oldNavBarTintColor = self.navigationController.navigationBar.tintColor;
		self.oldNavBarStyle = self.navigationController.navigationBar.barStyle;
		self.oldNavBarTranslucent = self.navigationController.navigationBar.translucent;
		
		self.oldToolBarTintColor = self.navigationController.toolbar.tintColor;
		self.oldToolBarStyle = self.navigationController.toolbar.barStyle;
		self.oldToolBarTranslucent = self.navigationController.toolbar.translucent;
		self.oldToolBarHidden = [self.navigationController isToolbarHidden];
		
		self.storedOldStyles = YES;
	}	
	
	if ([self.navigationController isToolbarHidden] && ((!self.embeddedInPopover && ([self.photoSource numberOfPhotos] > 1)) || ([self.photoSource numberOfPhotos] > 1))) {
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
	
	if (!self.embeddedInPopover) {
		self.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
		self.navigationController.navigationBar.translucent = YES;
		
		self.navigationController.toolbar.tintColor = nil;
		self.navigationController.toolbar.barStyle = UIBarStyleBlack;
		self.navigationController.toolbar.translucent = YES;
	}

	
	[self setupToolbar];
	[self setupScrollViewContentSize];
	[self moveToPhotoAtIndex:self.pageIndex animated:NO];
	
	if (self.embeddedInPopover) {
		[self addObserver:self forKeyPath:@"contentSizeForViewInPopover" options:NSKeyValueObservingOptionNew context:NULL];
	}
	
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
	self.navigationController.navigationBar.barStyle = self.oldNavBarStyle;
	self.navigationController.navigationBar.tintColor = self.oldNavBarTintColor;
	self.navigationController.navigationBar.translucent = self.oldNavBarTranslucent;
	
	[[UIApplication sharedApplication] setStatusBarStyle:self.oldStatusBarSyle animated:YES];
	
	if(!self.oldToolBarHidden) {
		
		if ([self.navigationController isToolbarHidden]) {
			[self.navigationController setToolbarHidden:NO animated:YES];
		}
		
		self.navigationController.toolbar.barStyle = self.oldNavBarStyle;
		self.navigationController.toolbar.tintColor = self.oldNavBarTintColor;
		self.navigationController.toolbar.translucent = self.oldNavBarTranslucent;
		
	} else {
		
		[self.navigationController setToolbarHidden:self.oldToolBarHidden animated:YES];
		
	}
	
	if (self.embeddedInPopover) {
		[self removeObserver:self forKeyPath:@"contentSizeForViewInPopover"];
	}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
	}
	
   	return (UIInterfaceOrientationIsLandscape(interfaceOrientation) || interfaceOrientation == UIInterfaceOrientationPortrait);
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	self.rotating = YES;
	
	if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && !self.embeddedInPopover) {
		CGRect rect = [[UIScreen mainScreen] bounds];
		self.scrollView.contentSize = CGSizeMake(rect.size.height * [self.photoSource numberOfPhotos], rect.size.width);
	}
	
	//  set side views hidden during rotation animation
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (count != self.pageIndex) {
				[view setHidden:YES];
			}
		}
		count++;
	}
	
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			[view rotateToOrientation:toInterfaceOrientation];
		}
	}
		
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	
	[self setupScrollViewContentSize];
	[self moveToPhotoAtIndex:self.pageIndex animated:NO];
	[self.scrollView scrollRectToVisible:((EGOPhotoImageView*)[self.photoViews objectAtIndex:self.pageIndex]).frame animated:YES];
	
	//  unhide side views
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			[view setHidden:NO];
		}
	}
	self.rotating = NO;
	
}

#pragma mark - View Setup

- (void)setupToolbar {
	
	[self setupViewForPopover];
    
	if(self.embeddedInPopover && [self.photoSource numberOfPhotos] == 1) {
		[self.navigationController setToolbarHidden:YES animated:NO];
		return;
	}
	
	if (!self.embeddedInPopover && UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad && !_fromPopover) {
		if (self.modalPresentationStyle == UIModalPresentationFullScreen) {
			UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"done") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
			self.navigationItem.rightBarButtonItem = doneButton;
		}
	} else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		if ([self presentingViewController]) {
			
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"done") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
			self.navigationItem.rightBarButtonItem = doneButton;
		}
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
	}
	
    
    
	UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(takeAction:)];
    
	UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	if ([self.photoSource numberOfPhotos] > 1) {
		
		UIBarButtonItem *fixedCenter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedCenter.width = 80.0f;
		UIBarButtonItem *fixedLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		fixedLeft.width = 40.0f;
		
		if (self.embeddedInPopover && [self.photoSource numberOfPhotos] > 1) {
			UIBarButtonItem *scaleButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_fullscreen_button.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullScreen:)];
			self.navigationItem.rightBarButtonItem = scaleButton;
		}		
        
		
		UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveBack:)];
        
        [left setIsAccessibilityElement:YES];
		[left setAccessibilityLabel:@"left"];

		UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_right.png"] style:UIBarButtonItemStylePlain target:self action:@selector(moveForward:)];
        
        [right setIsAccessibilityElement:YES];
		[right setAccessibilityLabel:@"right"];

        UIBarButtonItem *thumbnail = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_thumbnail.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showThumbnails:)];
		
		[thumbnail setIsAccessibilityElement:YES];
		[thumbnail setAccessibilityLabel:@"thumbnail"];

		[self setToolbarItems:[NSArray arrayWithObjects:thumbnail, flex, left, fixedCenter, right, flex, action, nil]];
		
		self.rightButton = right;
		self.leftButton = left;
		
		
	} else {
		[self setToolbarItems:[NSArray arrayWithObjects:flex, action, nil]];
	}
	
}

#pragma mark - Actions


- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark 

- (NSInteger)currentPhotoIndex {
	return self.pageIndex;
	
}


#pragma mark - Popver ContentSize Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {	
	[self setupScrollViewContentSize];
	[self layoutScrollViewSubviews];
}


#pragma mark -  Bar/Caption Methods

- (void)setStatusBarHidden:(BOOL)hidden animated:(BOOL)animated {
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) return; 
	
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];

}

- (void)setBarsHidden:(BOOL)hidden animated:(BOOL)animated {
	if (hidden && self.barsHidden) return;
	
	if (self.embeddedInPopover && [self.photoSource numberOfPhotos] == 0) {
		self.captionView.hidden = hidden;
		return;
	}
		
	[self setStatusBarHidden:hidden animated:animated];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		
		if (!self.embeddedInPopover) {
			
			if (animated) {
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.3f];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			}
			
			self.navigationController.navigationBar.alpha = hidden ? 0.0f : 1.0f;
			self.navigationController.toolbar.alpha = hidden ? 0.0f : 1.0f;
			
			if (animated) {
				[UIView commitAnimations];
			}
			
		} 
		
	} else {
		
		[self.navigationController setNavigationBarHidden:hidden animated:animated];
    
		// Set toolbar hidden if there is only one pic and the action menu is hidden
    if ([self.photoSource numberOfPhotos] <= 1)
      [self.navigationController setToolbarHidden:YES animated:animated];
    else
      [self.navigationController setToolbarHidden:hidden animated:animated];
		
	}
	
	if (self.captionView) {
		self.captionView.hidden = hidden;
	}
	
	self.barsHidden=hidden;
	
}

- (void)toggleBarsNotification:(NSNotification*)notification {
	[self setBarsHidden:!self.barsHidden animated:YES];
}


#pragma mark - FullScreen Methods

- (void)setupViewForPopover {
	
	if (!self.popoverOverlay && self.embeddedInPopover && [self.photoSource numberOfPhotos] == 1) {
				
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height, self.view.frame.size.width, 40.0f)];
		view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
		self.popoverOverlay = view;
		[self.view addSubview:view];
		
		UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.popoverOverlay.frame.size.width, 1.0f)];
		borderView.autoresizingMask = view.autoresizingMask;
		[self.popoverOverlay addSubview:borderView];
		[borderView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.4f]];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"egopv_fullscreen_button.png"] forState:UIControlStateNormal];
		button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		[button addTarget:self action:@selector(toggleFullScreen:) forControlEvents:UIControlEventTouchUpInside];
		button.frame = CGRectMake(view.frame.size.width - 40.0f, 0.0f, 40.0f, 40.0f);
		[view addSubview:button];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		view.frame = CGRectMake(0.0f, self.view.bounds.size.height - 40.0f, self.view.bounds.size.width, 40.0f);
		[UIView commitAnimations];
		
	}
	
}

- (CATransform3D)transformForCurrentOrientation {
	
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	switch (orientation) {
		case UIInterfaceOrientationPortraitUpsideDown:
			return CATransform3DMakeRotation((M_PI/180)*180, 0.0f, 0.0f, 1.0f);
			break;
		case UIInterfaceOrientationLandscapeRight:
			return CATransform3DMakeRotation((M_PI/180)*90, 0.0f, 0.0f, 1.0f);
			break;
		case UIInterfaceOrientationLandscapeLeft:
			return CATransform3DMakeRotation((M_PI/180)*-90, 0.0f, 0.0f, 1.0f);
			break;
		default:
			return CATransform3DIdentity;
			break;
	}
	
}

- (void)toggleFullScreen:(id)sender {
	
	self.fullScreen = !self.fullScreen;
	
	if (!self.fullScreen) {
		
		NSInteger pageIndex = 0;
		if (self.modalViewController && [self.modalViewController isKindOfClass:[UINavigationController class]]) {
			UIViewController *controller = [((UINavigationController*)self.modalViewController) visibleViewController];
			if ([controller isKindOfClass:[self class]]) {
				pageIndex = [(EGOPhotoViewController*)controller currentPhotoIndex];
			}
		}		
		[self moveToPhotoAtIndex:pageIndex animated:NO];
		[self.navigationController dismissModalViewControllerAnimated:NO];
		
	}
	
	EGOPhotoImageView *_currentView = [self.photoViews objectAtIndex:self.pageIndex];
	BOOL enabled = [UIView areAnimationsEnabled];
	[UIView setAnimationsEnabled:NO];
	[_currentView killScrollViewZoom];
	[UIView setAnimationsEnabled:enabled];
	UIImageView *_currentImage = _currentView.imageView;
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
	backgroundView.layer.transform = [self transformForCurrentOrientation];
	[keyWindow addSubview:backgroundView];
	backgroundView.frame = [[UIScreen mainScreen] applicationFrame];
	self.transferView = backgroundView;
	
	CGRect newRect = [self.view convertRect:_currentView.scrollView.frame toView:self.transferView];
	UIImageView *_imageView = [[UIImageView alloc] initWithFrame:self.fullScreen ? newRect : self.transferView.bounds];	
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	[_imageView setImage:_currentImage.image];
	[self.transferView addSubview:_imageView];
	
	self.scrollView.hidden = YES;
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	animation.fromValue = self.fullScreen ? (id)[UIColor clearColor].CGColor : (id)[UIColor blackColor].CGColor;
	animation.toValue = self.fullScreen ? (id)[UIColor blackColor].CGColor : (id)[UIColor clearColor].CGColor;
	animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
	animation.duration = 0.4f;
	[self.transferView.layer addAnimation:animation forKey:@"FadeAnimation"];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(fullScreenAnimationDidStop:finished:context:)];
	_imageView.frame = self.fullScreen ? self.transferView.bounds : newRect;
	[UIView commitAnimations];
	
}

- (void)fullScreenAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	if (finished) {
		
		self.scrollView.hidden = NO;
		
		if (self.transferView) {
			[self.transferView removeFromSuperview];
			self.transferView = nil;
		}
		
		if (self.fullScreen) {
			
			BOOL enabled = [UIView areAnimationsEnabled];
			[UIView setAnimationsEnabled:NO];
			
			EGOPhotoViewController *controller = [[EGOPhotoViewController alloc] initWithPhotoSource:self.photoSource];
			controller._fromPopover = YES;
			UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
			
			navController.modalPresentationStyle = UIModalPresentationFullScreen;
			[self.navigationController presentModalViewController:navController animated:NO];
			[controller moveToPhotoAtIndex:self.pageIndex animated:NO];
			
			
			[UIView setAnimationsEnabled:enabled];
			
			UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"egopv_minimize_fullscreen_button.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleFullScreen:)];
			controller.navigationItem.rightBarButtonItem = button;
			
		}
		
	}
	
}



#pragma mark - Photo View Methods

- (void)photoViewDidFinishLoading:(NSNotification*)notification {
	if (notification == nil) return;
	
	if ([[[notification object] objectForKey:@"photo"] isEqual:[self.photoSource photoAtIndex:[self centerPhotoIndex]]]) {
		if ([[[notification object] objectForKey:@"failed"] boolValue]) {
			if (self.barsHidden) {
				//  image failed loading
				[self setBarsHidden:NO animated:YES];
			}
		} 
		[self setViewState];
	}
}

- (NSInteger)centerPhotoIndex {
	
	CGFloat pageWidth = self.scrollView.frame.size.width;
	return floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
}

- (void)moveForward:(id)sender {
	[self moveToPhotoAtIndex:[self centerPhotoIndex]+1 animated:NO];	
}

- (void)moveBack:(id)sender {
	[self moveToPhotoAtIndex:[self centerPhotoIndex]-1 animated:NO];
}

- (void)showThumbnails:(id)sender {

    self.thumbnailViewController.embeddedInPopover = self.embeddedInPopover;
    self.thumbnailViewController.photoSource = self.photoSource;
    self.thumbnailViewController.currentIndex = self.currentPhotoIndex;
    self.thumbnailViewController.thumbnailSelectedDelegate = self;

	[self addChildViewController:self.thumbnailViewController];
    [self.view addSubview:self.thumbnailViewController.view];

}

- (void)thumbnailViewController:(UIViewController<EGOPhotoThumbnailViewController> *)thumbnailViewController selectedPhotoAtIndex:(NSUInteger)thumbnailIndex{
	
	// Move to the selected index
	[self moveToPhotoAtIndex:thumbnailIndex animated:NO];
	
}

- (void)takeAction:(id)sender {
    
    self.actionViewController.photoSource = self.photoSource;
    self.actionViewController.currentIndex = self.currentPhotoIndex;
    self.actionViewController.embeddedInPopover = self.embeddedInPopover;
    
    [self addChildViewController:self.actionViewController];
    [self.view addSubview:self.actionViewController.view];
    
}


- (void)setViewState {	
	
	if (self.leftButton) {
		self.leftButton.enabled = !(self.pageIndex-1 < 0);
	}
	
	if (self.rightButton) {
		self.rightButton.enabled = !(self.pageIndex+1 >= [self.photoSource numberOfPhotos]);
	}
		
	if ([self.photoSource numberOfPhotos] > 1) {
        [self.navigationItem setTitle:[NSString stringWithFormat:NSLocalizedString(@"%i of %i", @"imageCounter"), self.pageIndex+1, [self.photoSource numberOfPhotos]] withColor:[UIColor whiteColor]];
	} else {
		self.title = @"";
	}
	
	if (self.captionView) {
        
        
        id<EGOPhoto> currentPhoto = [self.photoSource photoAtIndex:self.pageIndex];
        [self.captionView setPhoto:currentPhoto];
    
        if (!self.barsHidden) {
            
            self.captionView.hidden = NO;
            
            CGFloat toolbarSize = self.embeddedInPopover ? 0.0f : self.navigationController.toolbar.frame.size.height;
            
            CGFloat captionViewYposition = self.view.frame.size.height - toolbarSize - self.captionView.frame.size.height/2;
            
            self.captionView.center = CGPointMake(CGRectGetMidX(self.view.frame),captionViewYposition);
            
        }
    }
	
	if([self respondsToSelector:@selector(setContentSizeForViewInPopover:)] && [self.photoSource numberOfPhotos] == 1) {
		
		EGOPhotoImageView *imageView = [self.photoViews objectAtIndex:[self centerPhotoIndex]];
		if ((NSNull*)imageView != [NSNull null]) {
			self.contentSizeForViewInPopover = [imageView sizeForPopover];
		}
		
	}
	
}

- (void)moveToPhotoAtIndex:(NSInteger)index animated:(BOOL)animated {
	NSAssert(index < [self.photoSource numberOfPhotos] && index >= 0, @"Photo index passed out of bounds");
	
	self.pageIndex = index;
	[self setViewState];

	[self enqueuePhotoViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	
	[self.scrollView scrollRectToVisible:((EGOPhotoImageView*)[self.photoViews objectAtIndex:index]).frame animated:animated];
	
	if ([[self.photoSource photoAtIndex:self.pageIndex] didFail]) {
		[self setBarsHidden:NO animated:YES];
	}
	
	//  reset any zoomed side views
	if (index + 1 < [self.photoSource numberOfPhotos] && (NSNull*)[self.photoViews objectAtIndex:index+1] != [NSNull null]) {
		[((EGOPhotoImageView*)[self.photoViews objectAtIndex:index+1]) killScrollViewZoom];
	} 
	if (index - 1 >= 0 && (NSNull*)[self.photoViews objectAtIndex:index-1] != [NSNull null]) {
		[((EGOPhotoImageView*)[self.photoViews objectAtIndex:index-1]) killScrollViewZoom];
	} 	
	
}

- (void)layoutScrollViewSubviews {
	
	NSInteger _index = [self currentPhotoIndex];
	
	for (NSInteger page = _index -1; page < _index+3; page++) {
		
		if (page >= 0 && page < [self.photoSource numberOfPhotos]){
			
			CGFloat originX = self.scrollView.bounds.size.width * page;
			
			if (page < _index) {
				originX -= EGOPV_IMAGE_GAP;
			} 
			if (page > _index) {
				originX += EGOPV_IMAGE_GAP;
			}
			
			if ([self.photoViews objectAtIndex:page] == [NSNull null] || !((UIView*)[self.photoViews objectAtIndex:page]).superview){
				[self loadScrollViewWithPage:page];
			}
			
			EGOPhotoImageView *_photoView = (EGOPhotoImageView*)[self.photoViews objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(_photoView.frame, newframe)) {	
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				_photoView.frame = newframe;
				[UIView commitAnimations];
			
			}
			
		}
	}
	
}

- (void)setupScrollViewContentSize {
	
	CGFloat toolbarSize = self.embeddedInPopover ? 0.0f : self.navigationController.toolbar.frame.size.height;
	
	CGSize contentSize = self.view.bounds.size;
	contentSize.width = (contentSize.width * [self.photoSource numberOfPhotos]);
	
	if (!CGSizeEqualToSize(contentSize, self.scrollView.contentSize)) {
		self.scrollView.contentSize = contentSize;
	}
	
    if (!self.barsHidden) {
        CGFloat captionViewYposition = self.view.frame.size.height - toolbarSize - self.captionView.frame.size.height/2;
        self.captionView.center = CGPointMake(CGRectGetMidX(self.view.frame),captionViewYposition);
    }

}

- (void)enqueuePhotoViewAtIndex:(NSInteger)theIndex {
	
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (count > theIndex+1 || count < theIndex-1) {
				[view prepareForReusue];
				[view removeFromSuperview];
			} else {
				view.tag = 0;
			}
			
		} 
		count++;
	}	
	
}

- (EGOPhotoImageView*)dequeuePhotoView {
	
	NSInteger count = 0;
	for (EGOPhotoImageView *view in self.photoViews){
		if ([view isKindOfClass:[EGOPhotoImageView class]]) {
			if (view.superview == nil) {
				view.tag = count;
				return view;
			}
		}
		count ++;
	}	
	return nil;
	
}

- (void)loadScrollViewWithPage:(NSInteger)page {
	
    if (page < 0) return;
    if (page >= [self.photoSource numberOfPhotos]) return;
	
	EGOPhotoImageView * photoView = [self.photoViews objectAtIndex:page];
	if ((NSNull*)photoView == [NSNull null]) {
		
		photoView = [self dequeuePhotoView];
		if (photoView != nil) {
			[self.photoViews exchangeObjectAtIndex:photoView.tag withObjectAtIndex:page];
			photoView = [self.photoViews objectAtIndex:page];
		}
		
	}
	
	if (photoView == nil || (NSNull*)photoView == [NSNull null]) {
		
		photoView = [[EGOPhotoImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height)];
		[self.photoViews replaceObjectAtIndex:page withObject:photoView];
		
	} 
	
	[photoView setPhoto:[self.photoSource photoAtIndex:page]];
	
    if (photoView.superview == nil) {
		[self.scrollView addSubview:photoView];
	}
	
	CGRect frame = self.scrollView.frame;
	NSInteger centerPageIndex = self.pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + EGOPV_IMAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - EGOPV_IMAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	photoView.frame = frame;
}


#pragma mark - UIScrollView Delegate Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	if (self.pageIndex != _index && !self.rotating) {

		[self setBarsHidden:YES animated:YES];
		self.pageIndex = _index;
		[self setViewState];
		
		if (![scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
		
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	
	NSInteger _index = [self centerPhotoIndex];
	if (_index >= [self.photoSource numberOfPhotos] || _index < 0) {
		return;
	}
	
	[self moveToPhotoAtIndex:_index animated:YES];

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	[self layoutScrollViewSubviews];
}

@end