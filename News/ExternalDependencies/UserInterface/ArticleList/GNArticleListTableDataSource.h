@import UIKit;
@import CoreData;

extern NSString * const GNDidSelectArticleNotification;

@interface GNArticleListTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL shouldShowArticleLoadingError;

- (void)setFetchedResultsController:(NSFetchedResultsController *)controller;

@end
