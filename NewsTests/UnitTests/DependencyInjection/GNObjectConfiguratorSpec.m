#import "Kiwi.h"
#import "GNObjectConfigurator.h"
#import "GNFetchArticlesUseCase.h"
#import "GNArticleApiClient.h"
#import "GNRssEntryBuilder.h"
#import "GNAbstractArticleBuilder.h"
#import "GNArticleUrlRequest.h"
#import "GNArticleCoreDataManager.h"
#import "GNCoreDataStack.h"
#import "GNArticleListViewController.h"
#import "GNFetchArticlesUseCaseBoundaries.h"
#import "GNArticleListTableDataSource.h"
#import "GNCoreDataStack.h"

SPEC_BEGIN(GNObjectConfiguratorSpec)

describe(@"GNObjectConfigurator", ^{
    __block GNObjectConfigurator *configurator = nil;
    
    beforeEach(^{
        configurator = [GNObjectConfigurator sharedInstance];
    });
    
    describe(@"sharedInstance", ^{
        it(@"returns the same instance every time", ^{
            GNObjectConfigurator *configurator1 = [GNObjectConfigurator sharedInstance];
            GNObjectConfigurator *configurator2 = [GNObjectConfigurator sharedInstance];
            [[configurator1 should] beIdenticalTo:configurator2];
        });
    });
    
    describe(@"fetchArticlesUseCase", ^{
        __block GNFetchArticlesUseCase *useCase = nil;
        
        beforeEach(^{
            useCase = [configurator fetchArticlesUseCase];
        });
        
        it(@"is not nil", ^{
            [[useCase shouldNot] beNil];
        });
        
        it(@"has a non-nil article service", ^{
            [[[useCase valueForKey:@"articleService"] shouldNot] beNil];
        });
        
        it(@"has a non-nil article repository", ^{
            [[[useCase valueForKey:@"articleRepository"] shouldNot] beNil];
        });
    });

    describe(@"articleApiClient", ^{
        __block GNArticleApiClient *apiClient = nil;
        
        beforeEach(^{
            apiClient = [configurator articleApiClient];
        });
        
        it(@"is not nil", ^{
            [[apiClient shouldNot] beNil];
        });
        
        it(@"has a non-nil article URL request", ^{
            [[[apiClient valueForKey:@"articleUrlRequest"] shouldNot] beNil];
        });
        
        it(@"has a non-nil network communicator", ^{
            [[[apiClient valueForKey:@"networkCommunicator"] shouldNot] beNil];
        });
        
        it(@"has a non-nil article builder", ^{
            [[[apiClient valueForKey:@"articleBuilder"] shouldNot] beNil];
        });
    });

    describe(@"articleBuilder", ^{
        __block GNAbstractArticleBuilder *articleBuilder = nil;
        
        beforeEach(^{
            articleBuilder = [configurator articleBuilder];
        });
        
        it(@"is not nil", ^{
            [[articleBuilder shouldNot] beNil];
        });
        
        it(@"has a non-nil RSS entry builder", ^{
            [[[articleBuilder valueForKey:@"rssEntryBuilder"] shouldNot] beNil];
        });
    });

    describe(@"articleCoreDataManager", ^{
        __block GNArticleCoreDataManager *dataManager = nil;
        
        beforeEach(^{
            dataManager = [configurator articleCoreDataManager];
        });
        
        it(@"is not nil", ^{
            [[dataManager shouldNot] beNil];
        });
        
        it(@"has a non-nil Core Data stack", ^{
            [[[dataManager valueForKey:@"coreDataStack"] shouldNot] beNil];
        });
    });
    
    describe(@"coreDataStack", ^{
        __block GNCoreDataStack *coreDataStack = nil;
        
        beforeEach(^{
            coreDataStack = [configurator coreDataStack];
        });
        
        it(@"is not nil", ^{
            [[coreDataStack shouldNot] beNil];
        });
        
        it(@"is a singleton", ^{
            GNCoreDataStack *coreDataStack1 = [configurator coreDataStack];
            GNCoreDataStack *coreDataStack2 = [configurator coreDataStack];
            [[coreDataStack1 should] beIdenticalTo:coreDataStack2];
        });
    });
    
    describe(@"articleListViewController", ^{
        __block GNArticleListViewController *viewController = nil;
        
        beforeEach(^{
            viewController = [configurator articleListViewController];
        });
        
        it(@"is not nil", ^{
            [[viewController shouldNot] beNil];
        });
        
        it(@"has a non-nil use case object for fetching articles", ^{
            [[[viewController valueForKey:@"fetchArticlesUseCaseInput"] shouldNot] beNil];
        });
        
        it(@"has a non-nil article list table data source object", ^{
            [[viewController.dataSource shouldNot] beNil];
        });
        
        it(@"has a non-nil core data stack", ^{
            [[viewController.coreDataStack shouldNot] beNil];
        });
    });
});

SPEC_END
