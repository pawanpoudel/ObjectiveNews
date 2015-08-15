#import "GNFetchArticlesUseCaseBoundaries.h"

@interface GNMockFetchArticlesUseCaseOutput : NSObject <GNFetchArticlesUseCaseOutput>

@property (nonatomic) NSError *fetchError;
@property (nonatomic) NSArray *fetchedArticles;

@end
