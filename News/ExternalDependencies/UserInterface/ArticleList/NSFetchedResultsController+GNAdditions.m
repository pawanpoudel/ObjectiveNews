#import "NSFetchedResultsController+GNAdditions.h"
#import "GNManagedArticle.h"
#import "GNArticle.h"
#import "GNArticleCoreDataManager.h"
#import "GNObjectConfigurator.h"

@implementation NSFetchedResultsController (GNFetchArticle)

- (GNArticle *)articleAtIndexPath:(NSIndexPath *)indexPath {
    GNManagedArticle *managedArticle = (GNManagedArticle *)[self objectAtIndexPath:indexPath];
    GNArticleCoreDataManager *dataManager = [[GNObjectConfigurator sharedInstance] articleCoreDataManager];
    return [dataManager createArticleFromManagedArticle:managedArticle];
}

@end
