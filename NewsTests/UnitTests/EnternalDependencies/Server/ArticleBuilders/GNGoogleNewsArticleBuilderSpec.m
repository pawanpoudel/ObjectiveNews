#import "Kiwi.h"
#import "GNGoogleNewsArticleBuilder.h"
#import "GNRssEntryBuilder.h"
#import "GNTestRssData.h"
#import "GNArticle.h"
#import "NSDate+InternetDateTime.h"

SPEC_BEGIN(GNGoogleNewsArticleBuilderSpec)

describe(@"GNGoogleNewsArticleBuilder", ^{
    __block GNGoogleNewsArticleBuilder *articleBuilder = nil;
    __block GNTestRssData *testRssData = nil;
    __block NSArray *parsedArticles = nil;
    __block NSError *parsingError = nil;
    
    beforeEach(^{
        GNRssEntryBuilder *rssEntryBuilder = [[GNRssEntryBuilder alloc] init];
        articleBuilder = [[GNGoogleNewsArticleBuilder alloc] initWithRssEntryBuilder:rssEntryBuilder];
        testRssData = [[GNTestRssData alloc] init];
    });
    
    afterEach(^{
        parsingError = nil;
    });
    
    context(@"when the RSS data is invalid", ^{
        beforeEach(^{
            parsedArticles = [articleBuilder buildArticlesFromRssData:[testRssData invalidRssData]
                                                                error:&parsingError];
        });
        
        it(@"doesn't raise an exception", ^{
            [[theBlock(^{
                [articleBuilder buildArticlesFromRssData:[testRssData invalidRssData]
                                                   error:&parsingError];
            }) shouldNot] raise];
        });
        
        it(@"returns nil as articles", ^{
            [[parsedArticles should] beNil];
        });
        
        it(@"sets correct error domain", ^{
            [[parsingError.domain should] equal:GNArticleBuilderErrorDomain];
        });
        
        it(@"sets correct error code", ^{
            [[theValue(parsingError.code) should] equal:theValue(GNArticleBuilderErrorCodeInvalidFeedFormat)];
        });
    });
    
    context(@"when the RSS data is valid", ^{
        __block GNArticle *firstArticle = nil;
        
        beforeEach(^{
            parsedArticles = [articleBuilder buildArticlesFromRssData:[testRssData validGoogleNewsRssData]
                                                                error:&parsingError];
            firstArticle = [parsedArticles firstObject];
        });
        
        it(@"doesn't return an error", ^{
            [[parsingError should] beNil];
        });
        
        it(@"articles created from RSS data have uniqueId populated", ^{
            NSString *expectedUniqueId = @"tag:news.google.com,2005:cluster=52778889419018";
            [[firstArticle.uniqueId should] equal:expectedUniqueId];
        });
        
        it(@"articles created from RSS data have title populated", ^{
            NSString *expectedTitle = @"Supreme Court Ruling Won't Stop Search for Execution Drugs";
            [[firstArticle.title should] equal:expectedTitle];
        });
        
        it(@"articles created from RSS data have summary populated", ^{
            NSString *partialSummary = @"The search for more effective lethal injection drugs and execution methods won";
            [[firstArticle.summary should] containString:partialSummary];
        });
        
        it(@"articles created from RSS data have sourceUrl populated", ^{
            NSString *expectedSourceUrl = @"http://time.com/3940827/supreme-court-lethal-injection-drugs/";
            [[firstArticle.sourceUrl should] equal:expectedSourceUrl];
        });
        
        it(@"articles created from RSS data have imageUrl populated", ^{
            NSString *expectedImageUrl = @"http://t2.gstatic.com/images?q=tbn:ANd9GcRnLhZAAo-nx9l3DX0negHX-O8u-po-l9E9VVHUKJ-8uRZlCrMWLkY_9sfY1TfpwFvZIr_tHezK";
            [[firstArticle.imageUrl should] equal:expectedImageUrl];
        });
        
        it(@"articles created from RSS data have publisher info populated", ^{
            NSString *expectedPublisher = @"TIME";
            [[firstArticle.publisher should] equal:expectedPublisher];
        });
        
        it(@"articles created from RSS data have publishedDate populated", ^{
            NSString *expectedPublishedDateString = @"Tue, 30 Jun 2015 00:42:00 GMT";
            NSDate *expectedPublishedDate = [NSDate dateFromInternetDateTimeString:expectedPublishedDateString
                                                                        formatHint:DateFormatHintRFC822];
            NSTimeInterval expectedTimeInterval = [expectedPublishedDate timeIntervalSinceReferenceDate];
            NSTimeInterval actualTimeInterval = [firstArticle.publishedDate timeIntervalSinceReferenceDate];
            [[theValue(actualTimeInterval) should] equal:theValue(expectedTimeInterval)];
        });
    });
});

SPEC_END
