#line 1 "Tweak.xm"
#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import "Mooncake.h"

static BOOL Enable;



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


#line 8 "Tweak.xm"
static void (*_logos_orig$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST, SEL); static void _logos_method$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST, SEL); 

 
	static void _logos_method$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL CCUIModularControlCenterOverlayViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {

		NSDictionary *bundle = []

		_logos_orig$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad(self, _cmd);
		
		

		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView *coverView = [[UIView alloc] initWithFrame:screenRect];
		coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
		coverView.userInteractionEnabled = NO;
		[self.view addSubview: coverView];
	}








static __attribute__((constructor)) void _logosLocalCtor_d84aacd4(int __unused argc, char __unused **argv, char __unused **envp) {
    HBPreferences *pfs = [[HBPreferences alloc] initWithIdentifier:@"luv.bedtime.mooncake"];
    [pfs registerBool:&enabled default:YES forKey:@"Enabled"];
    if(Enable) {
        {Class _logos_class$enabled$CCUIModularControlCenterOverlayViewController = objc_getClass("CCUIModularControlCenterOverlayViewController"); { MSHookMessageEx(_logos_class$enabled$CCUIModularControlCenterOverlayViewController, @selector(viewDidLoad), (IMP)&_logos_method$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad, (IMP*)&_logos_orig$enabled$CCUIModularControlCenterOverlayViewController$viewDidLoad);}}
    }
}
