#import "GNFetchArticlesUseCase.h"
#import "GNArticle.h"

@interface GNFetchArticlesUseCase ()

@property (nonatomic) id<GNArticleService> articleService;
@property (nonatomic) id<GNArticleRepository> articleRepository;

@end

@implementation GNFetchArticlesUseCase

- (instancetype)initWithArticleService:(id<GNArticleService>)articleService
                     articleRepository:(id<GNArticleRepository>)articleRepository
{
    self = [super init];
    
    if (self) {
        _articleService = articleService;
        _articleRepository = articleRepository;
    }
    
    return self;
}

- (void)fetchArticles {
    [self.articleService downloadArticlesWithCompletionHandler:^(NSArray *articles, NSError *error) {
        if (error) {
            [self.output fetchingArticlesFailedWithError:error];
        } else {
            [self saveArticles:articles];
            [self.output didReceiveArticles:articles];
        }
    }];
}

- (void)saveArticles:(NSArray *)articles {
    [articles enumerateObjectsUsingBlock:^(GNArticle *article, NSUInteger index, BOOL *stop) {
        if (![self.articleRepository doesArticleExist:article]) {
            [self.articleRepository saveArticle:article];
        }
    }];
}

@end
