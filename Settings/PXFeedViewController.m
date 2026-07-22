#import "PXFeedViewController.h"
#import "PlaybackSpeed.h"
#import "LiveActions.h"

@implementation PXFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Лента" : @"Feed";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"Видео" : @"Video";
        case 1: return ru ? @"Скорость воспроизведения" : @"Playback Speed";
        case 2: return ru ? @"Кнопка Live" : @"Live Button";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 11;
        case 1: return 2;
        case 2: return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:  return [self switchCellTitle:(ru?@"Скрыть рекламу":@"Hide Ads") detail:(ru?@"Убирает рекламные вставки в ленте":@"Remove ads from feed") key:@"hide_ads"];
            case 1:  return [self switchCellTitle:(ru?@"Кнопка скачивания":@"Download Button") detail:(ru?@"Добавляет кнопку скачивания видео":@"Add download button to videos") key:@"download_button"];
            case 2:  return [self switchCellTitle:(ru?@"Меню «Поделиться»":@"Share Sheet") detail:(ru?@"Восстанавливает системное меню поделиться":@"Restore system share sheet") key:@"share_sheet"];
            case 3:  return [self switchCellTitle:(ru?@"Убрать водяной знак":@"Remove Watermark") detail:(ru?@"Убирает водяной знак со скачанных видео":@"Remove TikTok watermark from downloads") key:@"remove_watermark"];
            case 4:  return [self switchCellTitle:(ru?@"Кнопка скрытия UI":@"Hide UI Button") detail:(ru?@"Кнопка для чистого просмотра видео":@"Toggle interface visibility") key:@"remove_elements_button"];
            case 5:  return [self switchCellTitle:(ru?@"Автовоспроизведение":@"Auto Play") detail:(ru?@"Автоматически включать следующее видео":@"Auto play next video") key:@"auto_play"];
            case 6:  return [self switchCellTitle:(ru?@"Полоса прогресса":@"Progress Bar") detail:(ru?@"Показывать прогресс воспроизведения":@"Show playback progress bar") key:@"show_porgress_bar"];
            case 7:  return [self switchCellTitle:(ru?@"Прозрачные комментарии":@"Transparent Comments") detail:(ru?@"Полупрозрачная панель комментариев":@"Semi-transparent comment panel") key:@"transparent_commnet"];
            case 8:  return [self switchCellTitle:(ru?@"Отключить предупреждения":@"Disable Warnings") detail:(ru?@"Убирает предупреждающие плашки TikTok":@"Remove TikTok warning banners") key:@"disable_warnings"];
            case 9:  return [self switchCellTitle:(ru?@"Отключить прямые эфиры":@"Disable Live") detail:(ru?@"Скрывает прямые эфиры из ленты":@"Hide live streams from feed") key:@"disable_live"];
            case 10: return [self switchCellTitle:(ru?@"Пропускать рекомендации":@"Skip Recommendations") detail:(ru?@"Автопролистывать карточки «подпишитесь»":@"Auto-skip follow recommendation cards") key:@"skip_recommnedations"];
        }
    } else if (indexPath.section == 1) {
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Включить":@"Enable") detail:(ru?@"Сохранять скорость между видео":@"Persist playback speed") key:@"playback_en"];
            case 1: {
                NSString *spd = [d valueForKey:@"playback_speed"] ?: @"1.0";
                UITableViewCell *c = [self disclosureCellTitle:(ru?@"Скорость":@"Speed") detail:[NSString stringWithFormat:@"%@×", spd]];
                return c;
            }
        }
    } else if (indexPath.section == 2) {
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Включить":@"Enable") detail:(ru?@"Переопределить действие кнопки Live":@"Override the Live button action") key:@"en_livefunc"];
            case 1: {
                NSArray *actions = ru ? @[@"По умолчанию", @"Настройки PXTok", @"Скорость видео"] : @[@"Default", @"PXTok Settings", @"Playback Speed"];
                NSString *sel = [d valueForKey:@"live_action"];
                NSString *cur = sel ? actions[[sel integerValue]] : actions[0];
                return [self disclosureCellTitle:(ru?@"Действие":@"Action") detail:cur];
            }
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        PlaybackSpeed *vc = [[PlaybackSpeed alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2 && indexPath.row == 1) {
        LiveActions *vc = [[LiveActions alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
