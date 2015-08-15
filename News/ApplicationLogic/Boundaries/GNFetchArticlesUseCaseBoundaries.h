@import Foundation;

@protocol GNFetchArticlesUseCaseOutput <NSObject>

- (void)didReceiveArticles:(NSArray *)articles;
- (void)fetchingArticlesFailedWithError:(NSError *)error;

@end

@protocol GNFetchArticlesUseCaseInput <NSObject>

@property (nonatomic, weak) id<GNFetchArticlesUseCaseOutput> output;
- (void)fetchArticles;

@end
