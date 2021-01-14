#include "mcpRootListController.h"

@implementation mcpRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)OpenInGithubBecauseIAmGodAndYouDoAsISay {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString: @"https://github.com/bed-time/mooncake"]
	options:@{}
	completionHandler:nil];
}

@end

