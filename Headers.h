#import <SpringBoard/SpringBoard.h>

@interface UIWindow()
-(void)_setSecure:(BOOL)secure;
@end

@interface UIDevice()
+(BOOL)_hasHomeButton;
@end

@interface SBGrabberTongue : NSObject{
	UIPanGestureRecognizer *_edgePullGestureRecognizer;
}
@end

@interface SBControlCenterController : NSObject
@property(nonatomic) UIWindow *window;
@property(nonatomic) UIViewController *homeAffordanceViewController;
@property(nonatomic) SBGrabberTongue *grabberTongue;
@property(nonatomic) UIPanGestureRecognizer *statusBarPullGestureRecognizer;
@property(nonatomic) UIGestureRecognizer *indirectStatusBarPullGestureRecognizer;

+(instancetype)sharedInstance;
+(instancetype)sharedInstanceIfExists;

-(void)updateGestureRecognizers;
@end

@interface SBHomeGestureParticipant : NSObject
-(void)invalidate;
@end

@interface SBHomeGestureArbiter : NSObject
-(SBHomeGestureParticipant*)participantWithIdentifier:(NSInteger)identifier delegate:(id)delegate;
@end

@interface SBMainWorkspace : NSObject
@property(class, readonly) SBMainWorkspace *sharedInstance;

@property SBHomeGestureArbiter *homeGestureArbiter;
@end

@interface SBCoverSheetPrimarySlidingViewController : UIViewController
@property(nonatomic) SBGrabberTongue *grabberTongue;
@end