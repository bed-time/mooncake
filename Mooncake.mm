#import "Mooncake.h"
#import "Preferences.h"

@interface SingleModule : Module
@end

@implementation SingleModule
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1]
	];
}
@end

@interface WideModule : Module
@end

@implementation WideModule
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1],
		@[@1]
	];
}
@end

@interface CornerModule : Module
@end

@implementation CornerModule
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1, @1],
		@[@0, @1]
	];
}
@end

@interface DonutModule : Module
@end

@implementation DonutModule
+(NSArray<NSArray<NSNumber*>*>*)getShape{
	return @[
		@[@1, @1, @1],
		@[@1, @0, @1],
		@[@1, @1, @1]
	];
}
@end

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

	_uuids = [[NSMutableArray alloc] init];

	self.windowLevel = 1999;
	[self _setSecure:true];
	self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
	self.alpha = 0;
	self.hidden = false;

	self.presented = false;

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_didTapOutside)];
	[self addGestureRecognizer:tapRecognizer];

	menuView = [[UIView alloc] init];
	menuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.01];
	menuView.clipsToBounds = YES;

	UITapGestureRecognizer *dismissBlocker = [[UITapGestureRecognizer alloc] init];
	[menuView addGestureRecognizer:dismissBlocker];

	[self addSubview:menuView];

	//Blur-thingy
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

	backgroundBlurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];

	[backgroundBlurView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[menuView addSubview:backgroundBlurView];

	backgroundBlurView.layer.cornerCurve = kCACornerCurveContinuous;

	moduleContainer = [[UIView alloc] init];
	[menuView addSubview:moduleContainer];

	[self updatePreferences];

	return self;
}

-(NSUUID*)generateUniqueIdentifier{
	NSUUID *uuid = [NSUUID UUID];
	while([_uuids containsObject:uuid.UUIDString]) uuid = [NSUUID UUID];
	[_uuids addObject:uuid.UUIDString];
	return uuid;
}

-(void)setCoverSheetController:(SBCoverSheetPrimarySlidingViewController*)controller{
	_coverSheetController = controller;
}

-(void)_didTapOutside{
	[self dismissAnimated:true];
}

-(void)updatePreferences{
	menuView.layer.cornerRadius = Preferences.sharedInstance.cornerRadius;

	[menuView setFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2 + Preferences.sharedInstance.padding,
	UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2 - Preferences.sharedInstance.padding)];

	moduleContainer.frame = CGRectMake(Preferences.sharedInstance.contentMargin, Preferences.sharedInstance.contentMargin, menuView.bounds.size.width - 2 * Preferences.sharedInstance.contentMargin, menuView.bounds.size.height - 2 * Preferences.sharedInstance.contentMargin);

	//The less the slider is, less vibrant, but hard visibility
	for(UIView *view2 in backgroundBlurView.subviews) {
		if([view2 isMemberOfClass:NSClassFromString(@"_UIVisualEffectSubview")]) {
			[view2 setAlpha:Preferences.sharedInstance.alpha];
		}
	}
}

-(void)didPan:(UIPanGestureRecognizer*)recognizer{
	CGPoint _newPosition = [recognizer locationInView:recognizer.view];

	if(recognizer.state == UIGestureRecognizerStateBegan){
		_panPosition = _newPosition;
		if(!self.presented) [self willPresent];
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
			} else {
				self.alpha = 0;
				[self didDismiss];
			}
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

-(void)willPresent{
	ModuleLayout *layout = [[ModuleLayout alloc] initWithSize:CGSizeMake(4, 4)];

	SingleModule *single1 = [[SingleModule alloc] init];
	[layout addModule:single1 atLocation:CGPointMake(0, 0)];

	SingleModule *single2 = [[SingleModule alloc] init];
	[layout addModule:single2 atLocation:CGPointMake(1, 0)];

	WideModule *wide = [[WideModule alloc] init];
	[layout addModule:wide atLocation:CGPointMake(3, 2)];

	CornerModule *corner = [[CornerModule alloc] init];
	[layout addModule:corner atLocation:CGPointMake(2, 0)];

	DonutModule *donut = [[DonutModule alloc] init];
	[layout addModule:donut atLocation:CGPointMake(0, 1)];

	SingleModule *single3 = [[SingleModule alloc] init];
	[layout addModule:single3 atLocation:CGPointMake(1, 2)];

	CGFloat side = (moduleContainer.bounds.size.width - (layout.size.width - 1) * Preferences.sharedInstance.spaceBetweenModules) / layout.size.width;
	CGFloat cornerRadius = Preferences.sharedInstance.cornerRadius - Preferences.sharedInstance.contentMargin;
	CGFloat innerCornerRadius = cornerRadius / 1.5;

	for(Module *module in layout.modules){
		CGRect bounds = [layout boundsForModule:module];
		module.frame = CGRectMake(bounds.origin.x * (side + Preferences.sharedInstance.spaceBetweenModules), bounds.origin.y * (side + Preferences.sharedInstance.spaceBetweenModules), bounds.size.width * side + (bounds.size.width - 1) * Preferences.sharedInstance.spaceBetweenModules, bounds.size.height * side + (bounds.size.height - 1) * Preferences.sharedInstance.spaceBetweenModules);
		module.backgroundColor = UIColor.whiteColor;

		CAShapeLayer *layer = [CAShapeLayer layer];
		UIBezierPath *path = [UIBezierPath bezierPath];

		NSArray<NSArray<NSNumber*>*> *shape = [module.class getPaddedAndTrimmedShape];
		for(int x = 0; x < [module.class getShapeSize].width; x++){
			for(int y = 0; y < [module.class getShapeSize].height; y++){
				if(![shape[y][x] boolValue]) continue;

				[path appendPath:[UIBezierPath bezierPathWithRoundedRect:CGRectMake(x * (side + Preferences.sharedInstance.spaceBetweenModules), y * (side + Preferences.sharedInstance.spaceBetweenModules), side, side) cornerRadius:cornerRadius]];

				//Connectors
				if(x > 0 && [shape[y][x - 1] boolValue]){
					[path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules - cornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules), Preferences.sharedInstance.spaceBetweenModules + 2 * cornerRadius, side)]];
				}

				if(y > 0 && [shape[y - 1][x] boolValue]){
					[path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(x * (side + Preferences.sharedInstance.spaceBetweenModules), y * side + (y - 1) * Preferences.sharedInstance.spaceBetweenModules - cornerRadius, side, Preferences.sharedInstance.spaceBetweenModules + 2 * cornerRadius)]];
				}
				
				//Middle Filler
				if(x > 0 && y > 0 && [shape[y][x - 1] boolValue] && [shape[y - 1][x] boolValue] && [shape[y - 1][x - 1] boolValue]){
					[path appendPath:[UIBezierPath bezierPathWithRect:CGRectMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules - cornerRadius, y * side + (y - 1) * Preferences.sharedInstance.spaceBetweenModules - cornerRadius, Preferences.sharedInstance.spaceBetweenModules + 2 * cornerRadius, Preferences.sharedInstance.spaceBetweenModules + 2 * cornerRadius)]];
				}

				//Inner Corner
				if(x > 0 && y < [module.class getShapeSize].height - 1 && [shape[y][x - 1] boolValue] && [shape[y + 1][x - 1] boolValue] && ![shape[y + 1][x] boolValue]){
					UIBezierPath *innerCorner = [UIBezierPath bezierPathWithRect:CGRectMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules, innerCornerRadius, innerCornerRadius)];
					UIBezierPath *cornerSegment = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius) radius:innerCornerRadius startAngle:M_PI endAngle:1.5 * M_PI clockwise:true];
					[cornerSegment addLineToPoint:CGPointMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius)];
					[innerCorner appendPath:[cornerSegment bezierPathByReversingPath]];
					[path appendPath:innerCorner];
				}

				if(x < [module.class getShapeSize].width - 1 && y < [module.class getShapeSize].height - 1 && [shape[y][x + 1] boolValue] && [shape[y + 1][x + 1] boolValue] && ![shape[y + 1][x] boolValue]){
					UIBezierPath *innerCorner = [UIBezierPath bezierPathWithRect:CGRectMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules, innerCornerRadius, innerCornerRadius)];
					UIBezierPath *cornerSegment = [UIBezierPath bezierPathWithArcCenter:CGPointMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius) radius:innerCornerRadius startAngle:1.5 * M_PI endAngle:0 clockwise:true];
					[cornerSegment addLineToPoint:CGPointMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, (y + 1) * side + y * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius)];
					[innerCorner appendPath:[cornerSegment bezierPathByReversingPath]];
					[path appendPath:innerCorner];
				}

				if(x > 0 && y > 0 && [shape[y][x - 1] boolValue] && [shape[y - 1][x - 1] boolValue] && ![shape[y - 1][x] boolValue]){
					UIBezierPath *innerCorner = [UIBezierPath bezierPathWithRect:CGRectMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, innerCornerRadius, innerCornerRadius)];
					UIBezierPath *cornerSegment = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius) radius:innerCornerRadius startAngle:0.5 * M_PI endAngle:M_PI clockwise:true];
					[cornerSegment addLineToPoint:CGPointMake(x * side + (x - 1) * Preferences.sharedInstance.spaceBetweenModules + innerCornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius)];
					[innerCorner appendPath:[cornerSegment bezierPathByReversingPath]];
					[path appendPath:innerCorner];
				}

				if(x < [module.class getShapeSize].width - 1 && y > 0 && [shape[y][x + 1] boolValue] && [shape[y - 1][x + 1] boolValue] && ![shape[y - 1][x] boolValue]){
					UIBezierPath *innerCorner = [UIBezierPath bezierPathWithRect:CGRectMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, innerCornerRadius, innerCornerRadius)];
					UIBezierPath *cornerSegment = [UIBezierPath bezierPathWithArcCenter:CGPointMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius) radius:innerCornerRadius startAngle:0 endAngle:0.5 * M_PI clockwise:true];
					[cornerSegment addLineToPoint:CGPointMake((x + 1) * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius, y * (side + Preferences.sharedInstance.spaceBetweenModules) - innerCornerRadius)];
					[innerCorner appendPath:[cornerSegment bezierPathByReversingPath]];
					[path appendPath:innerCorner];
				}
			}
		}

		layer.path = path.CGPath;
		module.layer.mask = layer;

		[moduleContainer addSubview:module];
	}
}

-(void)didPresent{
	participant = [((SBMainWorkspace*)[NSClassFromString(@"SBMainWorkspace") sharedInstance]).homeGestureArbiter participantWithIdentifier:15 delegate:NULL];

	MSHookIvar<UIPanGestureRecognizer*>(_coverSheetController.grabberTongue, "_edgePullGestureRecognizer").enabled = false;
}

-(void)willDismiss{
	[participant invalidate];
	participant = NULL;

	MSHookIvar<UIPanGestureRecognizer*>(_coverSheetController.grabberTongue, "_edgePullGestureRecognizer").enabled = true;
}

-(void)didDismiss{
	for(UIView *subview in moduleContainer.subviews) [subview removeFromSuperview];
}
@end