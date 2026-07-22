#import "PXRegionViewController.h"
#import "CountryTable.h"
#import "../BHIManager.h"

@implementation PXRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Регион" : @"Region";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionUpdated:) name:@"RegionSelectedNotification" object:nil];
}

- (void)regionUpdated:(NSNotification *)n { [self.tableView reloadData]; }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self ru] ? @"Подмена региона" : @"Region Spoofing";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self ru] ? @"Меняет регион, который видит TikTok. Требует перезапуска." : @"Changes the region TikTok detects. Requires restart.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    if (indexPath.row == 0) {
        return [self switchCellTitle:(ru?@"Включить смену региона":@"Enable Region Change") detail:(ru?@"Подменяет определяемый TikTok регион":@"Spoof the region TikTok detects") key:@"en_region"];
    } else {
        NSDictionary *sel = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"region"];
        NSString *cur = sel[@"area"] ?: (ru ? @"Не выбран" : @"Not selected");
        return [self disclosureCellTitle:(ru?@"Страна":@"Country") detail:cur];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        CountryTable *vc = [[CountryTable alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
