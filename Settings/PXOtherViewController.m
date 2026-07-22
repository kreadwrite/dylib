#import "PXOtherViewController.h"
#import "PXStatsViewController.h"
#import "../BHIManager.h"

@implementation PXOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Другое" : @"Other";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 4; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"Браузер и UI" : @"Browser & UI";
        case 1: return ru ? @"Фейковые данные" : @"Fake Data";
        case 2: return ru ? @"Расширения" : @"Extensions";
        case 3: return ru ? @"Настройки" : @"Settings";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 3;
        case 1: return 4;
        case 2: return 3;
        case 3: return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Открывать в Safari":@"Open in Safari") detail:(ru?@"Внешние ссылки всегда в Safari":@"Always open links in Safari") key:@"openInBrowser"];
            case 1: return [self switchCellTitle:(ru?@"Загрузка в HD":@"Upload HD") detail:(ru?@"Загружать видео в HD":@"Upload videos in HD quality") key:@"upload_hd"];
            case 2: return [self switchCellTitle:(ru?@"Блокировка приложения":@"App Lock") detail:(ru?@"Защита паролем при открытии":@"Passcode lock on launch") key:@"padlock"];
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Включить фейк":@"Enable Fake") detail:(ru?@"Включает визуальную подмену счётчиков":@"Enable fake counter display") key:@"en_fake"];
            case 1: {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UILabel *lbl = [[UILabel alloc] init];
                lbl.text = ru ? @"Подписчики:" : @"Followers:";
                lbl.font = [UIFont systemFontOfSize:15];
                lbl.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:lbl];
                UITextField *tf = [[UITextField alloc] init];
                tf.placeholder = ru ? @"Введите число" : @"Enter count";
                tf.borderStyle = UITextBorderStyleRoundedRect;
                tf.tag = 2; tf.returnKeyType = UIReturnKeyDone;
                tf.text = [d stringForKey:@"follower_count"];
                tf.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:tf];
                [NSLayoutConstraint activateConstraints:@[
                    [lbl.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
                    [lbl.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                    [lbl.widthAnchor constraintEqualToConstant:110],
                    [tf.leadingAnchor constraintEqualToAnchor:lbl.trailingAnchor constant:8],
                    [tf.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
                    [tf.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                    [tf.heightAnchor constraintEqualToConstant:32]
                ]];
                return cell;
            }
            case 2: {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                UILabel *lbl = [[UILabel alloc] init];
                lbl.text = ru ? @"Подписки:" : @"Following:";
                lbl.font = [UIFont systemFontOfSize:15];
                lbl.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:lbl];
                UITextField *tf = [[UITextField alloc] init];
                tf.placeholder = ru ? @"Введите число" : @"Enter count";
                tf.borderStyle = UITextBorderStyleRoundedRect;
                tf.tag = 1; tf.returnKeyType = UIReturnKeyDone;
                tf.text = [d stringForKey:@"following_count"];
                tf.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:tf];
                [NSLayoutConstraint activateConstraints:@[
                    [lbl.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
                    [lbl.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                    [lbl.widthAnchor constraintEqualToConstant:110],
                    [tf.leadingAnchor constraintEqualToAnchor:lbl.trailingAnchor constant:8],
                    [tf.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
                    [tf.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
                    [tf.heightAnchor constraintEqualToConstant:32]
                ]];
                return cell;
            }
            case 3: return [self switchCellTitle:(ru?@"Синяя галочка":@"Fake Verified") detail:(ru?@"Показывает галочку верификации":@"Show verification badge") key:@"fake_verify"];
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Расширенное био":@"Extended Bio") detail:(ru?@"Увеличивает лимит символов в био":@"Increase bio character limit") key:@"extended_bio"];
            case 1: return [self switchCellTitle:(ru?@"Расширенный комментарий":@"Extended Comment") detail:(ru?@"Увеличивает лимит символов в комментарии":@"Increase comment character limit") key:@"extendedComment"];
            case 2: {
                UITableViewCell *c = [self disclosureCellTitle:(ru?@"Статистика использования":@"Usage Stats") detail:@""];
                return c;
            }
        }
    } else if (indexPath.section == 3) {
        switch (indexPath.row) {
            case 0: {
                // Язык
                NSString *cur = [BHIManager isRussian] ? @"Русский" : @"English";
                return [self disclosureCellTitle:(ru?@"Язык интерфейса":@"Language") detail:cur];
            }
            case 1: {
                // Вибрация
                NSString *strength = [d stringForKey:@"px_haptic_strength"] ?: @"medium";
                NSDictionary *labelsRu = @{@"off":@"Выкл",@"light":@"Слабая",@"medium":@"Средняя",@"strong":@"Сильная"};
                NSDictionary *labelsEn = @{@"off":@"Off",@"light":@"Light",@"medium":@"Medium",@"strong":@"Strong"};
                NSString *lbl = ru ? labelsRu[strength] : labelsEn[strength];
                return [self disclosureCellTitle:(ru?@"Сила вибрации":@"Haptic Strength") detail:lbl];
            }
            case 2: return [self switchCellTitle:(ru?@"Регулировка вибрации":@"Adjust Haptics") detail:(ru?@"Включает выбор силы виброотклика":@"Enable haptic strength picker") key:@"px_haptics_adjust_enabled"];
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL ru = [self ru];

    if (indexPath.section == 2 && indexPath.row == 2) {
        PXStatsViewController *vc = [[PXStatsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Язык":@"Language") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Русский" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
            [[NSUserDefaults standardUserDefaults] setValue:@"ru" forKey:@"px_language"];
            [self.tableView reloadData];
            [self.tabBarController.viewControllers enumerateObjectsUsingBlock:^(UINavigationController *nc, NSUInteger i, BOOL *stop) {
                if ([nc isKindOfClass:[UINavigationController class]]) {
                    [nc.topViewController viewDidLoad];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
            [[NSUserDefaults standardUserDefaults] setValue:@"en" forKey:@"px_language"];
            [self.tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 3 && indexPath.row == 1) {
        NSArray *options = @[@[@"off",ru?@"Выкл":@"Off"],@[@"light",ru?@"Слабая":@"Light"],@[@"medium",ru?@"Средняя":@"Medium"],@[@"strong",ru?@"Сильная":@"Strong"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Сила вибрации":@"Haptic Strength") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSArray *opt in options) {
            [alert addAction:[UIAlertAction actionWithTitle:opt[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
                [[NSUserDefaults standardUserDefaults] setValue:opt[0] forKey:@"px_haptic_strength"];
                [self.tableView reloadData];
            }]];
        }
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
