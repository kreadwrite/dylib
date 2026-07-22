//
//  PXWordBlacklistViewController.m  
//  Чёрный список слов и хэштегов
//
#import "PXWordBlacklistViewController.h"
#import "../BHIManager.h"

@interface PXWordBlacklistViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *words;
@end

@implementation PXWordBlacklistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL ru = [BHIManager isRussian];
    self.title = ru ? @"Чёрный список" : @"Word Blacklist";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addWord)];
    self.navigationItem.rightBarButtonItem = addBtn;

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];

    [self loadWords];
}

- (void)loadWords {
    self.words = [([[NSUserDefaults standardUserDefaults] arrayForKey:@"px_word_blacklist"] ?: @[]) mutableCopy];
    [self.tableView reloadData];
}

- (void)addWord {
    BOOL ru = [BHIManager isRussian];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:(ru ? @"Добавить слово/хэштег" : @"Add Word/Hashtag")
        message:(ru ? @"Видео с этим словом в описании будут скрыты" : @"Videos containing this word in description will be hidden")
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *tf) {
        tf.placeholder = ru ? @"Например: реклама или #спонсор" : @"e.g. ad or #sponsored";
        tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:(ru ? @"Добавить" : @"Add") style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        NSString *word = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].lowercaseString;
        if (word.length > 0 && ![self.words containsObject:word]) {
            [self.words addObject:word];
            [[NSUserDefaults standardUserDefaults] setObject:self.words forKey:@"px_word_blacklist"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:(ru ? @"Отмена" : @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return self.words.count; }

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [BHIManager isRussian] ? @"Слова и хэштеги" : @"Words & Hashtags";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [BHIManager isRussian]
        ? @"Видео, в описании которых встречается любое из этих слов, будут автоматически скрыты."
        : @"Videos whose description contains any of these words will be automatically hidden.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.words[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath { return YES; }
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)style forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (style == UITableViewCellEditingStyleDelete) {
        [self.words removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:self.words forKey:@"px_word_blacklist"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
