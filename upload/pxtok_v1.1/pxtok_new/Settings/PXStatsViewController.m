//
//  PXStatsViewController.m
//  PXTok
//
//  A custom-designed usage stats screen — deliberately NOT styled like TikTok's
//  own UI, so it's visually obvious this is a PXTok screen, not a native one.
//

#import "PXStatsViewController.h"

@interface PXStatsViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation PXStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PXTok Stats";
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];

    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 14;
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.stackView];

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],

        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:20],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor constant:16],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor constant:-16],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-20],
        [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor constant:-32],
    ]];

    [self reloadStats];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadStats];
}

- (void)reloadStats {
    for (UIView *v in self.stackView.arrangedSubviews) {
        [v removeFromSuperview];
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger totalVideos = [defaults integerForKey:@"px_total_videos"];
    NSInteger todayVideos = [defaults integerForKey:@"px_today_videos"];
    double totalSeconds = [defaults doubleForKey:@"px_total_seconds"];
    double todaySeconds = [defaults doubleForKey:@"px_today_seconds"];
    NSInteger totalSessions = [defaults integerForKey:@"px_total_sessions"];

    [self.stackView addArrangedSubview:[self headerCard]];
    [self.stackView addArrangedSubview:[self statCardWithTitle:@"Videos watched today" value:[NSString stringWithFormat:@"%ld", (long)todayVideos] accent:[UIColor systemPinkColor]]];
    [self.stackView addArrangedSubview:[self statCardWithTitle:@"Time in app today" value:[self formatSeconds:todaySeconds] accent:[UIColor systemPurpleColor]]];
    [self.stackView addArrangedSubview:[self statCardWithTitle:@"Total videos watched" value:[NSString stringWithFormat:@"%ld", (long)totalVideos] accent:[UIColor systemIndigoColor]]];
    [self.stackView addArrangedSubview:[self statCardWithTitle:@"Total time in app" value:[self formatSeconds:totalSeconds] accent:[UIColor systemTealColor]]];
    [self.stackView addArrangedSubview:[self statCardWithTitle:@"Sessions opened" value:[NSString stringWithFormat:@"%ld", (long)totalSessions] accent:[UIColor systemOrangeColor]]];
    [self.stackView addArrangedSubview:[self resetButton]];
}

- (UIView *)headerCard {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] init];
    title.text = @"Your usage, tracked locally";
    title.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    title.textColor = [UIColor secondaryLabelColor];
    title.numberOfLines = 0;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:title];

    [NSLayoutConstraint activateConstraints:@[
        [title.topAnchor constraintEqualToAnchor:card.topAnchor],
        [title.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [title.trailingAnchor constraintEqualToAnchor:card.trailingAnchor],
        [title.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],
    ]];
    return card;
}

- (UIView *)statCardWithTitle:(NSString *)titleText value:(NSString *)valueText accent:(UIColor *)accent {
    UIView *card = [[UIView alloc] init];
    card.backgroundColor = [UIColor secondarySystemBackgroundColor];
    card.layer.cornerRadius = 16;
    card.layer.masksToBounds = YES;
    card.translatesAutoresizingMaskIntoConstraints = NO;
    [card.heightAnchor constraintEqualToConstant:76].active = YES;

    UIView *accentBar = [[UIView alloc] init];
    accentBar.backgroundColor = accent;
    accentBar.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:accentBar];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleText;
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    titleLabel.textColor = [UIColor secondaryLabelColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:titleLabel];

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = valueText;
    valueLabel.font = [UIFont monospacedDigitSystemFontOfSize:26 weight:UIFontWeightBold];
    valueLabel.textColor = [UIColor labelColor];
    valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [card addSubview:valueLabel];

    [NSLayoutConstraint activateConstraints:@[
        [accentBar.leadingAnchor constraintEqualToAnchor:card.leadingAnchor],
        [accentBar.topAnchor constraintEqualToAnchor:card.topAnchor],
        [accentBar.bottomAnchor constraintEqualToAnchor:card.bottomAnchor],
        [accentBar.widthAnchor constraintEqualToConstant:5],

        [titleLabel.leadingAnchor constraintEqualToAnchor:accentBar.trailingAnchor constant:16],
        [titleLabel.topAnchor constraintEqualToAnchor:card.topAnchor constant:14],
        [titleLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],

        [valueLabel.leadingAnchor constraintEqualToAnchor:accentBar.trailingAnchor constant:16],
        [valueLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:4],
        [valueLabel.trailingAnchor constraintEqualToAnchor:card.trailingAnchor constant:-16],
    ]];
    return card;
}

- (UIView *)resetButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Reset stats" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    [button setTitleColor:[UIColor systemRedColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resetStatsTapped) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:44].active = YES;
    return button;
}

- (void)resetStatsTapped {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset stats?"
                                                                     message:@"This clears all locally tracked usage numbers."
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        for (NSString *key in @[@"px_total_videos", @"px_today_videos", @"px_total_seconds", @"px_today_seconds", @"px_total_sessions", @"px_stats_day"]) {
            [defaults removeObjectForKey:key];
        }
        [self reloadStats];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString *)formatSeconds:(double)seconds {
    NSInteger hours = (NSInteger)seconds / 3600;
    NSInteger minutes = ((NSInteger)seconds % 3600) / 60;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%ldh %ldm", (long)hours, (long)minutes];
    }
    return [NSString stringWithFormat:@"%ldm", (long)minutes];
}

@end
