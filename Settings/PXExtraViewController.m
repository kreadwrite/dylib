#import "PXExtraViewController.h"
#import "PXStatsViewController.h"
#import "PXStreakViewController.h"
#import "PXDeletedMessagesViewController.h"
#import "../BHIManager.h"

// ──────────────────────────────────────────────────────────────────────────────
// Вкладка PXTok — дополнительные функции
// ──────────────────────────────────────────────────────────────────────────────
@implementation PXExtraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PXTok";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 4; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"Контент и перевод" : @"Content & Translation";
        case 1: return ru ? @"Интерфейс" : @"Interface";
        case 2: return ru ? @"Автопродление огонька 🔥" : @"Streak Auto-Renew 🔥";
        case 3: return ru ? @"Удалённые сообщения" : @"Deleted Messages";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 5;
        case 1: return 6;
        case 2: return 1;
        case 3: return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Автосохранение избранного":@"Auto-backup Favorites") detail:(ru?@"Тихо сохраняет локальную копию при добавлении в избранное":@"Silently save a local copy when you favorite a video") key:@"auto_dw_favorites"];
            case 1: return [self switchCellTitle:(ru?@"Перевод описания":@"Translate Description") detail:(ru?@"Добавляет перевод в меню долгого нажатия":@"Add translate option to long-press menu") key:@"translate_description"];
            case 2: return [self switchCellTitle:(ru?@"Перевод комментариев":@"Translate Comments") detail:(ru?@"Кнопка перевода под каждым комментарием":@"Translate button under each comment") key:@"translate_comment"];
            case 3: return [self switchCellTitle:(ru?@"Копировать комментарий без ника":@"Copy Comment w/o Username") detail:(ru?@"Долгое нажатие копирует только текст":@"Long-press copies only the comment text") key:@"copy_comment_no_username"];
            case 4: return [self switchCellTitle:(ru?@"Авто-раскрытие ответов":@"Auto-expand Replies") detail:(ru?@"Автоматически разворачивать ветки комментариев":@"Auto-expand comment reply threads") key:@"auto_expand_replies"];
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Скрыть кнопку «+»":@"Hide '+' Button") detail:(ru?@"Скрыть кнопку создания на нижней панели":@"Hide the create button on tab bar") key:@"hide_plus_button"];
            case 1: return [self switchCellTitle:(ru?@"Скрыть значки уведомлений":@"Hide Notification Badges") detail:(ru?@"Убирает красные точки на вкладках":@"Remove red dots from tabs") key:@"hide_notification_badges"];
            case 2: return [self switchCellTitle:(ru?@"Отключить подсказки":@"Disable Tooltips") detail:(ru?@"Скрыть всплывающие подсказки в комментариях":@"Hide tooltip popups in comments") key:@"disable_comment_tooltips"];
            case 3: return [self switchCellTitle:(ru?@"OLED-клавиатура":@"OLED Keyboard") detail:(ru?@"Принудительно тёмная клавиатура":@"Force dark keyboard throughout app") key:@"oled_keyboard"];
            case 4: return [self switchCellTitle:(ru?@"Скрыть панель эмодзи":@"Hide Emoji Panel") detail:(ru?@"Убрать панель эмодзи в поле комментария":@"Hide emoji bar in comment field") key:@"hide_emoji_panel"];
            case 5: return [self switchCellTitle:(ru?@"Прозрачная навигация":@"Transparent Nav Bar") detail:(ru?@"Убирает заливку и тень с верхней панели":@"Remove fill and shadow from top bar") key:@"px_transparent_navbar"];
        }
    } else if (indexPath.section == 2) {
        BOOL enabled = [BHIManager streakAutoRenewEnabled];
        NSString *time = [BHIManager streakScheduledTime];
        NSString *detail = enabled ? [NSString stringWithFormat:(ru?@"Включено, время: %@":@"Enabled at %@"), time] : (ru?@"Выключено":@"Disabled");
        UITableViewCell *c = [self disclosureCellTitle:(ru?@"Настройки огонька":@"Streak Settings") detail:detail];
        return c;
    } else if (indexPath.section == 3) {
        BOOL enabled = [BHIManager deletedMessagesEnabled];
        NSString *detail = enabled ? (ru?@"Включено":@"Enabled") : (ru?@"Выключено":@"Disabled");
        UITableViewCell *c = [self disclosureCellTitle:(ru?@"Настройки удалённых сообщений":@"Deleted Messages Settings") detail:detail];
        return c;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        PXStreakViewController *vc = [[PXStreakViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        PXDeletedMessagesViewController *vc = [[PXDeletedMessagesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
