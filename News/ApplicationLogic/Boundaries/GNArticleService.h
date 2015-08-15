@import Foundation;

@protocol GNArticleService <NSObject>

- (void)downloadArticlesWithCompletionHandler:(void(^)(NSArray*, NSError*))completionHandler;

@end
