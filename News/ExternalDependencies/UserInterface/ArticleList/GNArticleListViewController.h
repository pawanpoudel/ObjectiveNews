#import "GNFetchArticlesUseCaseBoundaries.h"

@import UIKit;
@class GNCoreDataStack;
@class GNArticleListTableDataSource;

@interface GNArticleListViewController : UIViewController <GNFetchArticlesUseCaseOutput>

@property (nonatomic) id<GNFetchArticlesUseCaseInput> fetchArticlesUseCaseInput;
@property (nonatomic) GNArticleListTableDataSource *dataSource;
@property (nonatomic) GNCoreDataStack *coreDataStack;

@end
