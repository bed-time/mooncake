#import <UIKit/UIKit.h>
#import "Mooncake.h"



%hook CCUIModularControlCenterOverlayViewController 
	-(void)viewDidLoad {

		%orig;
		
		//backdrop

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView* coverView = [[UIView alloc] initWithFrame:screenRect];

		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];
	}
%end