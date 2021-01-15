#import "Mooncake.h"

@implementation Mooncake
+(instancetype)sharedInstance{
	static Mooncake *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Mooncake alloc] init];
    });

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

	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	[visualEffectView setFrame: CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2)];
	[visualEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self addSubview: visualEffectView];

	visualEffectView.layer.cornerRadius = 32;
	visualEffectView.layer.cornerCurve = kCACornerCurveContinuous;
	visualEffectView.clipsToBounds = YES;

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

	return self;
}

-(void)didTapOutside{
	presented = false;

	[UIView animateWithDuration:0.5 animations:^{
		self.alpha = 0;
	}];
}

-(void)didPan:(UIPanGestureRecognizer*)recognizer{
	CGFloat newY = [recognizer locationInView:recognizer.view].y;

	if(recognizer.state == UIGestureRecognizerStateBegan){
		_panY = newY;
		return;
	}

	if(presented) return;

	CGFloat diff = MAX(MIN(newY - _panY, 100), 0);
	self.alpha = diff / 100.0;

	if(recognizer.state == UIGestureRecognizerStateEnded){
		[UIView animateWithDuration:0.25 animations:^{
			if(diff >= 50) {
				self.alpha = 1;
				presented = true;
			} else self.alpha = 0;
		}];
	}
}
@end