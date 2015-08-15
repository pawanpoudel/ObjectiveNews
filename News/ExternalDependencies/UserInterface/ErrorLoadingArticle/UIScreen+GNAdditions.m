#import "UIScreen+GNAdditions.h"
#import "GNAppDelegate.h"

@implementation UIScreen (GNAdditions)

- (CGFloat)heightWithoutNavigationBar {
    CGFloat screenHeight = self.applicationFrame.size.height;
    screenHeight -= [self navigationBarHeight];
    return screenHeight;
}

- (CGFloat)navigationBarHeight {
    GNAppDelegate *appDelegate = (GNAppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navController = (UINavigationController *)appDelegate.window.rootViewController;
    return navController.navigationBar.frame.size.height;
}

@end
