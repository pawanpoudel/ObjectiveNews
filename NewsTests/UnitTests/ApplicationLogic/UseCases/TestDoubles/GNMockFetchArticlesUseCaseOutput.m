#import "GNMockFetchArticlesUseCaseOutput.h"

@implementation GNMockFetchArticlesUseCaseOutput

- (void)fetchingArticlesFailedWithError:(NSError *)error {
    self.fetchError = error;
}

- (void)didReceiveArticles:(NSArray *)articles {
    self.fetchedArticles = articles;
}

@end
