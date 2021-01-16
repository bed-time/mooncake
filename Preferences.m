#import <UIKit/UIKit.h>
#import "Headers.h"
#import "Mooncake.h"
#import "Preferences.h"

@implementation Preferences
@synthesize enabled;
@synthesize cornerRadius;

+(instancetype)sharedInstance{
	static Preferences *sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Preferences alloc] init];
		[sharedInstance loadPreferences];
    });

    return sharedInstance;
}

-(void)setup{
	[[NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter] addObserver:self selector:@selector(loadPreferences) name:@"luv.bedtime.mooncake/updatePreferences" object:NULL];
}

-(void)loadPreferences{
	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/luv.bedtime.mooncakeprefs.plist"];

	self->enabled = true;
	self->cornerRadius = 32.0;

    if(preferences){
		self->enabled = ([preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : self->enabled);
		self->cornerRadius = ([preferences objectForKey:@"cornerRadius"] ? [[preferences objectForKey:@"cornerRadius"] doubleValue] : self->cornerRadius);
    }

	[[NSClassFromString(@"SBControlCenterController") sharedInstanceIfExists] updateGestureRecognizers];
	[Mooncake.sharedInstanceIfExists updatePreferences];
}
@end