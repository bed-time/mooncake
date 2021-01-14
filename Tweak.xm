#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "Mooncake.h"

static BOOL Enable;


%group enabled

%hook CCUIModularControlCenterOverlayViewController 
	-(void)viewDidLoad {

		NSDictionary *bundle = []

		%orig;
		
		//backdrop

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];
	}
%end

// End %ctor

%end

// Is our tweak on?

%ctor {
    HBPreferences *pfs = [[HBPreferences alloc] initWithIdentifier:@"luv.bedtime.mooncake"];
    [pfs registerBool:&enabled default:YES forKey:@"Enabled"];
    if(Enable) {
        %init(enabled);
    }
}
