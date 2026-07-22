//
//  PXMenuTabBarController.m
//  PXTok — главное меню с вкладками
//

#import "PXMenuTabBarController.h"
#import "PXFeedViewController.h"
#import "PXProfileViewController.h"
#import "PXOtherViewController.h"
#import "PXRegionViewController.h"
#import "PXExtraViewController.h"
#import "PXGhostViewController.h"
#import "../BHIManager.h"

@implementation PXMenuTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    BOOL ru = [BHIManager isRussian];

    // ─── Лента ───
    PXFeedViewController *feed = [[PXFeedViewController alloc] init];
    UINavigationController *feedNav = [[UINavigationController alloc] initWithRootViewController:feed];
    feedNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:(ru ? @"Лента" : @"Feed")
                                                       image:[UIImage systemImageNamed:@"play.rectangle.fill"]
                                                         tag:0];

    // ─── Профиль ───
    PXProfileViewController *profile = [[PXProfileViewController alloc] init];
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profile];
    profileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:(ru ? @"Профиль" : @"Profile")
                                                          image:[UIImage systemImageNamed:@"person.fill"]
                                                            tag:1];

    // ─── Другое ───
    PXOtherViewController *other = [[PXOtherViewController alloc] init];
    UINavigationController *otherNav = [[UINavigationController alloc] initWithRootViewController:other];
    otherNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:(ru ? @"Другое" : @"Other")
                                                        image:[UIImage systemImageNamed:@"slider.horizontal.3"]
                                                          tag:2];

    // ─── Регион ───
    PXRegionViewController *region = [[PXRegionViewController alloc] init];
    UINavigationController *regionNav = [[UINavigationController alloc] initWithRootViewController:region];
    regionNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:(ru ? @"Регион" : @"Region")
                                                         image:[UIImage systemImageNamed:@"globe"]
                                                           tag:3];

    // ─── Режим призрака ───
    PXGhostViewController *ghost = [[PXGhostViewController alloc] init];
    UINavigationController *ghostNav = [[UINavigationController alloc] initWithRootViewController:ghost];
    ghostNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:(ru ? @"Призрак" : @"Ghost")
                                                        image:[UIImage systemImageNamed:@"eye.slash.fill"]
                                                          tag:4];

    // ─── PXTok Extra ───
    PXExtraViewController *extra = [[PXExtraViewController alloc] init];
    UINavigationController *extraNav = [[UINavigationController alloc] initWithRootViewController:extra];
    extraNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"PXTok"
                                                        image:[UIImage systemImageNamed:@"sparkles"]
                                                          tag:5];

    self.viewControllers = @[feedNav, profileNav, otherNav, regionNav, ghostNav, extraNav];
    self.tabBar.tintColor = [UIColor systemPinkColor];
}

@end
