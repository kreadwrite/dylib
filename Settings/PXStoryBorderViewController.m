//
//  PXStoryBorderViewController.m
//  Выбор цвета обводки историй
//
#import "PXStoryBorderViewController.h"
#import "../BHIManager.h"

@interface PXStoryBorderViewController () <UIColorPickerViewControllerDelegate>
@property (nonatomic, strong) UIButton *colorPreviewButton;
@property (nonatomic, strong) UISwitch *enableSwitch;
@end

@implementation PXStoryBorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL ru = [BHIManager isRussian];
    self.title = ru ? @"Обводка историй" : @"Story Border";
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];

    // Стек
    UIStackView *stack = [[UIStackView alloc] init];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 20;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stack];

    // Тумблер
    UIView *switchRow = [[UIView alloc] init];
    switchRow.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
    switchRow.layer.cornerRadius = 12;
    switchRow.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[ [[switchRow heightAnchor] constraintEqualToConstant:52] ]];
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = ru ? @"Кастомная обводка историй" : @"Custom Story Border Color";
    lbl.font = [UIFont systemFontOfSize:16];
    lbl.translatesAutoresizingMaskIntoConstraints = NO;
    self.enableSwitch = [[UISwitch alloc] init];
    self.enableSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"px_story_border_enabled"];
    self.enableSwitch.onTintColor = [UIColor systemPinkColor];
    self.enableSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.enableSwitch addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
    [switchRow addSubview:lbl];
    [switchRow addSubview:self.enableSwitch];
    [NSLayoutConstraint activateConstraints:@[
        [lbl.leadingAnchor constraintEqualToAnchor:switchRow.leadingAnchor constant:16],
        [lbl.centerYAnchor constraintEqualToAnchor:switchRow.centerYAnchor],
        [self.enableSwitch.trailingAnchor constraintEqualToAnchor:switchRow.trailingAnchor constant:-16],
        [self.enableSwitch.centerYAnchor constraintEqualToAnchor:switchRow.centerYAnchor],
    ]];
    [stack addArrangedSubview:switchRow];

    // Превью цвета
    self.colorPreviewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.colorPreviewButton setTitle:(ru ? @"Выбрать цвет обводки" : @"Pick Border Color") forState:UIControlStateNormal];
    self.colorPreviewButton.backgroundColor = [self savedColor];
    self.colorPreviewButton.layer.cornerRadius = 24;
    self.colorPreviewButton.layer.borderWidth = 2;
    self.colorPreviewButton.layer.borderColor = [UIColor separatorColor].CGColor;
    [NSLayoutConstraint activateConstraints:@[ [[self.colorPreviewButton heightAnchor] constraintEqualToConstant:48] ]];
    [self.colorPreviewButton addTarget:self action:@selector(pickColor) forControlEvents:UIControlEventTouchUpInside];
    [stack addArrangedSubview:self.colorPreviewButton];

    // Предустановленные цвета
    NSArray *presets = @[
        [UIColor systemPinkColor], [UIColor systemPurpleColor], [UIColor systemBlueColor],
        [UIColor systemGreenColor], [UIColor systemOrangeColor], [UIColor systemRedColor],
        [UIColor systemYellowColor], [UIColor systemCyanColor],
    ];
    UIStackView *colorRow = [[UIStackView alloc] init];
    colorRow.axis = UILayoutConstraintAxisHorizontal;
    colorRow.distribution = UIStackViewDistributionFillEqually;
    colorRow.spacing = 8;
    for (UIColor *c in presets) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = c;
        btn.layer.cornerRadius = 20;
        [NSLayoutConstraint activateConstraints:@[ [[btn heightAnchor] constraintEqualToConstant:40] ]];
        btn.tag = [presets indexOfObject:c];
        [btn addTarget:self action:@selector(presetTapped:) forControlEvents:UIControlEventTouchUpInside];
        [colorRow addArrangedSubview:btn];
    }
    [stack addArrangedSubview:colorRow];

    [NSLayoutConstraint activateConstraints:@[
        [stack.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:24],
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
    ]];
}

- (UIColor *)savedColor {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"px_story_border_color"];
    if (data) {
        return [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:nil] ?: [UIColor systemPinkColor];
    }
    return [UIColor systemPinkColor];
}

- (void)saveColor:(UIColor *)color {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:color requiringSecureCoding:YES error:nil];
    if (data) [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"px_story_border_color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.colorPreviewButton.backgroundColor = color;
}

- (void)toggleChanged:(UISwitch *)sw {
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"px_story_border_enabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pickColor {
    if (@available(iOS 14.0, *)) {
        UIColorPickerViewController *cp = [[UIColorPickerViewController alloc] init];
        cp.delegate = self;
        cp.selectedColor = [self savedColor];
        cp.supportsAlpha = NO;
        [self presentViewController:cp animated:YES completion:nil];
    }
}

- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController API_AVAILABLE(ios(14.0)) {
    [self saveColor:viewController.selectedColor];
}

- (void)presetTapped:(UIButton *)btn {
    NSArray *presets = @[
        [UIColor systemPinkColor], [UIColor systemPurpleColor], [UIColor systemBlueColor],
        [UIColor systemGreenColor], [UIColor systemOrangeColor], [UIColor systemRedColor],
        [UIColor systemYellowColor], [UIColor systemCyanColor],
    ];
    if (btn.tag < presets.count) [self saveColor:presets[btn.tag]];
}

@end
