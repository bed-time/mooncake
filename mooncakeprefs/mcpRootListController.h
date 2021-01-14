#import <Preferences/PSListController.h>

@interface mcpRootListController : PSListController{
	int barStyle;
	NSDictionary *titleTextAttributes;
}
@end

@interface PSTableCell : UITableViewCell
@property UILabel *titleLabel;
@end