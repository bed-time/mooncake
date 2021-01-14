#import <Foundation/Foundation.h>

@interface CPDistributedMessagingCenter
+(instancetype)centerNamed:(NSString*)name;
-(void)registerForMessageName:(id)arg1 target:(id)arg2 selector:(SEL)arg3;
-(BOOL)sendMessageName:(id)arg1 userInfo:(id)arg2;
@end

@interface Preferences : NSObject
@property(class, readonly) Preferences *sharedInstance;
-(void)setup;

@property(readonly) BOOL enabled;
@end