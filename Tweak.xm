#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <mooncakeprefs/mcpRootListController.h>
#import "Mooncake.h"

%hook CCUIModularControlCenterOverlayViewController 
	-(void)viewDidLoad {

		%orig;
		
		//backdrop

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];
	}
%end

%hook mpcRootListController
	-(void)layoutSubviews {
		%orig;
		[self setBackgroundColor: [UIColor colorWithRed: 0.04 green: 0.06 blue: 0.10 alpha: 1.00]];
	}
%end