//
//  PXExtraViewController.m  — PXTok 1.1
//  Главная вкладка «PXTok» с заголовком-версией и всеми функциями
//
#import "PXExtraViewController.h"
#import "PXStreakViewController.h"
#import "PXDeletedMessagesViewController.h"
#import "PXFontManagerViewController.h"
#import "PXWordBlacklistViewController.h"
#import "PXStoryBorderViewController.h"
#import "PXAssets.h"
#import "../BHIManager.h"

#define PX_VERSION @"PXTok 1.1"

// ─── Секции
typedef NS_ENUM(NSInteger, PXSection) {
    PXSectionContent  = 0,
    PXSectionUI       = 1,
    PXSectionStreak   = 2,
    PXSectionDeleted  = 3,
    PXSectionFonts    = 4,
    PXSectionFilter   = 5,
    PXSectionBlacklist = 6,
    PXSectionLinks    = 7,
    PXSectionCount
};

@implementation PXExtraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PXTok";
    [self setupHeaderView];
}

// ─── Красивый хедер с лого и версией ───
- (void)setupHeaderView {
    CGFloat headerH = 100;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, headerH)];
    header.backgroundColor = [UIColor clearColor];

    // Лого — маленькое с округлёнными краями
    UIImageView *logo = [[UIImageView alloc] initWithImage:[PXAssets pxIcon]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.layer.cornerRadius = 16;
    logo.clipsToBounds = YES;
    logo.frame = CGRectMake(20, 20, 56, 56);

    // Название + версия
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"PXTok";
    nameLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    nameLabel.frame = CGRectMake(90, 22, 200, 26);

    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = PX_VERSION;
    versionLabel.font = [UIFont systemFontOfSize:13];
    versionLabel.textColor = [UIColor secondaryLabelColor];
    versionLabel.frame = CGRectMake(90, 50, 200, 18);

    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = [self ru] ? @"Улучшенный TikTok" : @"Enhanced TikTok Experience";
    subLabel.font = [UIFont systemFontOfSize:12];
    subLabel.textColor = [UIColor tertiaryLabelColor];
    subLabel.frame = CGRectMake(90, 68, 220, 16);

    [header addSubview:logo];
    [header addSubview:nameLabel];
    [header addSubview:versionLabel];
    [header addSubview:subLabel];

    self.tableView.tableHeaderView = header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return PXSectionCount; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case PXSectionContent:   return ru ? @"Контент и перевод" : @"Content & Translation";
        case PXSectionUI:        return ru ? @"Интерфейс" : @"Interface";
        case PXSectionStreak:    return ru ? @"Автопродление огонька 🔥" : @"Streak Auto-Renew 🔥";
        case PXSectionDeleted:   return ru ? @"Удалённые сообщения" : @"Deleted Messages";
        case PXSectionFonts:     return ru ? @"Шрифты" : @"Fonts";
        case PXSectionFilter:    return ru ? @"Фильтр по длительности" : @"Duration Filter";
        case PXSectionBlacklist: return ru ? @"Чёрный список слов" : @"Word Blacklist";
        case PXSectionLinks:     return ru ? @"О PXTok" : @"About PXTok";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case PXSectionContent:   return 5;
        case PXSectionUI:        return 6;
        case PXSectionStreak:    return 1;
        case PXSectionDeleted:   return 1;
        case PXSectionFonts:     return 1;
        case PXSectionFilter:    return 3;
        case PXSectionBlacklist: return 1;
        case PXSectionLinks:     return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];

    switch (indexPath.section) {
        case PXSectionContent: {
            switch (indexPath.row) {
                case 0: return [self switchCellTitle:(ru?@"Автосохранение избранного":@"Auto-backup Favorites") detail:(ru?@"Тихо копирует видео в галерею при добавлении в избранное":@"Silently saves video when favorited") key:@"auto_dw_favorites"];
                case 1: return [self switchCellTitle:(ru?@"Перевод описания":@"Translate Description") detail:(ru?@"Добавляет кнопку перевода в меню":@"Adds translate to long-press menu") key:@"translate_description"];
                case 2: return [self switchCellTitle:(ru?@"Перевод комментариев":@"Translate Comments") detail:(ru?@"Кнопка перевода под каждым комментарием":@"Translate button under each comment") key:@"translate_comment"];
                case 3: return [self switchCellTitle:(ru?@"Авто-раскрытие ответов":@"Auto-expand Replies") detail:(ru?@"Автоматически разворачивает ветки":@"Auto-expand comment threads") key:@"auto_expand_replies"];
                case 4: return [self switchCellTitle:(ru?@"Всегда открывать в Safari":@"Always Open in Safari") detail:(ru?@"Внешние ссылки в Safari":@"Open external links in Safari") key:@"openInBrowser"];
            }
        }
        case PXSectionUI: {
            switch (indexPath.row) {
                case 0: return [self switchCellTitle:(ru?@"Скрыть кнопку «+»":@"Hide '+' Button") detail:(ru?@"Убирает кнопку создания":@"Remove create button") key:@"hide_plus_button"];
                case 1: return [self switchCellTitle:(ru?@"Скрыть значки уведомлений":@"Hide Badges") detail:(ru?@"Убирает красные точки":@"Remove red dots from tabs") key:@"hide_notification_badges"];
                case 2: return [self switchCellTitle:(ru?@"OLED-клавиатура":@"OLED Keyboard") detail:(ru?@"Принудительно тёмная клавиатура":@"Force dark keyboard") key:@"oled_keyboard"];
                case 3: return [self switchCellTitle:(ru?@"Скрыть панель эмодзи":@"Hide Emoji Panel") detail:(ru?@"Убирает панель эмодзи":@"Hide emoji bar in comments") key:@"hide_emoji_panel"];
                case 4: return [self switchCellTitle:(ru?@"Прозрачная навигация":@"Transparent Nav Bar") detail:(ru?@"Убирает заливку верхней панели":@"Remove nav bar fill") key:@"px_transparent_navbar"];
                case 5: {
                    // Цвет обводки историй
                    UITableViewCell *c = [self disclosureCellTitle:(ru?@"Цвет обводки историй":@"Story Border Color") detail:nil];
                    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
                    dot.layer.cornerRadius = 11;
                    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"px_story_border_color"];
                    UIColor *saved = colorData ? [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:colorData error:nil] : [UIColor systemPinkColor];
                    dot.backgroundColor = saved ?: [UIColor systemPinkColor];
                    c.accessoryView = dot;
                    return c;
                }
            }
        }
        case PXSectionStreak: {
            BOOL enabled = [BHIManager streakAutoRenewEnabled];
            NSString *time = [BHIManager streakScheduledTime];
            NSString *detail = enabled ? [NSString stringWithFormat:(ru?@"Вкл · %@":@"On · %@"), time] : (ru?@"Выключено":@"Disabled");
            return [self disclosureCellTitle:(ru?@"Настройки огонька":@"Streak Settings") detail:detail];
        }
        case PXSectionDeleted: {
            BOOL enabled = [BHIManager deletedMessagesEnabled];
            return [self disclosureCellTitle:(ru?@"Настройки удалённых":@"Deleted Message Settings") detail:(enabled?(ru?@"Включено":@"Enabled"):(ru?@"Выключено":@"Disabled"))];
        }
        case PXSectionFonts: {
            NSString *activePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"px_active_font_path"];
            NSString *activeName = activePath.length > 0 ? activePath.lastPathComponent.stringByDeletingPathExtension : (ru?@"Системный":@"System");
            return [self disclosureCellTitle:(ru?@"Менеджер шрифтов":@"Font Manager") detail:activeName];
        }
        case PXSectionFilter: {
            switch (indexPath.row) {
                case 0: return [self switchCellTitle:(ru?@"Включить фильтр":@"Enable Filter") detail:(ru?@"Скрывает видео по длительности":@"Hide videos by duration") key:@"px_duration_filter_enabled"];
                case 1: {
                    double minSec = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_min"] ?: 15;
                    UITableViewCell *c = [self disclosureCellTitle:(ru?@"Минимальная длина":@"Min Duration") detail:[self formatSeconds:minSec]];
                    return c;
                }
                case 2: {
                    double maxSec = [[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_max"] ?: 3600;
                    UITableViewCell *c = [self disclosureCellTitle:(ru?@"Максимальная длина":@"Max Duration") detail:[self formatSeconds:maxSec]];
                    return c;
                }
            }
        }
        case PXSectionBlacklist: {
            NSArray *words = [[NSUserDefaults standardUserDefaults] arrayForKey:@"px_word_blacklist"] ?: @[];
            NSString *detail = words.count > 0 ? [NSString stringWithFormat:(ru?@"%lu слов":@"%lu words"), (unsigned long)words.count] : (ru?@"Пусто":@"Empty");
            return [self disclosureCellTitle:(ru?@"Слова и хэштеги":@"Words & Hashtags") detail:detail];
        }
        case PXSectionLinks: {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Telegram Channel";
                cell.detailTextLabel.text = @"@pxtiktok";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage systemImageNamed:@"paperplane.fill"];
                cell.imageView.tintColor = [UIColor systemBlueColor];
            } else {
                cell.textLabel.text = ru ? @"Благодарность" : @"Credits";
                cell.detailTextLabel.text = @"@gruov";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage systemImageNamed:@"heart.fill"];
                cell.imageView.tintColor = [UIColor systemPinkColor];
            }
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (NSString *)formatSeconds:(double)seconds {
    int mins = (int)seconds / 60;
    int secs = (int)seconds % 60;
    return [NSString stringWithFormat:@"%d:%02d", mins, secs];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL ru = [self ru];

    switch (indexPath.section) {
        case PXSectionStreak:
            [self.navigationController pushViewController:[[PXStreakViewController alloc] init] animated:YES];
            break;
        case PXSectionDeleted:
            [self.navigationController pushViewController:[[PXDeletedMessagesViewController alloc] init] animated:YES];
            break;
        case PXSectionFonts:
            [self.navigationController pushViewController:[[PXFontManagerViewController alloc] init] animated:YES];
            break;
        case PXSectionBlacklist:
            [self.navigationController pushViewController:[[PXWordBlacklistViewController alloc] init] animated:YES];
            break;
        case PXSectionUI:
            if (indexPath.row == 5) {
                [self.navigationController pushViewController:[[PXStoryBorderViewController alloc] init] animated:YES];
            }
            break;
        case PXSectionFilter:
            if (indexPath.row == 1 || indexPath.row == 2) {
                [self showDurationPickerForMin:(indexPath.row == 1)];
            }
            break;
        case PXSectionLinks:
            if (indexPath.row == 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/pxtiktok"] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/gruov"] options:@{} completionHandler:nil];
            }
            break;
    }
}

- (void)showDurationPickerForMin:(BOOL)isMin {
    BOOL ru = [self ru];
    double current = isMin
        ? ([[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_min"] ?: 15)
        : ([[NSUserDefaults standardUserDefaults] doubleForKey:@"px_duration_max"] ?: 3600);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:(isMin?(ru?@"Мин. длительность":@"Min Duration"):(ru?@"Макс. длительность":@"Max Duration"))
        message:(ru?@"Введите значение в секундах (15–3600)":@"Enter value in seconds (15–3600)")
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) {
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.text = [NSString stringWithFormat:@"%.0f", current];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Готово":@"Done") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        double val = [alert.textFields.firstObject.text doubleValue];
        val = MAX(15, MIN(3600, val));
        NSString *key = isMin ? @"px_duration_min" : @"px_duration_max";
        [[NSUserDefaults standardUserDefaults] setDouble:val forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
