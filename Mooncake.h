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

-(void)didPan:(UIPanGestureRecognizer*)recognizer;
@end