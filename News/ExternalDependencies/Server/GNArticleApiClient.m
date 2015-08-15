#import "GNArticleApiClient.h"
#import "GNNetworkCommunicator.h"
#import "GNAbstractArticleBuilder.h"

@interface GNArticleApiClient ()

@property (nonatomic) id<GNArticleUrlRequest> articleUrlRequest;
@property (nonatomic) GNNetworkCommunicator *networkCommunicator;
@property (nonatomic) GNAbstractArticleBuilder *articleBuilder;
@property (nonatomic, copy) void(^completionHandler)(NSArray *, NSError *);

@end

@implementation GNArticleApiClient

- (instancetype)initWithArticleUrlRequest:(id<GNArticleUrlRequest>)articleUrlRequest
                      networkCommunicator:(GNNetworkCommunicator *)networkCommunicator
                           articleBuilder:(GNAbstractArticleBuilder *)articleBuilder
{
    self = [super init];
    
    if (self) {
        _articleUrlRequest = articleUrlRequest;
        _networkCommunicator = networkCommunicator;
        _articleBuilder = articleBuilder;
    }
    
    return self;
}

- (void)downloadArticlesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    self.completionHandler = completionHandler;
    NSURLRequest *request = [self.articleUrlRequest urlRequestForFetchingArticles];
    [self performRequest:request];
}

- (void)performRequest:(NSURLRequest *)request {
    [self.networkCommunicator performRequest:request
                           completionHandler:^(NSData *data, NSError *error) {
                               if (error) {
                                   [self notifyCallerWithError:error];
                               } else {
                                   [self buildArticlesFromFeedData:data];
                               }
                           }];
}

- (void)notifyCallerWithError:(NSError *)error {
    if (self.completionHandler) {
        self.completionHandler(nil, error);
    }
}

- (void)buildArticlesFromFeedData:(NSData *)data {
    NSError *error = nil;
    NSArray *articles = [self.articleBuilder buildArticlesFromRssData:data
                                                                error:&error];
    if (articles) {
        [self notifyCallerWithArticles:articles];
    } else {
        [self notifyCallerWithError:error];
    }
}

- (void)notifyCallerWithArticles:(NSArray *)articles {
    if (self.completionHandler) {
        self.completionHandler(articles, nil);
    }
}

@end
