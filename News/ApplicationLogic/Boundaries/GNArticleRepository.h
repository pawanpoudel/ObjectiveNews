@import Foundation;
@class GNArticle;

@protocol GNArticleRepository <NSObject>

- (void)saveArticle:(GNArticle *)article;
- (BOOL)doesArticleExist:(GNArticle *)article;

@end
