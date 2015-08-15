#import "GNArticleCoreDataManager.h"
#import "GNCoreDataStack.h"
#import "GNManagedArticle.h"
#import "GNArticle.h"
#import "NSManagedObject+GNAdditions.h"

@interface GNArticleCoreDataManager()

@property (nonatomic) GNCoreDataStack *coreDataStack;

@end

@implementation GNArticleCoreDataManager

#pragma mark - Initializing a data manager

- (instancetype)initWithCoreDataStack:(GNCoreDataStack *)coreDataStack {
    self = [super init];
    
    if (self) {
        _coreDataStack = coreDataStack;
    }
    
    return self;
}

#pragma mark - Retrieving articles

- (GNArticle *)articleWithUniqueId:(NSString *)uniqueId {
    GNManagedArticle *managedArticle = [self fetchManagedArticleWithUniqueId:uniqueId];
    
    if (managedArticle) {
        return [self createArticleFromManagedArticle:managedArticle];
    }
    
    return nil;
}

- (GNArticle *)createArticleFromManagedArticle:(GNManagedArticle *)managedArticle {
    GNArticle *article = [[GNArticle alloc] init];
    article.uniqueId = managedArticle.uniqueId;
    article.title = managedArticle.title;
    article.summary = managedArticle.summary;
    article.sourceUrl = managedArticle.sourceUrl;
    article.imageUrl = managedArticle.imageUrl;
    article.publisher = managedArticle.publisher;
    article.publishedDate = managedArticle.publishedDate;
    return article;
}

#pragma mark - Verifying existence of an article

- (BOOL)doesArticleExist:(GNArticle *)article {
    GNManagedArticle *managedArticle = [self fetchManagedArticleWithUniqueId:article.uniqueId];
    return managedArticle ? YES : NO;
}

- (GNManagedArticle *)fetchManagedArticleWithUniqueId:(NSString *)uniqueId {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"GNManagedArticle"];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueId like %@", uniqueId];
    
    NSError *error = nil;
    NSArray *articles = [self.coreDataStack.mainQueueContext executeFetchRequest:request
                                                                           error:&error];
    if (!articles) {
        NSLog(@"Error occurred while retrieving an article with unique ID: %@", error.localizedDescription);
        return nil;
    }
    
    if ([articles count] > 0) {
        return (GNManagedArticle *)[articles firstObject];
    }
    
    return nil;
}

#pragma mark - Saving an article

- (void)saveArticle:(GNArticle *)article {
    [self createManagedArticleFromArticle:article];
    [self.coreDataStack saveContextForMainQueue];
}

- (void)createManagedArticleFromArticle:(GNArticle *)article {
    GNManagedArticle *managedArticle =
        [GNManagedArticle createManagedObjectInContext:self.coreDataStack.mainQueueContext];
    
    managedArticle.uniqueId = article.uniqueId;
    managedArticle.title = article.title;
    managedArticle.summary = article.summary;
    managedArticle.sourceUrl = article.sourceUrl;
    managedArticle.publisher = article.publisher;
    managedArticle.imageUrl = article.imageUrl;
    managedArticle.publishedDate = article.publishedDate;
}

@end
