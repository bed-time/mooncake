@interface SBGrabberTongue : NSObject{
	UIPanGestureRecognizer *_edgePullGestureRecognizer;
}
@end

@interface SBControlCenterController : NSObject
@property(nonatomic) UIWindow *window;
@property(nonatomic) SBGrabberTongue *grabberTongue;
@property(nonatomic) UIPanGestureRecognizer *statusBarPullGestureRecognizer;
@property(nonatomic) UIGestureRecognizer *indirectStatusBarPullGestureRecognizer;

+(instancetype)sharedInstance;
+(instancetype)sharedInstanceIfExists;

-(void)updateGestureRecognizers;
@end