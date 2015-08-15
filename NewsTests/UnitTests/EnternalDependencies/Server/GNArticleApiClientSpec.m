#import "Kiwi.h"
#import "GNArticleApiClient.h"
#import "GNGoogleNewsUrlRequest.h"
#import "GNMockNetworkCommunicator.h"
#import "GNGoogleNewsArticleBuilder.h"
#import "GNAbstractArticleBuilder.h"
#import "GNRssEntryBuilder.h"
#import "GNObjectConfigurator.h"
#import "GNTestRssData.h"

SPEC_BEGIN(GNArticleApiClientSpec)

describe(@"GNArticleApiClient", ^{
    __block GNTestRssData *testRssData = nil;
    __block GNGoogleNewsUrlRequest *urlRequest = nil;
    __block GNMockNetworkCommunicator *networkCommunicator = nil;
    __block GNGoogleNewsArticleBuilder *articleBuilder = nil;
    __block GNArticleApiClient *apiClient = nil;

    __block NSArray *returnedArticles = nil;
    __block NSError *returnedError = nil;
    
    beforeEach(^{
        testRssData = [[GNTestRssData alloc] init];
        urlRequest = [[GNGoogleNewsUrlRequest alloc] init];
        networkCommunicator = [[GNMockNetworkCommunicator alloc] init];
        GNRssEntryBuilder *rssEntryBuilder = [[GNRssEntryBuilder alloc] init];
        articleBuilder = [[GNGoogleNewsArticleBuilder alloc] initWithRssEntryBuilder:rssEntryBuilder];
        
        apiClient = [[GNArticleApiClient alloc] initWithArticleUrlRequest:urlRequest
                                                      networkCommunicator:networkCommunicator
                                                           articleBuilder:articleBuilder];
    });
    
    it(@"asks network communicator to fetch articles with correct request", ^{
        NSURLRequest *request = [urlRequest urlRequestForFetchingArticles];
        [apiClient downloadArticlesWithCompletionHandler:nil];
        
        [[theValue(networkCommunicator.wasAskedToFetchData) should] equal:theValue(YES)];
        [[networkCommunicator.fetchRequest should] equal:request];
    });
    
    context(@"when data couldn't be downloaded", ^{
        __block NSError *downloadError = nil;
        
        beforeEach(^{
            downloadError = [NSError errorWithDomain:@"Test domain"
                                                code:0
                                            userInfo:nil];
            networkCommunicator.downloadError = downloadError;
            networkCommunicator.receivedData = nil;
            
            [apiClient downloadArticlesWithCompletionHandler:^(NSArray *articles, NSError *error) {
                returnedArticles = articles;
                returnedError = error;
            }];
        });
        
        it(@"returns no articles", ^{
            [[returnedArticles should] beNil];
        });
        
        it(@"returns an error", ^{
            [[returnedError should] equal:downloadError];
        });
    });
    
    context(@"when data was downloaded successfully", ^{
        beforeEach(^{
            networkCommunicator.downloadError = nil;
        });
        
        context(@"but the data couldn't be parsed", ^{
            beforeEach(^{
                networkCommunicator.receivedData = [testRssData invalidRssData];
                [apiClient downloadArticlesWithCompletionHandler:^(NSArray *articles, NSError *error) {
                    returnedArticles = articles;
                    returnedError = error;
                }];
            });
            
            it(@"returns no articles", ^{
                [[returnedArticles should] beNil];
            });
            
            it(@"returns an error", ^{
                [[returnedError shouldNot] beNil];
            });
        });
        
        context(@"and the data was parsed successfully", ^{
            beforeEach(^{
                networkCommunicator.receivedData = [testRssData validRssData];
                [apiClient downloadArticlesWithCompletionHandler:^(NSArray *articles, NSError *error) {
                    returnedArticles = articles;
                    returnedError = error;
                }];
            });
            
            it(@"returns parsed articles", ^{
                [[theValue(returnedArticles.count) should] equal:theValue([testRssData numberOfItemsInValidRss])];
            });
            
            it(@"doesn't return an error", ^{
                [[returnedError should] beNil];
            });
        });
    });
});

SPEC_END
