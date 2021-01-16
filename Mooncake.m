#import "Mooncake.h"
#import "Preferences.h"

@implementation Mooncake
@synthesize backgroundBlurView;

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

	self.windowLevel = UIWindowLevelAlert + 1;
	[self _setSecure:true];
	self.backgroundColor = UIColor.clearColor;
	self.alpha = 0;
	self.hidden = false;

	presented = false;

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOutside)];
	[self addGestureRecognizer:tapRecognizer];

	//Blur-thingy
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

	self.backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

	[self.backgroundBlurView setFrame: CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2 + Preferences.sharedInstance.padding,
	 UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2 - Preferences.sharedInstance.padding)];

	[self.backgroundBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self addSubview: self.backgroundBlurView];

	self.backgroundBlurView.layer.cornerCurve = kCACornerCurveContinuous;
	self.backgroundBlurView.clipsToBounds = YES;

	//Saturate and lighten the blur by removing the stupid subview thing that ios makes

	for(UIView *view in self.subviews) {
		if([view isMemberOfClass:NSClassFromString(@"UIVisualEffectView")]) {
			for(UIView *view2 in view.subviews) {
				if([view2 isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")]) {
					[view2 removeFromSuperview];
				}
			}
		}
	}

	[self updatePreferences];

	return self;
}

-(void)didTapOutside{
	presented = false;
	[self didDismiss];

	[UIView animateWithDuration:0.25 animations:^{
		self.alpha = 0;
	}];
}

-(void)updatePreferences{
	self.backgroundBlurView.layer.cornerRadius = Preferences.sharedInstance.cornerRadius;
}

-(void)didPan:(UIPanGestureRecognizer*)recognizer{
	CGFloat newY = [recognizer locationInView:recognizer.view].y;

	if(recognizer.state == UIGestureRecognizerStateBegan){
		_panY = newY;
		return;
	}

	if(presented) return;

	CGFloat diff = MAX(MIN(newY - _panY, 100), 0);

	[UIView animateWithDuration:0.25 animations:^{
		if(recognizer.state != UIGestureRecognizerStateEnded){
			self.alpha = diff / 100.0;
		} else{
			if(diff >= 50) {
				self.alpha = 1;
				presented = true;
				[self didPresent];
			} else self.alpha = 0;
		}
	}];
}

-(void)didPresent{
	participant = [((SBMainWorkspace*)[NSClassFromString(@"SBMainWorkspace") sharedInstance]).homeGestureArbiter participantWithIdentifier:15 delegate:NULL];
}

-(void)didDismiss{
	[participant invalidate];
	participant = NULL;
}
@end