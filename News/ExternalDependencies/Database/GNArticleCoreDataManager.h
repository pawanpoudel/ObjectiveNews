#import "GNArticleRepository.h"

@import CoreData;
@class GNCoreDataStack;
@class GNManagedArticle;
@class GNArticle;

@interface GNArticleCoreDataManager : NSObject <GNArticleRepository>

- (instancetype)initWithCoreDataStack:(GNCoreDataStack *)coreDataStack NS_DESIGNATED_INITIALIZER;
- (GNArticle *)articleWithUniqueId:(NSString *)uniqueId;
- (GNArticle *)createArticleFromManagedArticle:(GNManagedArticle *)managedArticle;

@end
