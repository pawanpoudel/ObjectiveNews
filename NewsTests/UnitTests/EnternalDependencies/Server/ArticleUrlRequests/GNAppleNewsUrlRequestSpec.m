#import "Kiwi.h"
#import "GNAppleNewsUrlRequest.h"

SPEC_BEGIN(GNAppleNewsUrlRequestSpec)

describe(@"GNAppleNewsUrlRequest", ^{
    __block NSURLRequest *articleUrlRequest = nil;
    
    beforeEach(^{
        GNAppleNewsUrlRequest *appleNewsUrlRequest = [[GNAppleNewsUrlRequest alloc] init];
        articleUrlRequest = appleNewsUrlRequest.urlRequestForFetchingArticles;
    });
    
    it(@"uses correct scheme", ^{
        [[articleUrlRequest.URL.scheme should] equal:@"https"];
    });
    
    it(@"uses correct host", ^{
        [[articleUrlRequest.URL.host should] equal:@"www.apple.com"];
    });
    
    it(@"uses correct relative path", ^{
        [[articleUrlRequest.URL.relativePath should] equal:@"/main/rss/hotnews/hotnews.rss"];
    });
    
    it(@"uses correct HTTP method", ^{
        [[articleUrlRequest.HTTPMethod should] equal:@"GET"];
    });
});

SPEC_END
