#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Headers.h"
#import "substrate.h"
#import "ModuleLayout.h"

@interface Mooncake : UIWindow {
	CGPoint _panPosition;
	SBCoverSheetPrimarySlidingViewController *_coverSheetController;
	NSMutableArray<NSString*> *_uuids;

	SBHomeGestureParticipant *participant;

	UIView *menuView;
	UIVisualEffectView *backgroundBlurView;
	UIView *moduleContainer;
}

@property(class, readonly) Mooncake *sharedInstance;
@property(class, readonly) Mooncake *sharedInstanceIfExists;

@property BOOL presented;

-(NSUUID*)generateUniqueIdentifier;

-(void)setCoverSheetController:(SBCoverSheetPrimarySlidingViewController*)controller;

-(void)updatePreferences;

-(void)presentAnimated:(BOOL)animated;
-(void)dismissAnimated:(BOOL)animated;

-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end