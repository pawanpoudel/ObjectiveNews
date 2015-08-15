@import CoreData;
@class GNArticle;

@interface NSFetchedResultsController (GNAdditions)

- (GNArticle *)articleAtIndexPath:(NSIndexPath *)indexPath;

@end
