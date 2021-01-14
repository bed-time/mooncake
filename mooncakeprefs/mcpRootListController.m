#include "mcpRootListController.h"

@implementation mcpRootListController
-(void)viewDidLoad{
	[super viewDidLoad];

	self.viewIfLoaded.backgroundColor = [UIColor colorWithRed: 0.04 green: 0.06 blue: 0.10 alpha: 1.00];
	self.viewIfLoaded.subviews[0].backgroundColor = UIColor.clearColor;

	barStyle = self.navigationController.navigationController.navigationBar.barStyle;
	self.navigationController.navigationController.navigationBar.barStyle = UIBarStyleBlack;

	titleTextAttributes = self.navigationController.navigationController.navigationBar.titleTextAttributes;
	self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
    [super viewDidLoad];
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

	cell.layer.shadowRadius  = 1.5f;
	cell.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
	cell.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
	cell.layer.shadowOpacity = 0.9f;
	cell.layer.masksToBounds = NO;

	cell.clipsToBounds = NO;

	if([cell isKindOfClass:[NSClassFromString(@"PSTableCell") class]] && ((PSTableCell*)cell).titleLabel.textColor == UIColor.labelColor) ((PSTableCell*)cell).titleLabel.textColor = UIColor.whiteColor;
	return cell;
}
@end

