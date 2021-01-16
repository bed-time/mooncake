#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Headers.h"
#import "substrate.h"

@interface Mooncake : UIWindow {
	CGPoint _panPosition;

	SBHomeGestureParticipant *participant;
}

@property(class, readonly) Mooncake *sharedInstance;
@property(class, readonly) Mooncake *sharedInstanceIfExists;

@property BOOL presented;
@property UIVisualEffectView *backgroundBlurView;

-(void)updatePreferences;

-(void)presentAnimated:(BOOL)animated;
-(void)dismissAnimated:(BOOL)animated;

-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end