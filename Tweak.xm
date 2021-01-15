#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <mooncakeprefs/mcpRootListController.h>
#import "Mooncake.h"
#import "Preferences.h"

@interface UIGestureRecognizer()
@property(nonatomic) NSNumber *lockEnabled;
@property(nonatomic) NSNumber *trueEnabled;
@end

%hook UIGestureRecognizer
%property(nonatomic) NSNumber *lockEnabled;
%property(nonatomic) NSNumber *trueEnabled;

-(void)setEnabled:(BOOL)enabled{
	if(!self.lockEnabled || ![self.lockEnabled boolValue]) %orig;
}

-(BOOL)enabled{
	if(!self.lockEnabled || ![self.lockEnabled boolValue] || !self.trueEnabled) return %orig;
	else return [self.trueEnabled boolValue];
}

%new
-(void)setTrueEnabled:(BOOL)enabled{
	self.lockEnabled = @false;
	self.enabled = enabled;
	self.lockEnabled = @true;
}
%end

%hook CCUIModularControlCenterOverlayViewController 
-(void)viewDidLoad {
	%orig;
	
	//backdrop
	CGRect screenRect = [[UIScreen mainScreen] bounds];

	UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
	coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	coverView.userInteractionEnabled = NO;
	[coverView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self.view addSubview: coverView];

	//Blur-thingy
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	[visualEffectView setFrame: CGRectMake(0, UIScreen.mainScreen.bounds.size.height / 2, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height / 2)];
	[visualEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self.view addSubview: visualEffectView];

	visualEffectView.layer.cornerRadius = 32;
	visualEffectView.layer.cornerCurve = kCACornerCurveContinuous;
	visualEffectView.clipsToBounds = YES;

	//Saturate and lighten the blur by removing the stupid subview thing that ios makes

	for(UIView *view in self.view.subviews) {
		if([view isMemberOfClass:%c(UIVisualEffectView)]) {
			for(UIView *view2 in view.subviews) {
				if([view2 isMemberOfClass:%c(_UIVisualEffectSubview)]) {
					[view2 removeFromSuperview];
				}
			}
		}
	}
}
%end

%ctor {
	[Preferences.sharedInstance setup];
}