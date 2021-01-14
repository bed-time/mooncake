#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
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

		UIView *blur = [[%c(MTMaterialView) alloc] initWithFrame:screenRect];
		blur.userInteractionEnabled = NO;

		[coverView addSubview: blur];
	}
%end