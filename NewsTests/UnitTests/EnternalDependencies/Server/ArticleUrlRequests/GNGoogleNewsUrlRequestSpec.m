#import "Kiwi.h"
#import "GNGoogleNewsUrlRequest.h"

SPEC_BEGIN(GNGoogleNewsUrlRequestSpec)

describe(@"GNGoogleNewsUrlRequest", ^{
    __block NSURLRequest *articleUrlRequest = nil;
    
    beforeEach(^{
        GNGoogleNewsUrlRequest *googleNewsUrlRequest = [[GNGoogleNewsUrlRequest alloc] init];
        articleUrlRequest = googleNewsUrlRequest.urlRequestForFetchingArticles;
    });
    
    it(@"uses correct scheme", ^{
        [[articleUrlRequest.URL.scheme should] equal:@"https"];
    });
    
    it(@"uses correct host", ^{
        [[articleUrlRequest.URL.host should] equal:@"news.google.com"];
    });
    
    it(@"uses correct relative path", ^{
        [[articleUrlRequest.URL.relativePath should] equal:@"/"];
    });
    
    it(@"uses correct query", ^{
        [[articleUrlRequest.URL.query should] equal:@"output=rss"];
    });
    
    it(@"uses correct HTTP method", ^{
        [[articleUrlRequest.HTTPMethod should] equal:@"GET"];
    });
});

SPEC_END
