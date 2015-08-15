#import "Kiwi.h"
#import "GNAppleNewsArticleBuilder.h"
#import "GNRssEntryBuilder.h"
#import "GNTestRssData.h"
#import "GNArticle.h"
#import "NSDate+InternetDateTime.h"

SPEC_BEGIN(GNAppleNewsArticleBuilderSpec)

describe(@"GNAppleNewsArticleBuilder", ^{
    __block GNAppleNewsArticleBuilder *articleBuilder = nil;
    __block GNTestRssData *testRssData = nil;
    __block NSArray *parsedArticles = nil;
    __block NSError *parsingError = nil;
    
    beforeEach(^{
        GNRssEntryBuilder *rssEntryBuilder = [[GNRssEntryBuilder alloc] init];
        articleBuilder = [[GNAppleNewsArticleBuilder alloc] initWithRssEntryBuilder:rssEntryBuilder];
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
            parsedArticles = [articleBuilder buildArticlesFromRssData:[testRssData validAppleNewsRssData]
                                                                error:&parsingError];
            firstArticle = [parsedArticles firstObject];
        });
        
        it(@"doesn't return an error", ^{
            [[parsingError should] beNil];
        });
        
        it(@"articles created from RSS data have uniqueId populated", ^{
            NSString *expectedUniqueId = @"http://www.apple.com/pr/library/2015/06/08Apple-Previews-iOS-9.html?sr=hotnews.rss";
            [[firstArticle.uniqueId should] equal:expectedUniqueId];
        });
        
        it(@"articles created from RSS data have title populated", ^{
            NSString *expectedTitle = @"Apple Previews iOS 9";
            [[firstArticle.title should] equal:expectedTitle];
        });
        
        it(@"articles created from RSS data have summary populated", ^{
            NSString *partialSummary = @"Apple today unveiled iOS 9, giving a preview of new iPhone, iPad, and iPod";
            [[firstArticle.summary should] containString:partialSummary];
        });
        
        it(@"articles created from RSS data have sourceUrl populated", ^{
            NSString *expectedSourceUrl = @"http://www.apple.com/pr/library/2015/06/08Apple-Previews-iOS-9.html?sr=hotnews.rss";
            [[firstArticle.sourceUrl should] equal:expectedSourceUrl];
        });
        
        it(@"articles created from RSS data doesn't have imageUrl populated", ^{
            [[firstArticle.imageUrl should] beNil];
        });
        
        it(@"articles created from RSS data have publisher info populated", ^{
            NSString *expectedPublisher = @"apple";
            [[firstArticle.publisher should] equal:expectedPublisher];
        });
        
        it(@"articles created from RSS data have publishedDate populated", ^{
            NSString *expectedPublishedDateString = @"Mon, 08 Jun 2015 13:52:57 PDT";
            NSDate *expectedPublishedDate = [NSDate dateFromInternetDateTimeString:expectedPublishedDateString
                                                                        formatHint:DateFormatHintRFC822];
            NSTimeInterval expectedTimeInterval = [expectedPublishedDate timeIntervalSinceReferenceDate];
            NSTimeInterval actualTimeInterval = [firstArticle.publishedDate timeIntervalSinceReferenceDate];
            [[theValue(actualTimeInterval) should] equal:theValue(expectedTimeInterval)];
        });
    });
});

SPEC_END
