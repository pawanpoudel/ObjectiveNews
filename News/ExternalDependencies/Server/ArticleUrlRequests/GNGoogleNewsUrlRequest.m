#import "GNGoogleNewsUrlRequest.h"

@implementation GNGoogleNewsUrlRequest

- (NSURLRequest *)urlRequestForFetchingArticles {
    NSURL *url = [NSURL URLWithString:@"https://news.google.com/?output=rss"];
    return [NSURLRequest requestWithURL:url];
}

@end
