#import "GNAppDelegate.h"
#import "GNArticleListViewController.h"
#import "GNObjectConfigurator.h"

@implementation GNAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GNArticleListViewController *articleListVC = [[GNObjectConfigurator sharedInstance] articleListViewController];
    UINavigationController *articleListNavController = [[UINavigationController alloc] initWithRootViewController:articleListVC];
    
    self.window.rootViewController = articleListNavController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
