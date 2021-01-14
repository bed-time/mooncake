#include "mcpRootListController.h"

@implementation mcpRootListController
-(void)viewDidLoad{
	[super viewDidLoad];

	self.viewIfLoaded.backgroundColor = [UIColor colorWithRed: 0.04 green: 0.06 blue: 0.10 alpha: 1.00];
	self.viewIfLoaded.subviews[0].backgroundColor = UIColor.clearColor;

	barStyle = ((UINavigationController*)self.navigationController.parentViewController).navigationBar.barStyle;
	((UINavigationController*)self.navigationController.parentViewController).navigationBar.barStyle = UIBarStyleBlack;

	titleTextAttributes = ((UINavigationController*)self.navigationController.parentViewController).navigationBar.titleTextAttributes;
	((UINavigationController*)self.navigationController.parentViewController).navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];

	((UINavigationController*)self.navigationController.parentViewController).navigationBar.barStyle = barStyle;
	((UINavigationController*)self.navigationController.parentViewController).navigationBar.titleTextAttributes = titleTextAttributes;
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
	if([cell isKindOfClass:[NSClassFromString(@"PSTableCell") class]] && ((PSTableCell*)cell).titleLabel.textColor == UIColor.labelColor) ((PSTableCell*)cell).titleLabel.textColor = UIColor.whiteColor;
	return cell;
}
@end

