#import "Headers.h"

@interface UIGestureRecognizerTarget : NSObject
@property(nonatomic, readonly) id target;
@property(nonatomic, readonly) SEL action;
@end

@interface UISystemGestureView : UIView
@property(nonatomic) UIPanGestureRecognizer *mooncakeRecognizer;
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end
@interface MTMaterialView: UIView
@end