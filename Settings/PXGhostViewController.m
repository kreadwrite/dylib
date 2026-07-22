#import "PXGhostViewController.h"

// ──────────────────────────────────────────────────────────────────────────────
// Вкладка «Режим призрака» — всё про приватность/невидимость
// ──────────────────────────────────────────────────────────────────────────────
@implementation PXGhostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Режим призрака" : @"Ghost Mode";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"Просмотр контента" : @"Content Viewing";
        case 1: return ru ? @"Личные сообщения" : @"Direct Messages";
        case 2: return ru ? @"Приватность системы" : @"System Privacy";
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BOOL ru = [self ru];
    if (section == 1) return ru ? @"«Без прочитано» работает через хук TIMConversationReadManagerImpl, подтверждён в бинаре." : @"'No read receipt' hooks TIMConversationReadManagerImpl, confirmed in binary.";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 3;
        case 1: return 4;
        case 2: return 3;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Не отмечать просмотр историй":@"No Story Mark") detail:(ru?@"История просмотрена, но ты не виден в списке":@"View stories without appearing in viewers list") key:@"px_ghost_no_story_mark"];
            case 1: return [self switchCellTitle:(ru?@"Не отмечать просмотр видео":@"No Video Mark") detail:(ru?@"Видео засчитывается, но без фиксации твоего просмотра":@"Watch videos without marking as seen") key:@"px_ghost_no_video_mark"];
            case 2: return [self switchCellTitle:(ru?@"Скрытый просмотр профилей":@"Stealth Profile View") detail:(ru?@"Просматривать профили без отображения в истории посещений":@"Visit profiles without appearing in their visitor history") key:@"px_ghost_stealth_profile"];
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Без «прочитано» в ЛС":@"No Read Receipt") detail:(ru?@"Не отправлять статус «просмотрено» собеседнику":@"Don't send 'seen' status to sender") key:@"disable_read_receipt"];
            case 1: return [self switchCellTitle:(ru?@"Скрыть онлайн в ЛС":@"Hide Online Status") detail:(ru?@"Не показывать статус «онлайн» в чатах":@"Hide your online status in chats") key:@"px_ghost_hide_online"];
            case 2: return [self switchCellTitle:(ru?@"Скрыть «печатает…»":@"Hide Typing") detail:(ru?@"Не отправлять индикатор набора текста":@"Don't send typing indicator") key:@"px_ghost_hide_typing"];
            case 3: return [self switchCellTitle:(ru?@"Режим удалённых сообщений":@"Deleted Messages") detail:(ru?@"Сохранять и показывать удалённые сообщения":@"Cache and show deleted messages") key:@"px_deleted_messages_enabled"];
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Экран приватности":@"Privacy Screen") detail:(ru?@"Размывает TikTok в переключателе приложений":@"Blur TikTok in the app switcher") key:@"px_ghost_privacy_screen"];
            case 1: return [self switchCellTitle:(ru?@"Очистка буфера обмена":@"Clipboard Auto-Clear") detail:(ru?@"Стирает скопированный текст через 30 сек":@"Clears copied text after 30 seconds") key:@"px_ghost_clipboard_clear"];
            case 2: return [self switchCellTitle:(ru?@"Скрыть от Spotlight":@"Hide from Spotlight") detail:(ru?@"Запрещает TikTok индексироваться в поиске iOS":@"Prevent TikTok from indexing in iOS Search") key:@"px_ghost_hide_spotlight"];
        }
    }
    return [UITableViewCell new];
}

@end
