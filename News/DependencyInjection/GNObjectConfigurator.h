@import Foundation;
@class GNFetchArticlesUseCase;
@class GNArticleApiClient;
@class GNAbstractArticleBuilder;
@class GNArticleCoreDataManager;
@class GNCoreDataStack;
@class GNArticleListViewController;

@interface GNObjectConfigurator : NSObject

+ (GNObjectConfigurator *)sharedInstance;
- (GNFetchArticlesUseCase *)fetchArticlesUseCase;
- (GNArticleApiClient *)articleApiClient;
- (GNAbstractArticleBuilder *)articleBuilder;
- (GNArticleCoreDataManager *)articleCoreDataManager;
- (GNCoreDataStack *)coreDataStack;
- (GNArticleListViewController *)articleListViewController;

@end
