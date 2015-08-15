#import "Kiwi.h"
#import "GNFetchArticlesUseCase.h"
#import "GNMockFetchArticlesUseCaseOutput.h"
#import "GNMockArticleService.h"
#import "GNArticleRepository.h"

SPEC_BEGIN(GNFetchArticlesUseCaseSpec)

describe(@"GNFetchArticlesUseCase", ^{
    __block GNMockFetchArticlesUseCaseOutput *output = nil;
    __block GNMockArticleService *articleService = nil;
    __block id articleRepository = nil;
    __block GNFetchArticlesUseCase *useCase = nil;
    
    beforeEach(^{
        articleService = [[GNMockArticleService alloc] init];
        articleRepository = [KWMock nullMockForProtocol:@protocol(GNArticleRepository)];
        useCase = [[GNFetchArticlesUseCase alloc] initWithArticleService:articleService
                                                       articleRepository:articleRepository];
        output = [[GNMockFetchArticlesUseCaseOutput alloc] init];
        useCase.output = output;
    });
    
    context(@"when the article service encounters an error", ^{
        __block NSError *errorToReturn;
        
        beforeEach(^{
            errorToReturn = [NSError errorWithDomain:@"Test Error"
                                                code:0
                                            userInfo:nil];
            
            articleService.errorToReturn = errorToReturn;
            [useCase fetchArticles];
        });
        
        it(@"use case output receives an error", ^{
            [[output.fetchError should] equal:errorToReturn];
        });
        
        it(@"use case output receives no articles", ^{
            [[output.fetchedArticles should] beNil];
        });
        
        it(@"doesn't ask the repository to save articles", ^{
            [[articleRepository shouldNot] receive:@selector(saveArticle:)];
        });
    });
    
    context(@"when the article service downloads zero articles", ^{
        beforeEach(^{
            articleService.numberOfArticlesToReturn = 0;
            articleService.errorToReturn = nil;
            [useCase fetchArticles];
        });
        
        it(@"use case output doesn't receive an error", ^{
            [[output.fetchError should] beNil];
        });
        
        it(@"use case output receives an empty articles arrray", ^{
            [[theValue(output.fetchedArticles.count) should] equal:theValue(0)];
        });
        
        it(@"doesn't ask the repository to save articles", ^{
            [[articleRepository shouldNot] receive:@selector(saveArticle:)];
        });
    });
    
    context(@"when the article service downloads multiple articles", ^{
        __block NSInteger numberOfArticles;
        
        beforeEach(^{
            numberOfArticles = 2;
            articleService.numberOfArticlesToReturn = numberOfArticles;
            articleService.errorToReturn = nil;
        });
        
        it(@"use case output doesn't receive an error", ^{
            [useCase fetchArticles];
            [[output.fetchError should] beNil];
        });
        
        it(@"use case output receives the same number of articles", ^{
            [useCase fetchArticles];
            [[theValue(output.fetchedArticles.count) should] equal:theValue(numberOfArticles)];
        });
        
        context(@"but the articles already exist in repository", ^{
            beforeEach(^{
                [articleRepository stub:@selector(doesArticleExist:)
                              andReturn:theValue(YES)];
            });
            
            it(@"doesn't ask the repository to save the articles again", ^{
                [[articleRepository shouldNot] receive:@selector(saveArticle:)];
                [useCase fetchArticles];
            });
        });
        
        context(@"and the articles don't already exist in repository", ^{
            beforeEach(^{
                [articleRepository stub:@selector(doesArticleExist:)
                              andReturn:theValue(NO)];
            });
            
            it(@"asks the repository to save the articles", ^{
                [[articleRepository should] receive:@selector(saveArticle:)
                                          withCount:numberOfArticles];
                [useCase fetchArticles];
            });
        });
    });
});

SPEC_END
