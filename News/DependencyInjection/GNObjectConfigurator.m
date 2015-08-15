#import "GNObjectConfigurator.h"
#import "GNFetchArticlesUseCase.h"

#import "GNNetworkCommunicator.h"
#import "GNArticleApiClient.h"
#import "GNRssEntryBuilder.h"

#import "GNGoogleNewsArticleBuilder.h"
#import "GNAppleNewsArticleBuilder.h"

#import "GNGoogleNewsUrlRequest.h"
#import "GNAppleNewsUrlRequest.h"

#import "GNArticleCoreDataManager.h"
#import "GNCoreDataStack.h"

#import "GNArticleListViewController.h"
#import "GNArticleListTableDataSource.h"

@implementation GNObjectConfigurator

#pragma mark - Creating object configurator

+ (GNObjectConfigurator *)sharedInstance {
    static GNObjectConfigurator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Configuring use case objects

- (GNFetchArticlesUseCase *)fetchArticlesUseCase {
    return [[GNFetchArticlesUseCase alloc] initWithArticleService:[self articleApiClient]
                                                articleRepository:[self articleCoreDataManager]];
}

#pragma mark - Configuring server objects

- (GNArticleApiClient *)articleApiClient {
    id<GNArticleUrlRequest> urlRequest = [[GNGoogleNewsUrlRequest alloc] init];
    GNNetworkCommunicator *networkCommunicator = [[GNNetworkCommunicator alloc] init];
    
    return [[GNArticleApiClient alloc] initWithArticleUrlRequest:urlRequest
                                             networkCommunicator:networkCommunicator
                                                  articleBuilder:[self articleBuilder]];
}

- (GNAbstractArticleBuilder *)articleBuilder {
    GNRssEntryBuilder *rssEntryBuilder = [[GNRssEntryBuilder alloc] init];
    return [[GNGoogleNewsArticleBuilder alloc] initWithRssEntryBuilder:rssEntryBuilder];
}

#pragma mark - Configuring database objects

- (GNArticleCoreDataManager *)articleCoreDataManager {
    return [[GNArticleCoreDataManager alloc] initWithCoreDataStack:[self coreDataStack]];
}

- (GNCoreDataStack *)coreDataStack {
    static GNCoreDataStack *coreDataStack = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        coreDataStack = [[GNCoreDataStack alloc] initWithPersistentStoreType:NSSQLiteStoreType];
    });
    
    return coreDataStack;
}

#pragma mark - Configuring view controllers

- (GNArticleListViewController *)articleListViewController {
    GNArticleListViewController *articleListVC = [[GNArticleListViewController alloc] init];
    articleListVC.dataSource = [[GNArticleListTableDataSource alloc] init];
    articleListVC.coreDataStack = [self coreDataStack];
    
    GNFetchArticlesUseCase *fetchArticlesUseCase = [self fetchArticlesUseCase];
    fetchArticlesUseCase.output = articleListVC;
    articleListVC.fetchArticlesUseCaseInput = fetchArticlesUseCase;
    
    return articleListVC;
}

@end
