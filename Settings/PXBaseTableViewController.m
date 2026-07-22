#import "PXBaseTableViewController.h"
#import "../BHIManager.h"

@implementation PXBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
}

- (BOOL)ru {
    return [BHIManager isRussian];
}

- (UITableViewCell *)switchCellTitle:(NSString *)title detail:(NSString *)detail key:(NSString *)key {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    cell.detailTextLabel.numberOfLines = 0;

    UISwitch *sw = [[UISwitch alloc] init];
    sw.on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    sw.accessibilityLabel = key;
    sw.onTintColor = [UIColor systemPinkColor];
    [sw addTarget:self action:@selector(pxSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    return cell;
}

- (UITableViewCell *)disclosureCellTitle:(NSString *)title detail:(NSString *)detail {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)pxSwitchToggled:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:sender.accessibilityLabel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
