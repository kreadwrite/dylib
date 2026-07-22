#import "PXOtherViewController.h"
#import "PXStatsViewController.h"
#import "../BHIManager.h"

@implementation PXOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Другое" : @"Other";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"UI и загрузка" : @"UI & Upload";
        case 1: return ru ? @"Расширения текста" : @"Text Extensions";
        case 2: return ru ? @"Язык и настройки" : @"Language & Settings";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 3;
        case 1: return 2;
        case 2: return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Открывать в Safari":@"Open in Safari") detail:(ru?@"Все ссылки в Safari":@"Open external links in Safari") key:@"openInBrowser"];
            case 1: return [self switchCellTitle:(ru?@"Загрузка в HD":@"Upload HD") detail:(ru?@"Загружать видео в HD":@"Upload videos in HD quality") key:@"upload_hd"];
            case 2: return [self switchCellTitle:(ru?@"Блокировка приложения":@"App Lock") detail:(ru?@"Пароль при открытии":@"Passcode lock on launch") key:@"padlock"];
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Расширенное био":@"Extended Bio") detail:(ru?@"Больше символов в описании профиля":@"Increase bio character limit") key:@"extended_bio"];
            case 1: return [self switchCellTitle:(ru?@"Расширенный комментарий":@"Extended Comment") detail:(ru?@"Больше символов в комментариях":@"Increase comment character limit") key:@"extendedComment"];
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: {
                NSString *cur = [BHIManager isRussian] ? @"Русский" : @"English";
                return [self disclosureCellTitle:(ru?@"Язык интерфейса":@"Language") detail:cur];
            }
            case 1: {
                UITableViewCell *c = [self disclosureCellTitle:(ru?@"Статистика":@"Usage Stats") detail:@""];
                return c;
            }
            case 2: {
                NSString *strength = [d stringForKey:@"px_haptic_strength"] ?: @"medium";
                NSDictionary *lRu = @{@"off":@"Выкл",@"light":@"Слабая",@"medium":@"Средняя",@"strong":@"Сильная"};
                NSDictionary *lEn = @{@"off":@"Off",@"light":@"Light",@"medium":@"Medium",@"strong":@"Strong"};
                return [self disclosureCellTitle:(ru?@"Вибрация":@"Haptics") detail:ru?lRu[strength]:lEn[strength]];
            }
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL ru = [self ru];

    if (indexPath.section == 2 && indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Язык":@"Language") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Русский" style:UIAlertActionStyleDefault handler:^(id a) {
            [[NSUserDefaults standardUserDefaults] setValue:@"ru" forKey:@"px_language"];
            [self.tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(id a) {
            [[NSUserDefaults standardUserDefaults] setValue:@"en" forKey:@"px_language"];
            [self.tableView reloadData];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        [self.navigationController pushViewController:[[PXStatsViewController alloc] init] animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 2) {
        NSArray *opts = @[@[@"off",ru?@"Выкл":@"Off"],@[@"light",ru?@"Слабая":@"Light"],@[@"medium",ru?@"Средняя":@"Medium"],@[@"strong",ru?@"Сильная":@"Strong"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Вибрация":@"Haptics") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSArray *opt in opts) {
            [alert addAction:[UIAlertAction actionWithTitle:opt[1] style:UIAlertActionStyleDefault handler:^(id a) {
                [[NSUserDefaults standardUserDefaults] setValue:opt[0] forKey:@"px_haptic_strength"];
                [self.tableView reloadData];
            }]];
        }
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
