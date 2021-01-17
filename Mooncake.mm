#import "Mooncake.h"
#import "Preferences.h"

@implementation Mooncake
static Mooncake *sharedInstance = NULL;
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Mooncake alloc] init];
    });

    return sharedInstance;
}

+(instancetype)sharedInstanceIfExists{
    return sharedInstance;
}

-(instancetype)init{
	self = [super init];

	self.windowLevel = 1999;
	[self _setSecure:true];
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
	self.alpha = 0;
	self.hidden = false;

	self.presented = false;

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTapOutside)];
	[self addGestureRecognizer:tapRecognizer];

	//Blur-thingy
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

	self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

	[self.backgroundBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self addSubview: self.backgroundBlurView];

	self.backgroundBlurView.layer.cornerCurve = kCACornerCurveContinuous;
	self.backgroundBlurView.clipsToBounds = YES;

	[self updatePreferences];

	return self;
}

-(void)setCoverSheetController:(SBCoverSheetPrimarySlidingViewController*)controller{
	_coverSheetController = controller;
}

-(void)_didTapOutside{
	[self dismissAnimated:true];
}

-(void)updatePreferences{
	self.backgroundBlurView.layer.cornerRadius = Preferences.sharedInstance.cornerRadius;

	[self.backgroundBlurView setFrame: CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2 + Preferences.sharedInstance.padding,
	UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2 - Preferences.sharedInstance.padding)];

	//The less the slider is, more vibrant, but hard visibility

	for(UIView *view in self.subviews) {
		if([view isMemberOfClass:NSClassFromString(@"UIVisualEffectView")]) {
			for(UIView *view2 in view.subviews) {
				if([view2 isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")]) {
					[view2 setAlpha: Preferences.sharedInstance.alpha];
				}
			}
		}
	}
}

-(void)didPan:(UIPanGestureRecognizer*)recognizer{
	CGPoint _newPosition = [recognizer locationInView:recognizer.view];

	if(recognizer.state == UIGestureRecognizerStateBegan){
		_panPosition = _newPosition;
		return;
	}

	if(self.presented) return;

	int orientation = MSHookIvar<NSInteger>(((SpringBoard*)UIApplication.sharedApplication), "_activeInterfaceOrientation");
	BOOL modern = ((SBControlCenterController*)[NSClassFromString(@"SBControlCenterController") sharedInstance]).homeAffordanceViewController;

	double multiplier = ((orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) ? (!modern ? -1.0 : 1.0) : 1.0) * ((orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationPortraitUpsideDown) ? -1.0 : 1.0);
	double old = ((orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) ? _panPosition.y : _panPosition.x);
	double current = ((orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) ? _newPosition.y : _newPosition.x);

	double diff = fmax(fmin((current - old) * multiplier, 100.0), 0.0);

	[UIView animateWithDuration:0.25 animations:^{
		if(recognizer.state != UIGestureRecognizerStateEnded){
			self.alpha = diff / 100.0;
		} else{
			if(diff >= 50) {
				self.alpha = 1;
				self.presented = true;
				[self didPresent];
			} else self.alpha = 0;
		}
	}];
}

-(void)presentAnimated:(BOOL)animated{
	[self willPresent];

	if(animated){
		[UIView animateWithDuration:0.25 animations:^{
			self.alpha = 1;
		} completion:^(BOOL finished){
			self.presented = true;
			[self didPresent];
		}];
	} else{
		self.alpha = 1;
		self.presented = true;
		[self didPresent];
	}
}

-(void)dismissAnimated:(BOOL)animated{
	self.presented = false;
	[self willDismiss];

	if(animated){
		[UIView animateWithDuration:0.25 animations:^{
			self.alpha = 0;
		} completion:^(BOOL finished){
			[self didDismiss];
		}];
	} else{
		self.alpha = 0;
		[self didDismiss];
	}
}

-(void)willPresent{}

-(void)didPresent{
	participant = [((SBMainWorkspace*)[NSClassFromString(@"SBMainWorkspace") sharedInstance]).homeGestureArbiter participantWithIdentifier:15 delegate:NULL];

	MSHookIvar<UIPanGestureRecognizer*>(_coverSheetController.grabberTongue, "_edgePullGestureRecognizer").enabled = false;
}

-(void)willDismiss{
	[participant invalidate];
	participant = NULL;

	MSHookIvar<UIPanGestureRecognizer*>(_coverSheetController.grabberTongue, "_edgePullGestureRecognizer").enabled = true;
}

-(void)didDismiss{}
@end