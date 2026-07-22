#import "PXProfileViewController.h"

@implementation PXProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self ru] ? @"Профиль" : @"Profile";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 2; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    BOOL ru = [self ru];
    switch (section) {
        case 0: return ru ? @"Профиль пользователя" : @"User Profile";
        case 1: return ru ? @"Подтверждения действий" : @"Action Confirmations";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL ru = [self ru];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Сохранить аватарку":@"Save Avatar") detail:(ru?@"Кнопка сохранения фото профиля":@"Button to save profile photo") key:@"save_profile"];
            case 1: return [self switchCellTitle:(ru?@"Копировать профиль":@"Copy Profile") detail:(ru?@"Копирует ник, био и статистику":@"Copy username, bio and stats") key:@"copy_profile_information"];
            case 2: return [self switchCellTitle:(ru?@"Точные лайки":@"Like Count") detail:(ru?@"Показывает точное число лайков":@"Show exact like count on videos") key:@"video_like_count"];
            case 3: return [self switchCellTitle:(ru?@"Дата загрузки":@"Upload Date") detail:(ru?@"Показывает дату публикации видео":@"Show video upload date") key:@"video_upload_date"];
        }
    } else {
        switch (indexPath.row) {
            case 0: return [self switchCellTitle:(ru?@"Подтверждение лайка":@"Like Confirmation") detail:(ru?@"Подтвердить перед лайком видео":@"Confirm before liking a video") key:@"like_confirm"];
            case 1: return [self switchCellTitle:(ru?@"Подтверждение лайка комментария":@"Like Comment") detail:(ru?@"Подтвердить перед лайком комментария":@"Confirm before liking a comment") key:@"like_comment_confirm"];
            case 2: return [self switchCellTitle:(ru?@"Подтверждение дизлайка":@"Dislike Comment") detail:(ru?@"Подтвердить перед дизлайком":@"Confirm before disliking") key:@"dislike_comment_confirm"];
            case 3: return [self switchCellTitle:(ru?@"Подтверждение подписки":@"Follow Confirmation") detail:(ru?@"Подтвердить перед подпиской":@"Confirm before following") key:@"follow_confirm"];
        }
    }
    return [UITableViewCell new];
}

@end
