#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Headers.h"

@interface Mooncake : UIWindow{
	CGFloat _panY;

	BOOL presented;
	SBHomeGestureParticipant *participant;
}

@property(class, readonly) Mooncake *sharedInstance;
@property(class, readonly) Mooncake *sharedInstanceIfExists;

@property UIVisualEffectView *backgroundBlurView;

-(void)updatePreferences;
-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end