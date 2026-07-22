//
//  PXDeletedMessagesViewController.m
//  Настройки удалённых сообщений
//

#import "PXDeletedMessagesViewController.h"
#import "../BHIManager.h"

@interface PXDeletedMessagesViewController ()
@property (nonatomic, strong) UISlider *opacitySlider;
@property (nonatomic, strong) UILabel  *opacityLabel;
@end

@implementation PXDeletedMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL ru = [BHIManager isRussian];
    self.title = ru ? @"Удалённые сообщения" : @"Deleted Messages";
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [BHIManager isRussian];
    return section == 0 ? (ru?@"Включение":@"Toggle") : (ru?@"Внешний вид":@"Appearance");
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BOOL ru = [BHIManager isRussian];
    if (section == 1) return ru
        ? @"Удалённые сообщения отображаются с красной иконкой корзины. Перетащи корзину чтобы переместить. Тап на корзину — предпросмотр."
        : @"Deleted messages show a red trash icon. Drag the icon to reposition it. Tap to preview the message.";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [BHIManager isRussian];

    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = ru ? @"Показывать удалённые сообщения" : @"Show Deleted Messages";
        cell.detailTextLabel.text = ru ? @"Кэшировать и отображать удалённые сообщения" : @"Cache and display messages after deletion";
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = [BHIManager deletedMessagesEnabled];
        sw.onTintColor = [UIColor systemRedColor];
        sw.accessibilityLabel = @"px_deleted_messages_enabled";
        [sw addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        return cell;
    }

    if (indexPath.row == 0) {
        // Тумблер: такой же стиль как обычные
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = ru ? @"Такой же стиль" : @"Same Bubble Style";
        cell.detailTextLabel.text = ru ? @"Выглядит как обычное сообщение (только иконка корзины)" : @"Looks like a normal message (only trash icon differs)";
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = [BHIManager deletedMessageSameStyle];
        sw.accessibilityLabel = @"px_deleted_msg_same_style";
        [sw addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        return cell;

    } else if (indexPath.row == 1) {
        // Прозрачность — слайдер
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *title = [[UILabel alloc] init];
        title.text = ru ? @"Прозрачность" : @"Opacity";
        title.font = [UIFont systemFontOfSize:15];
        title.translatesAutoresizingMaskIntoConstraints = NO;

        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0.1f;
        slider.maximumValue = 1.0f;
        slider.value = [BHIManager deletedMessageOpacity];
        slider.tintColor = [UIColor systemRedColor];
        slider.translatesAutoresizingMaskIntoConstraints = NO;
        [slider addTarget:self action:@selector(opacityChanged:) forControlEvents:UIControlEventValueChanged];
        self.opacitySlider = slider;

        UILabel *pct = [[UILabel alloc] init];
        pct.text = [NSString stringWithFormat:@"%d%%", (int)(slider.value * 100)];
        pct.font = [UIFont monospacedDigitSystemFontOfSize:13 weight:UIFontWeightRegular];
        pct.textColor = [UIColor secondaryLabelColor];
        pct.translatesAutoresizingMaskIntoConstraints = NO;
        pct.textAlignment = NSTextAlignmentRight;
        pct.widthAnchor.constraintEqualToConstant(44).active = YES;
        self.opacityLabel = pct;

        [cell.contentView addSubview:title];
        [cell.contentView addSubview:slider];
        [cell.contentView addSubview:pct];

        [NSLayoutConstraint activateConstraints:@[
            [title.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
            [title.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
            [title.widthAnchor constraintEqualToConstant:110],
            [slider.leadingAnchor constraintEqualToAnchor:title.trailingAnchor constant:8],
            [slider.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor],
            [slider.trailingAnchor constraintEqualToAnchor:pct.leadingAnchor constant:-8],
            [pct.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
            [pct.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor]
        ]];
        return cell;

    } else {
        // Кнопка очистки кэша
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = ru ? @"Очистить кэш удалённых" : @"Clear Deleted Cache";
        cell.textLabel.textColor = [UIColor systemRedColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL ru = [BHIManager isRussian];
    if (indexPath.section == 1 && indexPath.row == 2) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Очистить кэш?":@"Clear cache?")
                                                                         message:(ru?@"Все сохранённые удалённые сообщения будут удалены.":@"All cached deleted messages will be removed.")
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Очистить":@"Clear") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *a) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"px_deleted_messages_cache"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)toggle:(UISwitch *)sw {
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:sw.accessibilityLabel];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)opacityChanged:(UISlider *)slider {
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"px_deleted_msg_opacity"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.opacityLabel.text = [NSString stringWithFormat:@"%d%%", (int)(slider.value * 100)];
}

@end
