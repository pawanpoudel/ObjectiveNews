#import "GNArticleListViewController.h"
#import "GNArticleListTableDataSource.h"
#import "GNObjectConfigurator.h"
#import "PBWebViewController.h"
#import "GNCoreDataStack.h"
#import "GNArticle.h"
#import "GNArticleLoadingErrorCell.h"
#import "GNPullToRefreshView.h"
#import "SSPullToRefresh/SSPullToRefresh.h"

@interface GNArticleListViewController () <NSFetchedResultsControllerDelegate, SSPullToRefreshViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *articlesTableView;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) SSPullToRefreshView *pullToRefreshView;

@end

@implementation GNArticleListViewController

#pragma mark - Managing view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Google News", nil);
    [self configureTableView];
    [self fetchArticles];
}

- (void)viewDidLayoutSubviews {
    if (self.pullToRefreshView == nil) {
        self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.articlesTableView
                                                                        delegate:self];
        
        self.pullToRefreshView.contentView = [[GNPullToRefreshView alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.pullToRefreshView startLoadingAndExpand:YES
                                         animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectArticleNotification:)
                                                 name:GNDidSelectArticleNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchArticles)
                                                 name:GNRefreshArticleListNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GNDidSelectArticleNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:GNRefreshArticleListNotification
                                                  object:nil];
}

- (void)configureTableView {
    self.articlesTableView.dataSource = self.dataSource;
    self.articlesTableView.delegate = self.dataSource;
    [self.dataSource setFetchedResultsController:self.fetchedResultsController];
}

#pragma mark - Handling notifications

- (void)didSelectArticleNotification:(NSNotification *)notification {
    GNArticle *article = [notification object];
    PBWebViewController *webViewController = [[PBWebViewController alloc] init];
    webViewController.URL = [NSURL URLWithString:article.sourceUrl];
    
    [self.navigationController pushViewController:webViewController
                                         animated:YES];
}

#pragma mark - Pull to refresh delegate methods

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
    [self fetchArticles];
}

#pragma mark - Fetching articles

- (void)fetchArticles {
    self.dataSource.shouldShowArticleLoadingError = NO;
    [self.fetchArticlesUseCaseInput fetchArticles];
    [self showArticlesSavedLocally];
}

- (void)showArticlesSavedLocally {
    NSError *error = nil;
    BOOL successfullyFetchedNewsFromDatabase = [self.fetchedResultsController performFetch:&error];
    
    if (!successfullyFetchedNewsFromDatabase) {
        NSLog(@"Error occurred while fetching articles from database: %@", error.localizedDescription);
    }
    
    [self.articlesTableView reloadData];
}

#pragma mark - Handling fetch articles usecase output

- (void)didReceiveArticles:(NSArray *)articles {
    NSLog(@"Received %ld articles", (long)[articles count]);
    [self.pullToRefreshView finishLoading];
    self.dataSource.shouldShowArticleLoadingError = NO;
    [self.articlesTableView reloadData];
}

- (void)fetchingArticlesFailedWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
    [self.pullToRefreshView finishLoading];
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        self.dataSource.shouldShowArticleLoadingError = YES;
    }
    
    [self.articlesTableView reloadData];
}

#pragma mark - Creating a fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"GNManagedArticle"];
        NSSortDescriptor *sortByPublishedDate = [[NSSortDescriptor alloc] initWithKey:@"publishedDate"
                                                                            ascending:NO];
        fetchRequest.sortDescriptors = @[sortByPublishedDate];
        fetchRequest.fetchBatchSize = 10;
        
        NSManagedObjectContext *context = self.coreDataStack.mainQueueContext;
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultController delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.articlesTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.articlesTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationTop];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (!newIndexPath) {
                [tableView reloadRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [tableView deleteRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
                [tableView insertRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationNone];
            }
            
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.articlesTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.articlesTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.articlesTableView endUpdates];
}

@end
