#include "mcpRootListController.h"
#include <spawn.h>

@implementation mcpRootListController
-(void)viewDidLoad{
	[super viewDidLoad];

	self.viewIfLoaded.backgroundColor = [UIColor colorWithRed: 0.04 green: 0.06 blue: 0.10 alpha: 1.00];
	self.viewIfLoaded.subviews[0].backgroundColor = UIColor.clearColor;

	[self table].separatorStyle = UITableViewCellSeparatorStyleNone;

	barStyle = self.navigationController.navigationController.navigationBar.barStyle;
	self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleBlack;

	titleTextAttributes = self.navigationController.navigationController.navigationBar.titleTextAttributes;
	self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];

	self.navigationController.navigationController.navigationBar.barStyle = barStyle;
	self.navigationController.navigationController.navigationBar.titleTextAttributes = titleTextAttributes;
}



- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(void)openInGithubBecauseIAmGodAndYouDoAsISay {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString: @"https://github.com/bed-time/mooncake"]
	options:@{}
	completionHandler:nil];
}

-(void)openDiscordBcISaidSo {
	[[UIApplication sharedApplication] 
	openURL:[NSURL URLWithString: @"https://discord.gg/xtze9JzcRq"]
	options:@{}
	completionHandler:nil];
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{

	UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
	cell.backgroundColor = UIColor.blackColor;

	cell.layer.shadowRadius  = 20.0f;
	cell.layer.shadowColor   = [UIColor blackColor].CGColor;
	cell.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
	cell.layer.shadowOpacity = 0.55f;
	cell.layer.masksToBounds = NO;
	cell.clipsToBounds = NO;

	if([cell isKindOfClass:[NSClassFromString(@"PSTableCell") class]] && ((PSTableCell*)cell).titleLabel.textColor == ([UIColor respondsToSelector:@selector(labelColor)] ? UIColor.labelColor : UIColor.blackColor)) ((PSTableCell*)cell).titleLabel.textColor = UIColor.whiteColor;
	return cell;
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier{
	[super setPreferenceValue:value specifier:specifier];

    NSMutableDictionary *preferences = [NSMutableDictionary dictionary];
    [preferences addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]]]];
    [preferences setObject:value forKey:specifier.properties[@"key"]];
    [preferences writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]] atomically:YES];

	[[NSClassFromString(@"NSDistributedNotificationCenter") defaultCenter] postNotificationName:@"luv.bedtime.mooncake/updatePreferences" object:NULL];
}
@end

