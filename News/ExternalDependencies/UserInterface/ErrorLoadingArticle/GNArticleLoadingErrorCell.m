#import "GNArticleLoadingErrorCell.h"
#import "UIScreen+GNAdditions.h"

NSString * const GNRefreshArticleListNotification = @"GNRefreshArticleListNotification";

@interface GNArticleLoadingErrorCell ()

@property (nonatomic) CABasicAnimation *dashedCircleAnimation;
@property (weak, nonatomic) IBOutlet UIImageView *warningImageView;

@end

@implementation GNArticleLoadingErrorCell

#pragma mark - Configuring cell

+ (CGFloat)height {
    return [[UIScreen mainScreen] heightWithoutNavigationBar];
}

- (void)awakeFromNib {
    [self configureWarningImageView];
}

- (void)configureWarningImageView {
    self.warningImageView.image = [[UIImage imageNamed:@"errorViewWarning"]
                                        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.warningImageView.tintColor = [UIColor redColor];
}

#pragma mark - Handling refresh view tap

- (IBAction)refreshViewTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:GNRefreshArticleListNotification
                                                        object:nil];
}

@end
