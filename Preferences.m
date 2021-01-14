#import <UIKit/UIKit.h>
#import "Preferences.h"

@implementation Preferences
@synthesize enabled;

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

    if(preferences){
		self->enabled = ([preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : enabled);
    }
}
@end