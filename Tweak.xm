#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <mooncakeprefs/mcpRootListController.h>
#import "Mooncake.h"
#import "Preferences.h"

%hook CCUIModularControlCenterOverlayViewController 
	-(void)viewDidLoad {

		%orig;
		
		//backdrop

		CGRect screenRect = [[UIScreen mainScreen] bounds];

		UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];

		//Blur-thingy

		UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    	UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    	[visualEffectView setFrame:self.view.bounds];
    	[visualEffectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

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