#import "Kiwi.h"
#import "GNArticleCoreDataManager.h"
#import "GNCoreDataStack.h"
#import "GNArticle.h"

SPEC_BEGIN(GNDatabaseIntegrationSpec)

describe(@"Database integration", ^{
    __block GNCoreDataStack *coreDataStack = nil;
    __block GNArticleCoreDataManager *dataManager = nil;
    
    beforeEach(^{
        coreDataStack = [[GNCoreDataStack alloc] initWithPersistentStoreType:NSInMemoryStoreType];
        dataManager = [[GNArticleCoreDataManager alloc] initWithCoreDataStack:coreDataStack];
    });
    
    describe(@"Verifying existence of an article", ^{
        context(@"when the specified article doesn't exist", ^{
            it(@"database manager returns NO", ^{
                GNArticle *newArticle = [[GNArticle alloc] init];
                newArticle.uniqueId = @"1234";
                [[theValue([dataManager doesArticleExist:newArticle]) should] equal:theValue(NO)];
            });
        });
        
        context(@"when the specified article exists", ^{
            it(@"database manager returns YES", ^{
                GNArticle *existingArticle = [[GNArticle alloc] init];
                existingArticle.uniqueId = @"9999";
                [dataManager saveArticle:existingArticle];
                [[theValue([dataManager doesArticleExist:existingArticle]) should] equal:theValue(YES)];
            });
        });
    });
    
    describe(@"Saving an article", ^{
        __block GNArticle *newArticle = nil;
        
        beforeEach(^{
            newArticle = [[GNArticle alloc] init];
            newArticle.uniqueId = @"5555";
            [dataManager saveArticle:newArticle];
        });
        
        it(@"database manager saves the specified article into the database", ^{
            GNArticle *retrievedArticle = [dataManager articleWithUniqueId:@"5555"];
            [[retrievedArticle should] equal:newArticle];
        });
    });
});

SPEC_END
