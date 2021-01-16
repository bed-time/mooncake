#import <UIKit/UIKit.h>
#import <SpringBoard/SpringBoard.h>
#import <mooncakeprefs/mcpRootListController.h>
#import "Preferences.h"
#import "Mooncake.h"

//Disable default CC gesture
%hook SBControlCenterController
-(instancetype)init{
	SBControlCenterController *instance = %orig;

	[self updateGestureRecognizers];

	return instance;
}

%new
-(void)updateGestureRecognizers{
	[MSHookIvar<UIPanGestureRecognizer*>(self.grabberTongue, "_edgePullGestureRecognizer") removeTarget:self.grabberTongue action:@selector(_handlePullGesture:)];
	[MSHookIvar<UIPanGestureRecognizer*>(self.grabberTongue, "_edgePullGestureRecognizer") removeTarget:Mooncake.sharedInstance action:@selector(didPan:)];
	[self.statusBarPullGestureRecognizer removeTarget:self action:@selector(_handleStatusBarPullDownGesture:)];
	[self.statusBarPullGestureRecognizer removeTarget:Mooncake.sharedInstance action:@selector(didPan:)];
	[self.indirectStatusBarPullGestureRecognizer removeTarget:self action:@selector(_handleStatusBarPullDownGesture:)];
	[self.indirectStatusBarPullGestureRecognizer removeTarget:Mooncake.sharedInstance action:@selector(didPan:)];

	if(Preferences.sharedInstance.enabled){
		[MSHookIvar<UIPanGestureRecognizer*>(self.grabberTongue, "_edgePullGestureRecognizer") addTarget:Mooncake.sharedInstance action:@selector(didPan:)];
		[self.statusBarPullGestureRecognizer addTarget:Mooncake.sharedInstance action:@selector(didPan:)];
		[self.indirectStatusBarPullGestureRecognizer addTarget:Mooncake.sharedInstance action:@selector(didPan:)];
	} else{
		[MSHookIvar<UIPanGestureRecognizer*>(self.grabberTongue, "_edgePullGestureRecognizer") addTarget:self.grabberTongue action:@selector(_handlePullGesture:)];
		[self.statusBarPullGestureRecognizer addTarget:self action:@selector(_handleStatusBarPullDownGesture:)];
		[self.indirectStatusBarPullGestureRecognizer addTarget:self action:@selector(_handleStatusBarPullDownGesture:)];
	}
}
%end

%hook SBHomeHardwareButton
-(void)singlePressUp:(id)press{
	if(!Mooncake.sharedInstanceIfExists.presented) %orig;
	else [Mooncake.sharedInstanceIfExists dismissAnimated:true];
}
%end

%ctor {
	[Preferences.sharedInstance setup];
}