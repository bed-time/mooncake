#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Headers.h"
#import "substrate.h"
#import "ModuleLayout.h"
#import "Modules/Modules.h"

@interface Mooncake : UIWindow {
	CGPoint _panPosition;
	SBCoverSheetPrimarySlidingViewController *_coverSheetController;

	SBHomeGestureParticipant *participant;

	ModuleLayout *layout;

	UIView *menuView;
	UIVisualEffectView *backgroundBlurView;
}

@property(class, readonly, nonatomic) Mooncake *sharedInstance;
@property(class, readonly, nonatomic) Mooncake *sharedInstanceIfExists;

@property BOOL presented;
@property(nonatomic) NSMutableArray<NSMutableArray<UILayoutGuide*>*> *moduleLayoutGuides;
@property(nonatomic) UIView *moduleContainer;

+(NSUUID*)generateUniqueIdentifier;

-(void)setCoverSheetController:(SBCoverSheetPrimarySlidingViewController*)controller;

-(void)updatePreferences;

-(void)presentAnimated:(BOOL)animated;
-(void)dismissAnimated:(BOOL)animated;

-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end