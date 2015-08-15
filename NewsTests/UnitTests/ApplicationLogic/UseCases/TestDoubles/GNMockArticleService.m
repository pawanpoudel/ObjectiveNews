#import "GNMockArticleService.h"
#import "GNArticle.h"

@interface GNMockArticleService ()

@property (nonatomic, copy) void (^completionHandler)(NSArray*, NSError*);

@end

@implementation GNMockArticleService

- (void)downloadArticlesWithCompletionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    self.completionHandler = completionHandler;
    
    if (self.errorToReturn) {
        [self notifyCallerWithError];
    } else {
        [self notifyCallerWithArticles];
    }
}

- (void)notifyCallerWithError {
    if (self.completionHandler) {
        self.completionHandler(nil, self.errorToReturn);
    }
}

#pragma mark - Creating test articles

- (void)notifyCallerWithArticles {
    NSArray *articles = [self createArticles];
    
    if (self.completionHandler) {
        self.completionHandler(articles, nil);
    }
}

- (NSArray *)createArticles {
    NSMutableArray *articles = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < self.numberOfArticlesToReturn; i++) {
        GNArticle *article = [self createArticleWithUniqueId:i];
        [articles addObject:article];
    }
    
    return [articles copy];
}

- (GNArticle *)createArticleWithUniqueId:(NSInteger)identifier {
    GNArticle *article = [[GNArticle alloc] init];
    article.uniqueId = [NSString stringWithFormat:@"%ld", identifier];
    article.title = [NSString stringWithFormat:@"Title for article with uniqueId: %ld", identifier];
    article.summary = [NSString stringWithFormat:@"Summary for article with uniqueId: %ld", identifier];
    article.sourceUrl = [NSString stringWithFormat:@"http://example.com/article-%ld", identifier];
    article.imageUrl = [NSString stringWithFormat:@"http://example.com/article-%ld/image", identifier];
    article.publisher = [NSString stringWithFormat:@"Publisher for article with uniqueId: %ld", identifier];
    article.publishedDate = [NSDate dateWithTimeIntervalSinceNow:identifier];
    return article;
}

@end
