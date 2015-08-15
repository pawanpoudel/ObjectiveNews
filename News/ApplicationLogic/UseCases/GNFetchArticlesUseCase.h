#import "GNFetchArticlesUseCaseBoundaries.h"
#import "GNArticleService.h"
#import "GNArticleRepository.h"

@interface GNFetchArticlesUseCase : NSObject <GNFetchArticlesUseCaseInput>

@property (nonatomic, weak) id<GNFetchArticlesUseCaseOutput> output;

- (instancetype)initWithArticleService:(id<GNArticleService>)articleService
                     articleRepository:(id<GNArticleRepository>)articleRepository NS_DESIGNATED_INITIALIZER;

@end
