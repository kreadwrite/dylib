//
//  PXFontManagerViewController.m
//  PXTok — менеджер кастомных шрифтов (.ttf / .otf)
//
//  Как работает: UIFont.familyNames перехватывается в Tweak.x
//  через swizzle, если включён кастомный шрифт — подменяем системный
//  шрифт TikTok на выбранный через CTFontDescriptor.
//

#import "PXFontManagerViewController.h"
#import "../BHIManager.h"

@interface PXFontManagerViewController () <UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *fonts; // [{name, path, isActive}]
@property (nonatomic, strong) UILabel *previewLabel;
@end

@implementation PXFontManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL ru = [BHIManager isRussian];
    self.title = ru ? @"Шрифты" : @"Fonts";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    // Кнопка добавить шрифт
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(importFont)];
    self.navigationItem.rightBarButtonItem = addBtn;

    // Превью-лейбл
    self.previewLabel = [[UILabel alloc] init];
    self.previewLabel.text = ru ? @"Предпросмотр шрифта — пример текста" : @"Font Preview — Sample Text AaBbCcDd";
    self.previewLabel.textAlignment = NSTextAlignmentCenter;
    self.previewLabel.numberOfLines = 3;
    self.previewLabel.font = [UIFont systemFontOfSize:18];
    self.previewLabel.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    self.previewLabel.layer.cornerRadius = 12;
    self.previewLabel.clipsToBounds = YES;
    self.previewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.previewLabel];

    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableView];

    [NSLayoutConstraint activateConstraints:@[
        [self.previewLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:12],
        [self.previewLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.previewLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.previewLabel.heightAnchor constraintEqualToConstant:80],
        [self.tableView.topAnchor constraintEqualToAnchor:self.previewLabel.bottomAnchor constant:8],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];

    [self loadFonts];
    [self updatePreview];
}

- (void)loadFonts {
    NSArray *saved = [[NSUserDefaults standardUserDefaults] arrayForKey:@"px_custom_fonts"] ?: @[];
    self.fonts = [NSMutableArray arrayWithArray:saved];
    // Добавляем системный шрифт как первую опцию
    BOOL ru = [BHIManager isRussian];
    NSString *activePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"px_active_font_path"];
    NSMutableArray *all = [NSMutableArray array];
    [all addObject:@{@"name": (ru ? @"Системный (по умолчанию)" : @"System Font (Default)"), @"path": @"", @"system": @YES}];
    for (NSDictionary *f in self.fonts) [all addObject:f];
    self.fonts = all;
    [self.tableView reloadData];
}

- (void)updatePreview {
    NSString *activePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"px_active_font_path"];
    if (activePath.length > 0) {
        // Регистрируем и применяем
        NSURL *url = [NSURL fileURLWithPath:activePath];
        NSArray *descriptors = (__bridge_transfer NSArray *)CTFontManagerCopyRegisteredFontDescriptors(kCTFontManagerScopeProcess, true);
        // Пробуем загрузить
        CFErrorRef error = NULL;
        CTFontManagerRegisterFontsForURL((__bridge CFURLRef)url, kCTFontManagerScopeProcess, &error);
        // Получаем имя семейства
        CFURLRef cfURL = (__bridge CFURLRef)url;
        NSArray *descs = (__bridge_transfer NSArray *)CTFontManagerCreateFontDescriptorsFromURL(cfURL);
        if (descs.count > 0) {
            CTFontDescriptorRef desc = (__bridge CTFontDescriptorRef)descs[0];
            NSString *family = (__bridge_transfer NSString *)CTFontDescriptorCopyAttribute(desc, kCTFontFamilyNameAttribute);
            if (family) {
                UIFont *font = [UIFont fontWithName:family size:18];
                if (font) self.previewLabel.font = font;
            }
        }
    } else {
        self.previewLabel.font = [UIFont systemFontOfSize:18];
    }
}

- (void)importFont {
    NSArray *types = @[@"public.truetype-ttf-font", @"public.opentype-font", @"org.gnu.gnu-type-1-font", @"com.adobe.postscript-font", @"public.font"];
    UIDocumentPickerViewController *picker;
    if (@available(iOS 14.0, *)) {
        NSMutableArray *utTypes = [NSMutableArray array];
        for (NSString *t in types) {
            UTType *type = [UTType typeWithIdentifier:t];
            if (type) [utTypes addObject:type];
        }
        picker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:utTypes];
    } else {
        picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeImport];
    }
    picker.delegate = self;
    picker.allowsMultipleSelection = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    NSURL *url = urls.firstObject;
    if (!url) return;

    // Копируем в Documents
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fontsDir = [docsPath stringByAppendingPathComponent:@"PXFonts"];
    [[NSFileManager defaultManager] createDirectoryAtPath:fontsDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *destPath = [fontsDir stringByAppendingPathComponent:url.lastPathComponent];
    NSError *err = nil;
    [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:destPath] error:&err];

    if (!err) {
        NSMutableArray *saved = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"px_custom_fonts"] mutableCopy] ?: [NSMutableArray array];
        [saved addObject:@{@"name": url.lastPathComponent.stringByDeletingPathExtension, @"path": destPath}];
        [[NSUserDefaults standardUserDefaults] setObject:saved forKey:@"px_custom_fonts"];
        [self loadFonts];
    }
}

// ─── TableView ───

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fonts.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [BHIManager isRussian] ? @"Установленные шрифты" : @"Installed Fonts";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FontCell"] ?: [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FontCell"];
    NSDictionary *font = self.fonts[indexPath.row];
    NSString *activePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"px_active_font_path"] ?: @"";
    NSString *path = font[@"path"] ?: @"";
    cell.textLabel.text = font[@"name"];
    cell.detailTextLabel.text = [font[@"system"] boolValue] ? @"" : path.lastPathComponent;
    cell.accessoryType = [path isEqualToString:activePath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor = [UIColor systemPinkColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL ru = [BHIManager isRussian];
    NSDictionary *font = self.fonts[indexPath.row];
    NSString *path = font[@"path"] ?: @"";

    [[NSUserDefaults standardUserDefaults] setValue:path forKey:@"px_active_font_path"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.tableView reloadData];
    [self updatePreview];

    // Просим перезапустить
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"PXTok"
        message:(ru ? @"Шрифт применён. Перезапустите TikTok для применения." : @"Font applied. Restart TikTok to apply.")
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Нельзя удалить системный шрифт
    return ![self.fonts[indexPath.row][@"system"] boolValue];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)style forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (style == UITableViewCellEditingStyleDelete) {
        NSDictionary *font = self.fonts[indexPath.row];
        NSString *path = font[@"path"];

        // Если удаляем активный — сбрасываем на системный
        NSString *activePath = [[NSUserDefaults standardUserDefaults] stringForKey:@"px_active_font_path"] ?: @"";
        if ([path isEqualToString:activePath]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"px_active_font_path"];
        }

        // Удаляем файл
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

        // Удаляем из NSUserDefaults
        NSMutableArray *saved = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"px_custom_fonts"] mutableCopy] ?: [NSMutableArray array];
        [saved removeObjectAtIndex:indexPath.row - 1]; // -1 т.к. системный первый
        [[NSUserDefaults standardUserDefaults] setObject:saved forKey:@"px_custom_fonts"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self loadFonts];
        [self updatePreview];
    }
}

@end
