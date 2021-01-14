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
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	
	dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"Hi"] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction* dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
		[alert addAction:dismissAction];
		[[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:alert animated:YES completion:nil];
	});
	
	#pragma clang diagnostic pop

	NSMutableDictionary *preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/luv.bedtime.mooncakeprefs.plist"];

    if(preferences){
		self->enabled = ([preferences objectForKey:@"enabled"] ? [[preferences objectForKey:@"enabled"] boolValue] : enabled);
    }
}
@end