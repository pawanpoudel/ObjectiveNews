#import "Kiwi.h"
#import "GNArticle.h"

SPEC_BEGIN(GNArticleSpec)

describe(@"GNArticle", ^{
    __block GNArticle *article = nil;
    
    beforeEach(^{
        article = [[GNArticle alloc] init];
    });
    
    describe(@"Data elements", ^{
        it(@"can be assigned a unique ID", ^{
            article.uniqueId = @"fakeUniqueID";
            [[article.uniqueId should] equal:@"fakeUniqueID"];
        });
        
        it(@"can be assigned a title", ^{
            article.title = @"fakeTitle";
            [[article.title should] equal:@"fakeTitle"];
        });
        
        it(@"can be assigned a summary", ^{
            article.summary = @"fakeSummary";
            [[article.summary should] equal:@"fakeSummary"];
        });
        
        it(@"can be assigned a source URL", ^{
            article.sourceUrl = @"http://example.com/fakeSourceUrl";
            [[article.sourceUrl should] equal:@"http://example.com/fakeSourceUrl"];
        });
        
        it(@"can be assigned an image URL", ^{
            article.imageUrl = @"http://example.com/fakeImageUrl";
            [[article.imageUrl should] equal:@"http://example.com/fakeImageUrl"];
        });
        
        it(@"can be assigned a publisher", ^{
            article.publisher = @"fakePublisher";
            [[article.publisher should] equal:@"fakePublisher"];
        });
        
        it(@"can be assigned a published date", ^{
            NSDate *currentDate = [NSDate date];
            article.publishedDate = currentDate;
            [[theValue([article.publishedDate timeIntervalSinceReferenceDate]) should]
             equal:theValue([currentDate timeIntervalSinceReferenceDate])];
        });
    });
    
    describe(@"Equality", ^{
        __block GNArticle *article1 = nil;
        __block GNArticle *article2 = nil;
        
        beforeEach(^{
            article1 = [[GNArticle alloc] init];
            article2 = [[GNArticle alloc] init];
            
            article1.uniqueId = @"article1_ID";
            article2.uniqueId = @"article2_ID";
        });
        
        it(@"two different articles are not the same", ^{
            [[theValue([article1 isEqual:article2]) should] equal:theValue(NO)];
        });
        
        it(@"an article is the same as itself", ^{
            [[theValue([article1 isEqual:article1]) should] equal:theValue(YES)];
        });
        
        it(@"articles with the same unique ID are the same", ^{
            GNArticle *article3 = [[GNArticle alloc] init];
            article3.uniqueId = @"article1_ID";
            [[theValue([article1 isEqual:article3]) should] equal:theValue(YES)];
        });
        
        it(@"articles with nil unique IDs are never the same", ^{
            GNArticle *article4 = [[GNArticle alloc] init];
            GNArticle *article5 = [[GNArticle alloc] init];
            [[theValue([article4 isEqual:article5]) should] equal:theValue(NO)];
        });
    });
});

SPEC_END
