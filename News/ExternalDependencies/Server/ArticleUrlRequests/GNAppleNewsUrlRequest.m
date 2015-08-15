#import "GNAppleNewsUrlRequest.h"

@implementation GNAppleNewsUrlRequest

- (NSURLRequest *)urlRequestForFetchingArticles {
    NSURL *url = [NSURL URLWithString:@"https://www.apple.com/main/rss/hotnews/hotnews.rss"];
    return [NSURLRequest requestWithURL:url];
}

@end
