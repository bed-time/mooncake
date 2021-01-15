@interface SBGrabberTongue : NSObject{
	UIPanGestureRecognizer *_edgePullGestureRecognizer;
}
@end

@interface SBControlCenterController : NSObject
@property(nonatomic) SBGrabberTongue *grabberTongue;
@property(nonatomic) UIPanGestureRecognizer *statusBarPullGestureRecognizer;
@property(nonatomic) UIGestureRecognizer *indirectStatusBarPullGestureRecognizer;
@end

@interface UISystemGestureView : UIView
@property(nonatomic) UIPanGestureRecognizer *mooncakeRecognizer;
@end

@interface CCUIModularControlCenterOverlayViewController : UIViewController
@end
@interface MTMaterialView: UIView
@end