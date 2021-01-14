#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <mooncakeprefs/mcpRootListController.h>
#import "Mooncake.h"


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class CCUIModularControlCenterOverlayViewController; 
static void (*_logos_orig$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST, SEL); 

#line 6 "Tweak.xm"
 
	static void _logos_method$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

		_logos_orig$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad(self, _cmd);
		
		

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];
	}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$CCUIModularControlCenterOverlayViewController = objc_getClass("CCUIModularControlCenterOverlayViewController"); { MSHookMessageEx(_logos_class$_ungrouped$CCUIModularControlCenterOverlayViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad, (IMP*)&_logos_orig$_ungrouped$CCUIModularControlCenterOverlayViewController$viewDidLoad);}} }
#line 20 "Tweak.xm"
