#import "Kiwi.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "GNArticleApiClient.h"
#import "GNGoogleNewsUrlRequest.h"
#import "GNNetworkCommunicator.h"
#import "GNGoogleNewsArticleBuilder.h"
#import "GNRssEntryBuilder.h"
#import "GNArticle.h"
#import "NSDate+InternetDateTime.h"

SPEC_BEGIN(GNArticleApiClientIntegrationSpec)

describe(@"Article API client integration", ^{
    __block GNGoogleNewsUrlRequest *urlRequest = nil;
    __block GNNetworkCommunicator *networkCommunicator = nil;
    __block GNAbstractArticleBuilder *articleBuilder = nil;
    __block GNArticleApiClient *apiClient = nil;
    
    __block NSArray *returnedArticles = nil;
    __block NSError *returnedError = nil;
    
    beforeEach(^{
        urlRequest = [[GNGoogleNewsUrlRequest alloc] init];
        networkCommunicator = [[GNNetworkCommunicator alloc] init];
        GNRssEntryBuilder *rssEntryBuilder = [[GNRssEntryBuilder alloc] init];
        articleBuilder = [[GNGoogleNewsArticleBuilder alloc] initWithRssEntryBuilder:rssEntryBuilder];
        apiClient = [[GNArticleApiClient alloc] initWithArticleUrlRequest:urlRequest
                                                      networkCommunicator:networkCommunicator
                                                           articleBuilder:articleBuilder];
    });
    
    context(@"when data was downloaded successfully", ^{
        __block GNArticle *firstArticle = nil;
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [request.URL.absoluteString isEqualToString:@"https://news.google.com/?output=rss"];
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"validGoogleNewsRssFeed.xml", self.class)
                                                        statusCode:200
                                                           headers:@{@"Content-Type":@"application/rss+xml"}];
            }];
            
            [apiClient downloadArticlesWithCompletionHandler:^(NSArray *articles, NSError *error) {
                returnedArticles = articles;
                returnedError = error;
                firstArticle = [returnedArticles firstObject];
            }];
        });
        
        it(@"articles created from RSS data have uniqueId populated", ^{
            NSString *expectedUniqueId = @"tag:news.google.com,2005:cluster=52778889419018";
            [[expectFutureValue(firstArticle.uniqueId) shouldEventually] equal:expectedUniqueId];
        });
        
        it(@"articles created from RSS data have title populated", ^{
            NSString *expectedTitle = @"Supreme Court Ruling Won't Stop Search for Execution Drugs";
            [[expectFutureValue(firstArticle.title) shouldEventually] equal:expectedTitle];
        });
        
        it(@"articles created from RSS data have summary populated", ^{
            NSString *partialSummary = @"The search for more effective lethal injection drugs and execution methods won";
            [[expectFutureValue(firstArticle.summary) shouldEventually] containString:partialSummary];
        });
        
        it(@"articles created from RSS data have sourceUrl populated", ^{
            NSString *expectedSourceUrl = @"http://time.com/3940827/supreme-court-lethal-injection-drugs/";
            [[expectFutureValue(firstArticle.sourceUrl) shouldEventually] equal:expectedSourceUrl];
        });
        
        it(@"articles created from RSS data have imageUrl populated", ^{
            NSString *expectedImageUrl = @"http://t2.gstatic.com/images?q=tbn:ANd9GcRnLhZAAo-nx9l3DX0negHX-O8u-po-l9E9VVHUKJ-8uRZlCrMWLkY_9sfY1TfpwFvZIr_tHezK";
            [[expectFutureValue(firstArticle.imageUrl) shouldEventually] equal:expectedImageUrl];
        });
        
        it(@"articles created from RSS data have publisher info populated", ^{
            NSString *expectedPublisher = @"TIME";
            [[expectFutureValue(firstArticle.publisher) shouldEventually] equal:expectedPublisher];
        });
        
        it(@"articles created from RSS data have publishedDate populated", ^{
            NSString *expectedPublishedDateString = @"Tue, 30 Jun 2015 00:42:00 GMT";
            NSDate *expectedPublishedDate = [NSDate dateFromInternetDateTimeString:expectedPublishedDateString
                                                                        formatHint:DateFormatHintRFC822];
            NSTimeInterval expectedTimeInterval = [expectedPublishedDate timeIntervalSinceReferenceDate];
            NSTimeInterval actualTimeInterval = [firstArticle.publishedDate timeIntervalSinceReferenceDate];
            [[expectFutureValue(theValue(actualTimeInterval)) shouldEventually] equal:theValue(expectedTimeInterval)];
        });
    });
});

SPEC_END
