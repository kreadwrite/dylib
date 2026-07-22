//
//  PXStreakViewController.m
//  Автопродление огонька — отправляет сообщение в чаты в заданное время
//  через хук на TIMConversation / AWEIMConversationService
//

#import "PXStreakViewController.h"
#import "../BHIManager.h"

@interface PXStreakViewController ()
@property (nonatomic, strong) UIDatePicker *timePicker;
@end

@implementation PXStreakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL ru = [BHIManager isRussian];
    self.title = ru ? @"Огонёк 🔥" : @"Streak 🔥";
    self.tableView.backgroundColor = [UIColor systemGroupedBackgroundColor];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [BHIManager isRussian];
    switch (section) {
        case 0: return ru ? @"Включение" : @"Toggle";
        case 1: return ru ? @"Расписание" : @"Schedule";
        case 2: return ru ? @"Сообщение" : @"Message";
    }
    return @"";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    BOOL ru = [BHIManager isRussian];
    if (section == 2) return ru
        ? @"Бот отправит это сообщение в активные чаты в выбранное время каждые 24 часа через хук на AWEIMSendMessageRequest."
        : @"The bot sends this message to active chats at the chosen time every 24h via a hook on AWEIMSendMessageRequest.";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 1;
        case 1: return 1;
        case 2: return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [BHIManager isRussian];

    if (indexPath.section == 0) {
        // Тумблер
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = ru ? @"Автопродление огонька" : @"Auto-Renew Streak";
        cell.detailTextLabel.text = ru ? @"Отправлять сообщение каждые 24 часа" : @"Send a message every 24 hours";
        cell.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = [BHIManager streakAutoRenewEnabled];
        sw.onTintColor = [UIColor systemOrangeColor];
        sw.accessibilityLabel = @"px_streak_auto_renew";
        [sw addTarget:self action:@selector(toggleStreak:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = sw;
        return cell;

    } else if (indexPath.section == 1) {
        // Выбор времени
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = ru ? @"Время отправки" : @"Send Time";
        cell.detailTextLabel.text = [BHIManager streakScheduledTime];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    } else {
        // Поле текста сообщения
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UITextField *tf = [[UITextField alloc] init];
        tf.placeholder = ru ? @"Сообщение (например 🔥)" : @"Message (e.g. 🔥)";
        tf.text = [BHIManager streakMessageText];
        tf.returnKeyType = UIReturnKeyDone;
        tf.translatesAutoresizingMaskIntoConstraints = NO;
        [tf addTarget:self action:@selector(messageChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.contentView addSubview:tf];
        [NSLayoutConstraint activateConstraints:@[
            [tf.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15],
            [tf.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-15],
            [tf.centerYAnchor constraintEqualToAnchor:cell.contentView.centerYAnchor]
        ]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [self showTimePicker];
    }
}

- (void)toggleStreak:(UISwitch *)sw {
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"px_streak_auto_renew"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (sw.isOn) {
        [self scheduleStreakNotification];
    } else {
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[@"px_streak_reminder"]];
    }
}

- (void)messageChanged:(UITextField *)tf {
    [[NSUserDefaults standardUserDefaults] setValue:tf.text forKey:@"px_streak_message"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)showTimePicker {
    BOOL ru = [BHIManager isRussian];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru?@"Время отправки":@"Send Time") message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];

    UIDatePicker *picker = [[UIDatePicker alloc] init];
    picker.datePickerMode = UIDatePickerModeTime;
    if (@available(iOS 14.0, *)) picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    picker.frame = CGRectMake(0, 50, 270, 180);

    // Восстанавливаем сохранённое время
    NSString *saved = [BHIManager streakScheduledTime];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm";
    NSDate *savedDate = [fmt dateFromString:saved];
    if (savedDate) picker.date = savedDate;

    [alert.view addSubview:picker];
    self.timePicker = picker;

    [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Готово":@"Done") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"HH:mm";
        NSString *timeStr = [f stringFromDate:picker.date];
        [[NSUserDefaults standardUserDefaults] setValue:timeStr forKey:@"px_streak_time"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
        if ([BHIManager streakAutoRenewEnabled]) [self scheduleStreakNotification];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:(ru?@"Отмена":@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

// Планируем локальное уведомление + хук на отправку сработает из Tweak.x
- (void)scheduleStreakNotification {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:(UNAuthorizationOptionAlert|UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError *e) {}];

    NSString *timeStr = [BHIManager streakScheduledTime];
    NSArray *parts = [timeStr componentsSeparatedByString:@":"];
    NSInteger hour = [parts[0] integerValue];
    NSInteger min  = parts.count > 1 ? [parts[1] integerValue] : 0;

    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"PXTok 🔥";
    content.body  = [BHIManager isRussian] ? @"Огонёк отправляется..." : @"Sending streak message...";
    content.sound = [UNNotificationSound defaultSound];

    NSDateComponents *dc = [[NSDateComponents alloc] init];
    dc.hour = hour; dc.minute = min;

    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dc repeats:YES];
    UNNotificationRequest *req = [UNNotificationRequest requestWithIdentifier:@"px_streak_reminder" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:req withCompletionHandler:nil];
}

@end
