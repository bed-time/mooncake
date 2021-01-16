#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIWindow()
-(void)_setSecure:(BOOL)secure;
@end

@interface Mooncake : UIWindow{
	CGFloat _panY;

	BOOL presented;
}

@property(class, readonly) Mooncake *sharedInstance;
@property(class, readonly) Mooncake *sharedInstanceIfExists;

@property UIVisualEffectView *backgroundBlurView;

-(void)updatePreferences;
-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end